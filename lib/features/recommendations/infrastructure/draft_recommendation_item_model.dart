// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/recommendations/domain/draft_recommendation_item.dart';

class DraftRecommendationItemModel extends Equatable {
  final String id;
  final String ownerID;
  final String? landingPageID;
  final String? defaultLandingPageID;
  final String? promoterName;
  final String? name;
  final String? serviceProviderName;

  const DraftRecommendationItemModel({
    required this.id,
    required this.ownerID,
    this.landingPageID,
    this.defaultLandingPageID,
    this.promoterName,
    this.name,
    this.serviceProviderName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerID': ownerID,
      'landingPageID': landingPageID,
      'defaultLandingPageID': defaultLandingPageID,
      'promoterName': promoterName,
      'name': name,
      'serviceProviderName': serviceProviderName,
    };
  }

  factory DraftRecommendationItemModel.fromDomain(DraftRecommendationItem item) {
    return DraftRecommendationItemModel(
      id: item.id,
      ownerID: item.ownerID,
      landingPageID: item.landingPageID,
      defaultLandingPageID: item.defaultLandingPageID,
      promoterName: item.promoterName,
      name: item.name,
      serviceProviderName: item.serviceProviderName,
    );
  }

  DraftRecommendationItem toDomain() {
    return DraftRecommendationItem(
      id: id,
      ownerID: ownerID,
      landingPageID: landingPageID,
      defaultLandingPageID: defaultLandingPageID,
      promoterName: promoterName,
      name: name,
      serviceProviderName: serviceProviderName,
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
