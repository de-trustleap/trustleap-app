import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RecommendationItemModel_CopyWith", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test(
        "set promoterName with copyWith should set promoterName for resulting object",
        () {
      // Given
      final recoModel = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test2",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          reason: "",
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = recoModel.copyWith(promoterName: "Test2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_ToMap", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("check if model is successfully converted to a map", () {
      // Given
      final recoModel = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      final expectedResult = {
        'id': "1",
        "name": "Test",
        "landingPageID": "2",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "userID": "1",
        "reason": "",
        "statusLevel": "recommendationSend",
        "statusTimestamps": null,
        "promoterImageDownloadURL": null,
        "recommendationType": null,
        "statusCounts": null,
        "campaignName": null,
        "campaignDurationDays": null,
        "expiresAt": date.toIso8601String(),
        "createdAt": date.toIso8601String(),
        "lastUpdated": null,
        "compensation": null
      };
      // When
      final result = recoModel.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_FromMap", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        'id': "1",
        "name": "Test",
        "landingPageID": "2",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "userID": "1",
        "statusLevel": "recommendationSend",
        "statusTimestamps": null,
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date),
        "lastUpdated": null
      };
      final expectedResult = RecommendationItemModel(
          id: "",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: null,
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = RecommendationItemModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_FromMap_WithCompensation", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("parses compensation map when present", () {
      // Given
      final map = {
        'id': "1",
        "name": "Test",
        "landingPageID": "2",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "userID": "1",
        "statusLevel": "appointment",
        "statusTimestamps": null,
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date),
        "lastUpdated": null,
        "compensation": {
          "status": "manualIssued",
          "timestamps": {"manualIssued": "2025-01-01T00:00:00.000"},
          "amount": 50.0,
          "currency": "EUR",
        },
      };
      // When
      final result = RecommendationItemModel.fromMap(map);
      // Then
      expect(result.compensation, isNotNull);
      expect(result.compensation!["status"], "manualIssued");
      expect(result.compensation!["amount"], 50.0);
    });
  });

  group("RecommendationItemModel_ToDomain_WithCompensation", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("converts compensation map to domain RecommendationCompensation", () {
      // Given
      final ts = DateTime(2025, 1, 1);
      final model = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "appointment",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: {
            "status": "manualIssued",
            "timestamps": {"manualIssued": ts.toIso8601String()},
            "amount": 50.0,
            "currency": "EUR",
          },
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = model.toDomain() as PersonalizedRecommendationItem;
      // Then
      expect(result.compensation, isNotNull);
      expect(result.compensation!.status,
          RecommendationCompensationStatus.manualIssued);
      expect(result.compensation!.amount, 50.0);
      expect(result.compensation!.currency, "EUR");
      expect(
          result.compensation!.timestamps[RecommendationCompensationStatus.manualIssued],
          ts);
    });
  });

  group("RecommendationItemModel_FromFirestore", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        'id': "1",
        "name": "Test",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "landingPageID": "2",
        "userID": "1",
        "statusLevel": "recommendationSend",
        "statusTimestamps": null,
        "reason": null,
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date),
        "lastUpdated": null
      };
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: null,
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = RecommendationItemModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("RecommendationItemModel_ToDomain", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test(
        "check if conversion from RecommendationItemModel to RecommendationItem works",
        () {
      final model = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      final expectedResult = PersonalizedRecommendationItem(
          id: "1",
          name: "Test",
          reason: "",
          landingPageID: "2",
          promotionTemplate: null,
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_FromDomain", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test(
        "check if conversion from RecommendationItem to RecommendationItemModel works",
        () {
      // Given
      final model = PersonalizedRecommendationItem(
          id: "1",
          name: "Test",
          reason: null,
          landingPageID: "2",
          promotionTemplate: null,
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: null,
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: "personalized",
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // When
      final result = RecommendationItemModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_Props", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("check if value equality works", () {
      // Given
      final reco1 = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      final reco2 = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          userID: "1",
          reason: "",
          statusLevel: "recommendationSend",
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          recommendationType: null,
          statusCounts: null,
          campaignName: null,
          campaignDurationDays: null,
          expiresAt: date,
          createdAt: date,
          lastUpdated: null);
      // Then
      expect(reco1, reco2);
    });
  });
}
