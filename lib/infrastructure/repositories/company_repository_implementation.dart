// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/company_model.dart';

class CompanyRepositoryImplementation implements CompanyRepository {
  final FirebaseFirestore firestore;

  CompanyRepositoryImplementation({
    required this.firestore,
  });

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
    final pendingCompanyRequestsCollection = firestore.collection("pendingCompanyRequests");
    final companyModel = CompanyModel.fromDomain(company);
    try {
      await pendingCompanyRequestsCollection.doc(companyModel.id).set(companyModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  } //TODO: Company Registration in einen Backend Call auslagern. Hier muss zum einen der pending Request erstellt werden und zum anderen dem User der pendingCompanyRequest zugewiesen werden.
    //TODO: Wenn dieser schon eine hat muss ein Fehler geworfen werden!
    //TODO: Pending Request braucht auch noch einen Timestamp
}
