import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';

abstract class PagebuilderRepository {
  Future<Either<DatabaseFailure, PageBuilderPage>> getLandingPageContent(String id);
  Future<Either<DatabaseFailure, Unit>> saveLandingPageContent(PageBuilderPage page);
}