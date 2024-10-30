import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class LandingPageRepository {
  Stream<Either<DatabaseFailure, CustomUser>> observeAllLandingPages();

  Future<Either<DatabaseFailure, List<LandingPage>>> getAllLandingPages(
      List<String> ids);

  Future<Either<DatabaseFailure, Unit>> createLandingPage(
      LandingPage landingPage, Uint8List imageData, bool imageHasChanged);

  Future<Either<DatabaseFailure, Unit>> deleteLandingPage(
      String id, String ownerID);

  Future<Either<DatabaseFailure, Unit>> editLandingPage(
      LandingPage landingPage, Uint8List? imageData, bool imageHasChanged);

  Future<Either<DatabaseFailure, Unit>> duplicateLandingPage(String id);

  Future<Either<DatabaseFailure, Unit>> toggleLandingPageActivity(String id, bool isActive, String userId);
      
  Future<Either<DatabaseFailure, LandingPage>> getLandingPage(String id);
}
