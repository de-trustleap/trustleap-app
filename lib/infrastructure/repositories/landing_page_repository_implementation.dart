// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class LandingPageRepositoryImplementation implements LandingPageRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  LandingPageRepositoryImplementation(
      {required this.firestore, required this.firebaseFunctions});

  @override
  Stream<Either<DatabaseFailure, CustomUser>> observeAllLandingPages() async* {
    final userDoc = await firestore.userDocument();
    var requestedUser = await userDoc.get();
    if (!requestedUser.exists) {
      yield left(NotFoundFailure());
    }
    yield* userDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model = UserModel.fromFirestore(document, snapshot.id).toDomain();
      return right<DatabaseFailure, CustomUser>(model);
    }).handleError((e) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      } else {
        return left(BackendFailure());
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPage>>> getAllLandingPages(
      List<String> ids) async {
    final landingPagesCollection = firestore.collection("landingPages");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<LandingPage> landingPages = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await landingPagesCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model =
              LandingPageModel.fromFirestore(doc, snapshot.id).toDomain();
          landingPages.add(model);
        }
      }

      landingPages.sort((a, b) {
        if (b.isDefaultPage ?? false) {
          return 1;
        } else if (a.isDefaultPage ?? false) {
          return -1;
        }
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        } else {
          return a.id.value.compareTo(b.id.value);
        }
      });
      return right(landingPages);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> createLandingPage(
      LandingPage landingPage,
      Uint8List imageData,
      bool imageHasChanged) async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("createLandingPage");
    final landingPageModel = LandingPageModel.fromDomain(landingPage);
    try {
      await callable.call({
        "id": landingPageModel.id,
        "name": landingPageModel.name,
        "description": landingPageModel.description,
        "promotionTemplate": landingPageModel.promotionTemplate,
        "ownerID": landingPageModel.ownerID,
        "imageData": base64Encode(imageData),
        "imageHasChanged": imageHasChanged,
        "isDefaultPage": landingPageModel.isDefaultPage
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deleteLandingPage(
      String id, String ownerID) async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("deleteLandingPage");
    try {
      await callable.call({"id": id, "ownerID": ownerID});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> editLandingPage(LandingPage landingPage,
      Uint8List? imageData, bool imageHasChanged) async {
    HttpsCallable callable = firebaseFunctions.httpsCallable("editLandingPage");
    try {
      await callable.call({
        "id": landingPage.id.value,
        "title": landingPage.name,
        "description": landingPage.description,
        "promotionTemplate": landingPage.promotionTemplate,
        "ownerID": landingPage.ownerID?.value,
        "imageData": imageData != null ? base64Encode(imageData) : null,
        "imageHasChanged": imageHasChanged,
        "isDefaultPage": landingPage.isDefaultPage
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> duplicateLandingPage(String id) async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("duplicateLandingPage");
    try {
      await callable.call({"id": id});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
