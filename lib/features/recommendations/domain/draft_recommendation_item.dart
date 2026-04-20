// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';

class DraftRecommendationItem extends Equatable {
  final String id;
  final String ownerID;
  final String? landingPageID;
  final String? defaultLandingPageID;
  final String? promoterName;
  final String? name;
  final String? serviceProviderName;

  const DraftRecommendationItem({
    required this.id,
    required this.ownerID,
    this.landingPageID,
    this.defaultLandingPageID,
    this.promoterName,
    this.name,
    this.serviceProviderName,
  });

  factory DraftRecommendationItem.fromRecommendationItem(
    RecommendationItem recommendation, {
    required String ownerID,
  }) {
    return DraftRecommendationItem(
      id: recommendation.id,
      ownerID: ownerID,
      landingPageID: recommendation.landingPageID,
      defaultLandingPageID: recommendation.defaultLandingPageID,
      promoterName: recommendation.promoterName,
      name: recommendation.displayName,
      serviceProviderName: recommendation.serviceProviderName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerID,
        landingPageID,
        defaultLandingPageID,
        promoterName,
        name,
        serviceProviderName,
      ];
}
