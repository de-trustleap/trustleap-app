// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/company_model.dart';
import 'package:finanzbegleiter/infrastructure/models/company_request_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

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

  @override
  Stream<Either<DatabaseFailure, List<CompanyRequest>>>
      observeCompanyRequests() async* {
    final requestCollection = firestore.collection("pendingCompanyRequests");
    yield* requestCollection.orderBy("createdAt").snapshots().map((snapshot) {
      List<CompanyRequest> requests = [];
      var documents = snapshot.docs;
      for (final doc in documents) {
        requests.add(
            CompanyRequestModel.fromFirestore(doc.data(), doc.id).toDomain());
      }
      return right<DatabaseFailure, List<CompanyRequest>>(requests);
    }).handleError((e) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      } else {
        return left(BackendFailure());
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, List<CustomUser>>>
      getAllUsersForPendingCompanyRequests(List<String> ids) async {
    final usersCollection = firestore.collection("users");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<CustomUser> users = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await usersCollection
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UserModel.fromFirestore(doc, snapshot.id).toDomain();
          // do not fetch deactivated users
          if (model.deletesAt == null) {
            users.add(model);
          }
        }
      }
      return right(users);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> processCompanyRequest(
      String id, String userID, bool accepted) async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("processCompanyRequest");
    try {
      await callable.call({"id": id, "accepted": accepted, "userID": userID});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
