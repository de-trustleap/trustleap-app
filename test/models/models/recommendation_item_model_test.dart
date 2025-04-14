import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';
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
          expiresAt: date,
          createdAt: date);
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test2",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
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
          expiresAt: date,
          createdAt: date);
      final expectedResult = {
        'id': "1",
        "name": "Test",
        "landingPageID": "2",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date)
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
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date)
      };
      final expectedResult = RecommendationItemModel(
          id: "",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
      // When
      final result = RecommendationItemModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("RecommendationItemModel_FromFirestore", () {
    DateTime date = DateTime(2025, 4, 14, 13, 30);
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        'id': "1",
        "name": "Test",
        "landingPageID": "2",
        "promoterName": "Test",
        "serviceProviderName": "",
        "defaultLandingPageID": "",
        "expiresAt": Timestamp.fromDate(date),
        "createdAt": Timestamp.fromDate(date)
      };
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
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
          expiresAt: date,
          createdAt: date);
      final expectedResult = RecommendationItem(
          id: "1",
          name: "Test",
          reason: null,
          landingPageID: "2",
          promotionTemplate: null,
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
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
      final model = RecommendationItem(
          id: "1",
          name: "Test",
          reason: null,
          landingPageID: "2",
          promotionTemplate: null,
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
      final expectedResult = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
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
          expiresAt: date,
          createdAt: date);
      final reco2 = RecommendationItemModel(
          id: "1",
          name: "Test",
          landingPageID: "2",
          promoterName: "Test",
          serviceProviderName: "",
          defaultLandingPageID: "",
          expiresAt: date,
          createdAt: date);
      // Then
      expect(reco1, reco2);
    });
  });
}
