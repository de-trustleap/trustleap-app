import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_landingpage.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_promoter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonData {
  const SkeletonData._();

  static const promoterRanking = [
    DashboardRankedPromoter(promoterName: "Promoter Name", rank: 1, completedRecommendationsCount: 12),
    DashboardRankedPromoter(promoterName: "Promoter Name", rank: 2, completedRecommendationsCount: 8),
    DashboardRankedPromoter(promoterName: "Promoter Name", rank: 3, completedRecommendationsCount: 5),
  ];

  static const landingpageRanking = [
    DashboardRankedLandingpage(landingPageName: "Landing Page Name", rank: 1, completedRecommendationsCount: 12),
    DashboardRankedLandingpage(landingPageName: "Landing Page Name", rank: 2, completedRecommendationsCount: 8),
    DashboardRankedLandingpage(landingPageName: "Landing Page Name", rank: 3, completedRecommendationsCount: 5),
  ];

  static Widget chart() => const SizedBox(
        width: double.infinity,
        height: 300,
        child: Bone(borderRadius: BorderRadius.all(Radius.circular(12))),
      );

  static final Promoter promoter = Promoter(
    id: UniqueID.fromUniqueString("skeleton"),
    firstName: "Promoter",
    lastName: "Name",
    email: "promoter@example.com",
    registered: true,
    createdAt: DateTime(2024, 1, 1),
  );

  static final CustomUser user = CustomUser(
    id: UniqueID.fromUniqueString("skeleton"),
  );

  static final LandingPage landingPage = LandingPage(
    id: UniqueID.fromUniqueString("skeleton"),
    name: "Landing Page Name",
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    lastUpdatedAt: DateTime(2024, 1, 1),
    totalVisits: 123,
  );
}
