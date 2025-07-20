import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/last_edit.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/infrastructure/models/user_recommendation_model.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UserRecommendationModel_CopyWith", () {
    test("set priority with copyWith should set priority for resulting object", () {
      // Given
      const model = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "medium",
        notes: "Test notes",
        recommendation: null,
      );
      const expectedResult = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
      );
      
      // When
      final result = model.copyWith(priority: "high");
      
      // Then
      expect(result, expectedResult);
    });

    test("set notes with copyWith should set notes for resulting object", () {
      // Given
      const model = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "medium",
        notes: "Test notes",
        recommendation: null,
      );
      
      // When
      final result = model.copyWith(notes: "Updated notes");
      
      // Then
      expect(result.notes, "Updated notes");
      expect(result.id, model.id);
      expect(result.priority, model.priority);
    });

    test("set lastEdits with copyWith should set lastEdits for resulting object", () {
      // Given
      const model = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "medium",
        notes: "Test notes",
        recommendation: null,
      );
      
      final newEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      // When
      final result = model.copyWith(lastEdits: newEdits);
      
      // Then
      expect(result.lastEdits, newEdits);
      expect(result.lastEdits.length, 1);
    });
  });

  group("UserRecommendationModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final lastEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      final viewedByUsers = [
        {
          "userID": "user123",
          "viewedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final model = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: lastEdits,
        viewedByUsers: viewedByUsers,
      );

      final expectedResult = {
        "id": "rec1",
        "recoID": "reco1",
        "userID": "user1",
        "priority": "high",
        "notes": "Test notes",
        "lastEdits": lastEdits,
        "viewedByUsers": viewedByUsers,
      };
      
      // When
      final result = model.toMap();
      
      // Then
      expect(result, expectedResult);
    });
  });

  group("UserRecommendationModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final lastEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      final viewedByUsers = [
        {
          "userID": "user123",
          "viewedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final map = {
        "recommendationID": "reco1",
        "userID": "user1",
        "priority": "high",
        "notes": "Test notes",
        "recommendation": null,
        "lastEdits": lastEdits,
        "viewedByUsers": viewedByUsers,
      };
      
      final expectedResult = UserRecommendationModel(
        id: "",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: lastEdits,
        viewedByUsers: viewedByUsers,
      );
      
      // When
      final result = UserRecommendationModel.fromMap(map);
      
      // Then
      expect(result, expectedResult);
    });

    test("check if map with null values is successfully converted to model", () {
      // Given
      final map = <String, dynamic>{
        "recommendationID": null,
        "userID": null,
        "priority": null,
        "notes": null,
        "recommendation": null,
        "lastEdits": null,
        "viewedByUsers": null,
      };
      
      const expectedResult = UserRecommendationModel(
        id: "",
        recoID: null,
        userID: null,
        priority: null,
        notes: null,
        recommendation: null,
        lastEdits: [],
        viewedByUsers: [],
      );
      
      // When
      final result = UserRecommendationModel.fromMap(map);
      
      // Then
      expect(result, expectedResult);
    });
  });

  group("UserRecommendationModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "recommendationID": "reco1",
        "userID": "user1",
        "priority": "medium",
        "notes": "Test notes",
      };
      
      const expectedResult = UserRecommendationModel(
        id: "rec123",
        recoID: "reco1",
        userID: "user1",
        priority: "medium",
        notes: "Test notes",
        recommendation: null,
      );
      
      // When
      final result = UserRecommendationModel.fromFirestore(map, "rec123");
      
      // Then
      expect(result, expectedResult);
    });
  });

  group("UserRecommendationModel_ToDomain", () {
    test("check if conversion from UserRecommendationModel to UserRecommendation works", () {
      // Given
      final lastEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      final viewedByUsers = [
        {
          "userID": "user123",
          "viewedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final model = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: lastEdits,
        viewedByUsers: viewedByUsers,
      );

      final expectedLastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      final expectedLastViewed = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      // When
      final result = model.toDomain();

      // Then
      expect(result.id.value, "rec1");
      expect(result.recoID, "reco1");
      expect(result.userID, "user1");
      expect(result.priority, RecommendationPriority.high);
      expect(result.notes, "Test notes");
      expect(result.recommendation, isNull);
      expect(result.lastEdits.length, 1);
      expect(result.lastEdits.first, expectedLastEdit);
      expect(result.viewedByUsers.length, 1);
      expect(result.viewedByUsers.first, expectedLastViewed);
    });

    test("check if priority conversion handles all enum values correctly", () {
      // Given & When & Then
      const lowModel = UserRecommendationModel(
        id: "rec1", recoID: "reco1", userID: "user1", 
        priority: "low", notes: "Test", recommendation: null,
      );
      expect(lowModel.toDomain().priority, RecommendationPriority.low);

      const mediumModel = UserRecommendationModel(
        id: "rec1", recoID: "reco1", userID: "user1", 
        priority: "medium", notes: "Test", recommendation: null,
      );
      expect(mediumModel.toDomain().priority, RecommendationPriority.medium);

      const highModel = UserRecommendationModel(
        id: "rec1", recoID: "reco1", userID: "user1", 
        priority: "high", notes: "Test", recommendation: null,
      );
      expect(highModel.toDomain().priority, RecommendationPriority.high);

      const nullModel = UserRecommendationModel(
        id: "rec1", recoID: "reco1", userID: "user1", 
        priority: null, notes: "Test", recommendation: null,
      );
      expect(nullModel.toDomain().priority, isNull);

      const unknownModel = UserRecommendationModel(
        id: "rec1", recoID: "reco1", userID: "user1", 
        priority: "unknown", notes: "Test", recommendation: null,
      );
      expect(unknownModel.toDomain().priority, RecommendationPriority.medium);
    });
  });

  group("UserRecommendationModel_FromDomain", () {
    test("check if conversion from UserRecommendation to UserRecommendationModel works", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      final userRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1",
        userID: "user1",
        priority: RecommendationPriority.high,
        notes: "Test notes",
        recommendation: null,
        lastEdits: [lastEdit],
        viewedByUsers: [lastViewed],
      );

      final expectedLastEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final expectedViewedByUsers = [
        {
          "userID": "user123",
          "viewedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final expectedResult = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: expectedLastEdits,
        viewedByUsers: expectedViewedByUsers,
      );
      
      // When
      final result = UserRecommendationModel.fromDomain(userRecommendation);
      
      // Then
      expect(result, expectedResult);
    });

    test("check if priority conversion handles all enum values correctly", () {
      // Given & When & Then
      final lowRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1", userID: "user1", priority: RecommendationPriority.low,
        notes: "Test", recommendation: null,
      );
      expect(UserRecommendationModel.fromDomain(lowRecommendation).priority, "low");

      final mediumRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1", userID: "user1", priority: RecommendationPriority.medium,
        notes: "Test", recommendation: null,
      );
      expect(UserRecommendationModel.fromDomain(mediumRecommendation).priority, "medium");

      final highRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1", userID: "user1", priority: RecommendationPriority.high,
        notes: "Test", recommendation: null,
      );
      expect(UserRecommendationModel.fromDomain(highRecommendation).priority, "high");

      final nullRecommendation = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1", userID: "user1", priority: null,
        notes: "Test", recommendation: null,
      );
      expect(UserRecommendationModel.fromDomain(nullRecommendation).priority, isNull);
    });
  });

  group("UserRecommendationModel_Props", () {
    test("check if value equality works", () {
      // Given
      final lastEdits = [
        {
          "fieldName": "priority",
          "editedBy": "user123",
          "editedAt": "2023-12-25T10:30:00.000",
        }
      ];
      
      final model1 = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: lastEdits,
        viewedByUsers: const [],
      );
      
      final model2 = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
        lastEdits: lastEdits,
        viewedByUsers: const [],
      );
      
      // Then
      expect(model1, model2);
    });

    test("check if value equality fails with different values", () {
      // Given
      const model1 = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "high",
        notes: "Test notes",
        recommendation: null,
      );
      
      const model2 = UserRecommendationModel(
        id: "rec1",
        recoID: "reco1",
        userID: "user1",
        priority: "low",
        notes: "Test notes",
        recommendation: null,
      );
      
      // Then
      expect(model1, isNot(model2));
    });
  });
}