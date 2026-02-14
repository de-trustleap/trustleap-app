import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_landingpage.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_promoter.dart';

abstract class DashboardRepository {
  Future<Either<DatabaseFailure, List<DashboardRankedPromoter>>>
      getTop3Promoters(List<String> registeredPromoterIDs,
          {TimePeriod? timePeriod});
  Future<Either<DatabaseFailure, List<DashboardRankedLandingpage>>>
      getTop3LandingPages(List<String> landingPageIDs,
          {TimePeriod? timePeriod});
}
