import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_organization.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';

abstract class TremendousRepository {
  Future<Either<DatabaseFailure, String>> getAuthorizationUrl();

  Future<Either<DatabaseFailure, bool>> isConnected();

  Future<Either<DatabaseFailure, TremendousOrganization?>> getOrganization();

  Future<Either<DatabaseFailure, Unit>> disconnect();

  Future<Either<DatabaseFailure, Unit>> refreshToken();

  Stream<Either<DatabaseFailure, bool>> observeConnectionStatus();

  Future<Either<DatabaseFailure, List<TremendousProduct>>> getProductList();

  Future<Either<DatabaseFailure, List<TremendousFundingSource>>>
      getFundingSourcesList();
}
