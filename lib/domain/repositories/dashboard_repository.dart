import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_promoter.dart';

abstract class DashboardRepository {
  Future<Either<DatabaseFailure, List<DashboardRankedPromoter>>> getTop3Promoters(
      List<String> registeredPromoterIDs, {TimePeriod? timePeriod});
}
