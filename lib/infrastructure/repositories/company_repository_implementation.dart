// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/company_model.dart';
import 'package:finanzbegleiter/infrastructure/models/company_request_model.dart';

class CompanyRepositoryImplementation implements CompanyRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  CompanyRepositoryImplementation(
      {required this.firestore, required this.firebaseFunctions});

  @override
  Stream<Either<DatabaseFailure, Company>> observeCompany(
      String companyID) async* {
    final companyDoc = firestore.collection("companies").doc(companyID);
    var requestedCompany = await companyDoc.get();
    if (!requestedCompany.exists) {
      yield left(NotFoundFailure());
    }
    yield* companyDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model = CompanyModel.fromFirestore(document, snapshot.id).toDomain();
      return right<DatabaseFailure, Company>(model);
    }).handleError((e) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      } else {
        return left(BackendFailure());
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, Unit>> updateCompany(Company company) async {
    final companyCollection = firestore.collection("companies");
    final companyModel = CompanyModel.fromDomain(company);
    try {
      await companyCollection.doc(companyModel.id).update(companyModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Company>> getCompany(String companyID) async {
    final companyDoc = firestore.collection("companies").doc(companyID);
    try {
      final snapshot = await companyDoc.get();
      if (snapshot.data() == null) {
        return left(NotFoundFailure());
      } else {
        final company =
            CompanyModel.fromFirestore(snapshot.data()!, snapshot.id)
                .toDomain();
        return right(company);
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> registerCompany(Company company) async {
    HttpsCallable callable = firebaseFunctions.httpsCallable("registerCompany");
    final companyModel = CompanyModel.fromDomain(company);
    try {
      await callable.call({
        "id": companyModel.id,
        "name": companyModel.name,
        "industry": companyModel.industry,
        "websiteURL": companyModel.websiteURL,
        "address": companyModel.address,
        "postCode": companyModel.postCode,
        "place": companyModel.place,
        "phoneNumber": companyModel.phoneNumber,
        "ownerID": companyModel.ownerID
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, CompanyRequest>> getPendingCompanyRequest(
      String id) async {
    final pendingCompanyRequestRef =
        firestore.collection("pendingCompanyRequests").doc(id);
    try {
      final snapshot = await pendingCompanyRequestRef.get();
      if (snapshot.data() == null) {
        return left(NotFoundFailure());
      } else {
        final request =
            CompanyRequestModel.fromFirestore(snapshot.data()!, snapshot.id)
                .toDomain();
        return right(request);
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
