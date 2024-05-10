import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class LandingPageRepository{
  Stream<Either<DatabaseFailure, CustomUser>> observeAllLandingPages();

  Future<Either<DatabaseFailure, List<LandingPage>>> getAllLandingPages(List<String> ids);

  Future<Either<DatabaseFailure, Unit>> createLandingPage(LandingPage landingPage);

}
