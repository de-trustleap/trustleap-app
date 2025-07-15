import 'package:finanzbegleiter/application/dashboard/overview/cubit/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:flutter/material.dart';

class DashboardRecommendationsHelper {
  /// Creates dropdown items for promoter selection including an "Alle" option
  static List<DropdownMenuItem<String?>> getPromoterItems(
      List<PromoterRecommendations> promoterRecommendations) {
    final items = <DropdownMenuItem<String?>>[];

    // "Alle" Option
    items.add(const DropdownMenuItem<String?>(
      value: null,
      child: Text("Alle"),
    ));

    // Promoter Options
    for (final promoterRec in promoterRecommendations) {
      final promoter = promoterRec.promoter;
      final displayName =
          "${promoter.firstName ?? ''} ${promoter.lastName ?? ''}".trim();

      items.add(DropdownMenuItem<String?>(
        value: promoter.id.value,
        child: Text(displayName.isNotEmpty ? displayName : "Unbekannter Promoter"),
      ));
    }

    return items;
  }

  /// Creates promoter display name from first and last name
  static String getPromoterDisplayName(String? firstName, String? lastName) {
    final displayName = "${firstName ?? ''} ${lastName ?? ''}".trim();
    return displayName.isNotEmpty ? displayName : "Unbekannter Promoter";
  }

  /// Filters recommendations based on selected promoter and user role
  static List<UserRecommendation> getFilteredRecommendations({
    required DashboardRecommendationsGetRecosSuccessState state,
    required String? selectedPromoterId,
    required Role userRole,
  }) {
    // If no promoter selected or user is promoter, return all recommendations
    if (selectedPromoterId == null || userRole != Role.company) {
      return state.recommendation;
    }

    // Filter by selected promoter
    if (state.promoterRecommendations != null) {
      try {
        final selectedPromoterRec = state.promoterRecommendations!.firstWhere(
          (promoterRec) => promoterRec.promoter.id.value == selectedPromoterId,
        );
        return selectedPromoterRec.recommendations;
      } catch (e) {
        // Promoter not found, return empty list instead of throwing
        return [];
      }
    }

    return state.recommendation;
  }
}
