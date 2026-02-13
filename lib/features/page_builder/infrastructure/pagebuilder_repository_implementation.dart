// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_global_styles_reverse_resolver.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_page_model.dart';
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

      final data = document.data()!;
      var model = PageBuilderPageModel.fromFirestore(data, id).toDomain();
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
    var pageMap = pageModel.toMap();

    if (page.globalStyles != null) {
      final reverseResolver =
          PagebuilderGlobalStylesReverseResolver(page.globalStyles!);
      pageMap = reverseResolver.applyTokensToMap(pageMap);
    }

    try {
      await callable.call({"appCheckToken": appCheckToken, "page": pageMap});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
