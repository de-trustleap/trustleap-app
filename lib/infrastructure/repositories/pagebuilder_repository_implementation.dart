// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_page_model.dart';

class PageBuilderRepositoryImplementation implements PagebuilderRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  PageBuilderRepositoryImplementation(
      {required this.firestore, required this.firebaseFunctions});

  @override
  Future<Either<DatabaseFailure, PageBuilderPage>> getLandingPageContent(
      String id) async {
    print("GET MODEL");
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

  /*@override
  Future<Either<DatabaseFailure, Unit>> saveLandingPageContent(
      PageBuilderPage page) async {
    final landingPageContentCollection =
        firestore.collection("landingPagesContent");
    try {
      await landingPageContentCollection
          .doc(page.id.value)
          .update(PageBuilderPageModel.fromDomain(page).toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }*/

  @override
  Future<Either<DatabaseFailure, Unit>> saveLandingPageContent(
      PageBuilderPage page) async {
    print("IMAGE: ${page.sections?.first?.widgets?.last?.properties}");
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("updatePageContent");
    final pageModel = PageBuilderPageModel.fromDomain(page);
    try {
      await callable.call({"page": pageModel.toMap()});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
