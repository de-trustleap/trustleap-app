import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/archived_recommendation_item_model.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ArchivedRecommendationItemModel_CopyWith", () {
    final date = DateTime.now();
    test(
        "set promoterName with copyWith should set promoterName for resulting object",
        () {
      // Given
      final model = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test new",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      // When
      final result = model.copyWith(promoterName: "Test new");
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_ToMap", () {
    final date = DateTime.now();
    test("check if model is successfully converted to a map", () {
      // Given
      final model = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      final expectedResult = {
        "id": "1",
        "reason": "Test",
        "landingPageID": "test-landing-page",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "recommendationType": "personalized",
        "campaignName": null,
        "campaignDurationDays": null,
        "statusCounts": null,
        "compensation": null,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_FromMap", () {
    final date = DateTime.now();
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "reason": "Test",
        "landingPageID": "test-landing-page",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "recommendationType": "personalized",
      };
      final expectedResult = ArchivedRecommendationItemModel(
          id: "",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      // When
      final result = ArchivedRecommendationItemModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if statusTimestamps are correctly parsed from map", () {
      // Given
      final ts0 = DateTime(2024, 1, 1, 12, 0, 0);
      final ts1 = DateTime(2024, 1, 2, 8, 0, 0);
      final map = {
        "id": "1",
        "reason": "Test",
        "landingPageID": "test-landing-page",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "recommendationType": "personalized",
        "statusTimestamps": {
          "0": ts0.toIso8601String(),
          "1": ts1.toIso8601String(),
        },
      };
      // When
      final result = ArchivedRecommendationItemModel.fromMap(map);
      // Then
      expect(result.statusTimestamps?[0], ts0);
      expect(result.statusTimestamps?[1], ts1);
      expect(result.statusTimestamps?.length, 2);
    });
  });

  group("ArchivedRecommendationItemModel_FromMap_WithCompensation", () {
    final date = DateTime.now();
    test("parses compensation map when present", () {
      // Given
      final map = {
        "id": "1",
        "reason": "Test",
        "landingPageID": "test-landing-page",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "recommendationType": "personalized",
        "compensation": {
          "status": "voucherSent",
          "timestamps": {"voucherSent": "2024-06-01T00:00:00.000"},
          "amount": 25.0,
          "currency": "EUR",
        },
      };
      // When
      final result = ArchivedRecommendationItemModel.fromMap(map);
      // Then
      expect(result.compensation, isNotNull);
      expect(result.compensation!["status"], "voucherSent");
      expect(result.compensation!["amount"], 25.0);
    });
  });

  group("ArchivedRecommendationItemModel_ToDomain_WithCompensation", () {
    final date = DateTime.now();
    test("converts compensation map to domain RecommendationCompensation", () {
      // Given
      final ts = DateTime(2024, 6, 1);
      final model = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null,
          compensation: {
            "status": "voucherSent",
            "timestamps": {"voucherSent": ts.toIso8601String()},
            "amount": 25.0,
            "currency": "EUR",
          });
      // When
      final result = model.toDomain();
      // Then
      expect(result.compensation, isNotNull);
      expect(result.compensation!.status,
          RecommendationCompensationStatus.voucherSent);
      expect(result.compensation!.amount, 25.0);
      expect(result.compensation!.currency, "EUR");
      expect(
          result.compensation!.timestamps[RecommendationCompensationStatus.voucherSent],
          ts);
    });
  });

  group("ArchivedRecommendationItemModel_FromFirestore", () {
    final date = DateTime.now();
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "1",
        "reason": "Test",
        "landingPageID": "test-landing-page",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "recommendationType": "personalized",
      };
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      // When
      final result = ArchivedRecommendationItemModel.fromFirestore(map, "1");
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_ToDomain", () {
    final date = DateTime.now();
    test(
        "check if conversion from ArchivedRecommendationItemModel to ArchivedRecommendationItem works",
        () {
      // Given
      final model = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      final expectedResult = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: RecommendationType.personalized,
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null, compensation: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_FromDomain", () {
    final date = DateTime.now();
    test(
        "check if conversion from ArchivedRecommendationItem to ArchivedRecommendationItemModel works",
        () {
      // Given
      final model = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: RecommendationType.personalized,
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null, compensation: null);
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      // When
      final result = ArchivedRecommendationItemModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_Props", () {
    final date = DateTime.now();
    test("check if value equality works", () {
      // Given
      final model = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      final model2 = ArchivedRecommendationItemModel(
          id: "1",
          reason: "Test",
          landingPageID: "test-landing-page",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          recommendationType: "personalized",
          campaignName: null,
          campaignDurationDays: null,
          statusCounts: null,
          statusTimestamps: null, compensation: null);
      // Then
      expect(model, model2);
    });
  });
}
