import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/infrastructure/models/archived_recommendation_item_model.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          name: "Test",
          reason: "Test",
          promoterName: "Test new",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final expectedResult = {
        "id": "1",
        "name": "Test",
        "reason": "Test",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "expiresAt": Timestamp.fromDate(date)
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
        "name": "Test",
        "reason": "Test",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "expiresAt": Timestamp.fromDate(date)
      };
      final expectedResult = ArchivedRecommendationItemModel(
          id: "",
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      // When
      final result = ArchivedRecommendationItemModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedRecommendationItemModel_FromFirestore", () {
    final date = DateTime.now();
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "1",
        "name": "Test",
        "reason": "Test",
        "promoterName": "Test",
        "serviceProviderName": "Test",
        "success": true,
        "userID": "2",
        "createdAt": Timestamp.fromDate(date),
        "finishedTimeStamp": Timestamp.fromDate(date),
        "expiresAt": Timestamp.fromDate(date)
      };
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final expectedResult = ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final expectedResult = ArchivedRecommendationItemModel(
          id: "1",
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
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
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      final model2 = ArchivedRecommendationItemModel(
          id: "1",
          name: "Test",
          reason: "Test",
          promoterName: "Test",
          serviceProviderName: "Test",
          success: true,
          userID: "2",
          createdAt: date,
          finishedTimeStamp: date,
          expiresAt: date);
      // Then
      expect(model, model2);
    });
  });
}
