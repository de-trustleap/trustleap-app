// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_page_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class PageBuilderRepositoryImplementation implements PagebuilderRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  PageBuilderRepositoryImplementation(
      {required this.firestore,
      required this.firebaseFunctions,
      required this.appCheck});

  @override
  Future<Either<DatabaseFailure, PageBuilderPage>> getLandingPageContent(
      String id) async {
    final landingPageContentCollection =
        firestore.collection("landingPagesContent");
    try {
      final document = await landingPageContentCollection.doc(id).get();
      if (!document.exists && document.data() != null) {
        return left(NotFoundFailure());
      }
      var model =
          PageBuilderPageModel.fromFirestore(document.data()!, id).toDomain();
      return right(model);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> saveLandingPageContent(
      PageBuilderPage page) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("updatePageContent");
    final pageModel = PageBuilderPageModel.fromDomain(page);
    String jsonString = jsonEncode(pageModel.toMap());
    print(jsonString);
    try {
      await callable
          .call({"appCheckToken": appCheckToken, "page": pageModel.toMap()});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
