// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_global_styles_reverse_resolver.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_page_model.dart';

class PageBuilderRepositoryImplementation implements PagebuilderRepository {
  final FirebaseFirestore firestore;
  final CloudFunctionsService cloudFunctions;

  PageBuilderRepositoryImplementation(
      {required this.firestore, required this.cloudFunctions});

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
    final pageModel = PageBuilderPageModel.fromDomain(page);
    var pageMap = pageModel.toMap();

    if (page.globalStyles != null) {
      final reverseResolver =
          PagebuilderGlobalStylesReverseResolver(page.globalStyles!);
      pageMap = reverseResolver.applyTokensToMap(pageMap);
    }

    return cloudFunctions.call(
      'updatePageContent',
      {'page': pageMap},
      (_) => unit,
    );
  }
}
