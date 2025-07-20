import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/last_edit.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserRecommendation baseRecommendation;
  
  setUp(() {
    baseRecommendation = UserRecommendation(
      id: UniqueID.fromUniqueString("rec1"),
      recoID: "reco1",
      userID: "user1",
      priority: RecommendationPriority.medium,
      notes: "Test notes",
      recommendation: null,
      lastEdits: [],
      viewedByUsers: [],
    );
  });

  group("UserRecommendation_CopyWith", () {
    test("set priority with copyWith should set priority for resulting object", () {
      // Given
      final expectedResult = baseRecommendation.copyWith(priority: RecommendationPriority.high);
      
      // When
      final result = baseRecommendation.copyWith(priority: RecommendationPriority.high);
      
      // Then
      expect(result, expectedResult);
      expect(result.priority, RecommendationPriority.high);
    });

    test("set notes with copyWith should set notes for resulting object", () {
      // Given
      const newNotes = "Updated notes";
      
      // When
      final result = baseRecommendation.copyWith(notes: newNotes);
      
      // Then
      expect(result.notes, newNotes);
      expect(result.id, baseRecommendation.id);
      expect(result.priority, baseRecommendation.priority);
    });

    test("set lastEdits with copyWith should set lastEdits for resulting object", () {
      // Given
      final newEdits = [
        LastEdit(
          fieldName: "priority",
          editedBy: "user123",
          editedAt: DateTime.now(),
        ),
      ];
      
      // When
      final result = baseRecommendation.copyWith(lastEdits: newEdits);
      
      // Then
      expect(result.lastEdits, newEdits);
      expect(result.lastEdits.length, 1);
    });

    test("set viewedByUsers with copyWith should set viewedByUsers for resulting object", () {
      // Given
      final newViewed = [
        LastViewed(
          userID: "user123",
          viewedAt: DateTime.now(),
        ),
      ];
      
      // When
      final result = baseRecommendation.copyWith(viewedByUsers: newViewed);
      
      // Then
      expect(result.viewedByUsers, newViewed);
      expect(result.viewedByUsers.length, 1);
    });
  });

  group("UserRecommendation_getLastEdit", () {
    test("should return null when no edits exist", () {
      // Given
      // baseRecommendation has no lastEdits
      
      // When
      final result = baseRecommendation.getLastEdit("priority");
      
      // Then
      expect(result, isNull);
    });

    test("should return null when field does not exist in edits", () {
      // Given
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "notes",
            editedBy: "user123",
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = recommendation.getLastEdit("priority");
      
      // Then
      expect(result, isNull);
    });

    test("should return the correct edit for existing field", () {
      // Given
      final expectedEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "notes",
            editedBy: "user456",
            editedAt: DateTime(2023, 12, 24, 10, 30, 0),
          ),
          expectedEdit,
        ],
      );
      
      // When
      final result = recommendation.getLastEdit("priority");
      
      // Then
      expect(result, expectedEdit);
    });

    test("should return the first matching edit when multiple edits for same field exist", () {
      // Given
      final firstEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      
      final secondEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user456",
        editedAt: DateTime(2023, 12, 25, 11, 30, 0),
      );
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          firstEdit,
          secondEdit,
        ],
      );
      
      // When
      final result = recommendation.getLastEdit("priority");
      
      // Then
      expect(result, firstEdit);
    });

    test("should handle different field names correctly", () {
      // Given
      final priorityEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime.now(),
      );
      
      final notesEdit = LastEdit(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: DateTime.now(),
      );
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [priorityEdit, notesEdit],
      );
      
      // When & Then
      expect(recommendation.getLastEdit("priority"), priorityEdit);
      expect(recommendation.getLastEdit("notes"), notesEdit);
      expect(recommendation.getLastEdit("nonexistent"), isNull);
    });
  });

  group("UserRecommendation_hasUnseenChanges", () {
    const currentUserID = "user123";
    const otherUserID = "user456";

    test("should return false when no edits exist", () {
      // Given
      // baseRecommendation has no lastEdits
      
      // When
      final result = baseRecommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, false);
    });

    test("should return false when only own edits exist", () {
      // Given
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: DateTime.now(),
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: currentUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, false);
    });

    test("should return true when edits from others exist and user has never viewed", () {
      // Given
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, true);
    });

    test("should return false when all edits from others are before last viewed", () {
      // Given
      final viewedAt = DateTime.now();
      final editBefore = viewedAt.subtract(const Duration(hours: 1));
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: editBefore,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: currentUserID,
            viewedAt: viewedAt,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, false);
    });

    test("should return true when edits from others exist after last viewed", () {
      // Given
      final viewedAt = DateTime.now();
      final editAfter = viewedAt.add(const Duration(hours: 1));
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: editAfter,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: currentUserID,
            viewedAt: viewedAt,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, true);
    });

    test("should handle mixed edits correctly - own and others before and after viewed", () {
      // Given
      final viewedAt = DateTime.now();
      final editBefore = viewedAt.subtract(const Duration(hours: 1));
      final editAfter = viewedAt.add(const Duration(hours: 1));
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: editBefore,
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: otherUserID,
            editedAt: editBefore,
          ),
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: editAfter,
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: otherUserID,
            editedAt: editAfter,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: currentUserID,
            viewedAt: viewedAt,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, true); // Because other user edited after viewed
    });

    test("should handle multiple users in viewedByUsers correctly", () {
      // Given
      const anotherUserID = "user789";
      final viewedAt = DateTime.now();
      final editAfter = viewedAt.add(const Duration(hours: 1));
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: editAfter,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: anotherUserID,
            viewedAt: viewedAt.subtract(const Duration(hours: 2)),
          ),
          LastViewed(
            userID: currentUserID,
            viewedAt: viewedAt,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, true);
    });

    test("should return false when user has not viewed but no edits from others exist", () {
      // Given
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: DateTime.now(),
          ),
        ],
        // No viewedByUsers entry for currentUserID
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, false);
    });

    test("should handle edge case when viewedAt is exactly same as editedAt", () {
      // Given
      final exactTime = DateTime.now();
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: exactTime,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: currentUserID,
            viewedAt: exactTime,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, false); // isAfter returns false for equal times
    });

    test("should return true for multiple edits from different users after viewed", () {
      // Given
      const thirdUserID = "user999";
      final viewedAt = DateTime.now();
      final editAfter1 = viewedAt.add(const Duration(hours: 1));
      final editAfter2 = viewedAt.add(const Duration(hours: 2));
      
      final recommendation = baseRecommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: editAfter1,
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: thirdUserID,
            editedAt: editAfter2,
          ),
        ],
        viewedByUsers: [
          LastViewed(
            userID: currentUserID,
            viewedAt: viewedAt,
          ),
        ],
      );
      
      // When
      final result = recommendation.hasUnseenChanges(currentUserID);
      
      // Then
      expect(result, true);
    });
  });

  group("UserRecommendation_Props", () {
    test("check if value equality works with same values", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastViewed = LastViewed(
        userID: "user123",
        viewedAt: date,
      );
      
      final recommendation1 = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1",
        userID: "user1",
        priority: RecommendationPriority.high,
        notes: "Test",
        recommendation: null,
        lastEdits: [lastEdit],
        viewedByUsers: [lastViewed],
      );
      
      final recommendation2 = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1",
        userID: "user1",
        priority: RecommendationPriority.high,
        notes: "Test",
        recommendation: null,
        lastEdits: [lastEdit],
        viewedByUsers: [lastViewed],
      );
      
      // Then
      expect(recommendation1, recommendation2);
    });

    test("check if value equality fails with different values", () {
      // Given
      final recommendation1 = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1",
        userID: "user1",
        priority: RecommendationPriority.high,
        notes: "Test",
        recommendation: null,
      );
      
      final recommendation2 = UserRecommendation(
        id: UniqueID.fromUniqueString("rec1"),
        recoID: "reco1",
        userID: "user1",
        priority: RecommendationPriority.low,
        notes: "Test",
        recommendation: null,
      );
      
      // Then
      expect(recommendation1, isNot(recommendation2));
    });
  });
}