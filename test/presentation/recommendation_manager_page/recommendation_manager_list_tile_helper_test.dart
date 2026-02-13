import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_edit.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_list_tile_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../mocks.mocks.dart';

class TestModule extends Module {
  final MockRecommendationManagerTileCubit mockCubit;
  
  TestModule(this.mockCubit);
  
  @override
  void binds(Injector i) {
    i.add<RecommendationManagerTileCubit>(() => mockCubit);
  }
}

void main() {
  late MockRecommendationManagerTileCubit mockCubit;
  late MockAppLocalizations mockLocalizations;
  
  setUp(() {
    mockCubit = MockRecommendationManagerTileCubit();
    mockLocalizations = MockAppLocalizations();
    Modular.init(TestModule(mockCubit));
  });
  
  tearDown(() {
    Modular.destroy();
  });

  group("RecommendationManagerListTileHelper_getOverlayOpacity", () {
    late UserRecommendation recommendation;
    const currentUserID = "user123";

    setUp(() {
      recommendation = UserRecommendation(
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

    test("should return 0.0 when shouldAnimateToSurface is true", () {
      // Given
      const shouldAnimateToSurface = true;
      
      // When
      final result = RecommendationManagerListTileHelper.getOverlayOpacity(
        recommendation,
        currentUserID,
        shouldAnimateToSurface,
      );
      
      // Then
      expect(result, 0.0);
    });

    test("should return 0.1 when hasUnseenChanges is true and shouldAnimateToSurface is false", () {
      // Given
      final recommendationWithUnseenChanges = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: "otherUser",
            editedAt: DateTime.now(),
          ),
        ],
      );
      const shouldAnimateToSurface = false;
      
      // When
      final result = RecommendationManagerListTileHelper.getOverlayOpacity(
        recommendationWithUnseenChanges,
        currentUserID,
        shouldAnimateToSurface,
      );
      
      // Then
      expect(result, 0.1);
    });

    test("should return 0.0 when hasUnseenChanges is false and shouldAnimateToSurface is false", () {
      // Given
      final recommendationWithSeenChanges = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      const shouldAnimateToSurface = false;
      
      // When
      final result = RecommendationManagerListTileHelper.getOverlayOpacity(
        recommendationWithSeenChanges,
        currentUserID,
        shouldAnimateToSurface,
      );
      
      // Then
      expect(result, 0.0);
    });

    test("should return 0.0 when no edits exist", () {
      // Given
      const shouldAnimateToSurface = false;
      
      // When
      final result = RecommendationManagerListTileHelper.getOverlayOpacity(
        recommendation,
        currentUserID,
        shouldAnimateToSurface,
      );
      
      // Then
      expect(result, 0.0);
    });
  });

  group("RecommendationManagerListTileHelper_buildLastEditMessage", () {
    late UserRecommendation recommendation;
    const currentUserID = "user123";
    const otherUserID = "user456";

    setUp(() {
      recommendation = UserRecommendation(
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

    test("should return null when no edits from others exist", () async {
      // Given
      final recommendationWithOwnEdits = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: currentUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithOwnEdits,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, isNull);
    });

    test("should return null when no relevant edits after last viewed exist", () async {
      // Given
      final viewedAt = DateTime.now();
      final editBefore = viewedAt.subtract(const Duration(hours: 1));
      
      final recommendationWithOldEdits = recommendation.copyWith(
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
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithOldEdits,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, isNull);
    });

    test("should return formatted message for priority edit", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_priority).thenReturn("Priorität");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Max Mustermann", "Priorität"))
          .thenReturn("Max Mustermann hat Priorität angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "Max Mustermann");
      
      final recommendationWithPriorityEdit = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithPriorityEdit,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Max Mustermann hat Priorität angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should return formatted message for notes edit", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_notes).thenReturn("Notizen");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Jane Doe", "Notizen"))
          .thenReturn("Jane Doe hat Notizen angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "Jane Doe");
      
      final recommendationWithNotesEdit = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "notes",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithNotesEdit,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Jane Doe hat Notizen angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should return formatted message for multiple edits", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_priority).thenReturn("Priorität");
      when(mockLocalizations.recommendation_manager_field_notes).thenReturn("Notizen");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("John Smith", "Priorität und Notizen"))
          .thenReturn("John Smith hat Priorität und Notizen angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "John Smith");
      
      final recommendationWithMultipleEdits = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithMultipleEdits,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "John Smith hat Priorität und Notizen angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should return formatted message for unknown field name", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Unknown User", "unknownField"))
          .thenReturn("Unknown User hat unknownField angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "Unknown User");
      
      final recommendationWithUnknownEdit = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "unknownField",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithUnknownEdit,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Unknown User hat unknownField angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should return null when getUserDisplayName returns empty string", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_priority).thenReturn("Priorität");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "");
      
      final recommendationWithEdit = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: DateTime.now(),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithEdit,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, isNull);
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should handle multiple users and return most recent editor", () async {
      // Given
      const user1 = "user1";
      const user2 = "user2";
      final now = DateTime.now();
      final earlier = now.subtract(const Duration(hours: 1));
      
      when(mockLocalizations.recommendation_manager_field_notes).thenReturn("Notizen");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Most Recent User", "Notizen"))
          .thenReturn("Most Recent User hat Notizen angepasst");
      when(mockCubit.getUserDisplayName(user2))
          .thenAnswer((_) async => "Most Recent User");
      
      final recommendationWithMultipleUsers = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: user1,
            editedAt: earlier,
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: user2,
            editedAt: now,
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithMultipleUsers,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Most Recent User hat Notizen angepasst");
      verify(mockCubit.getUserDisplayName(user2));
      verifyNever(mockCubit.getUserDisplayName(user1));
    });

    test("should only consider edits after last viewed when user has viewed", () async {
      // Given
      final viewedAt = DateTime.now();
      final editBefore = viewedAt.subtract(const Duration(hours: 1));
      final editAfter = viewedAt.add(const Duration(hours: 1));
      
      when(mockLocalizations.recommendation_manager_field_notes).thenReturn("Notizen");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Recent Editor", "Notizen"))
          .thenReturn("Recent Editor hat Notizen angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "Recent Editor");
      
      final recommendationWithViewedAndEdits = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: editBefore,
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
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithViewedAndEdits,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Recent Editor hat Notizen angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });

    test("should handle multiple edits from same user correctly", () async {
      // Given
      when(mockLocalizations.recommendation_manager_field_priority).thenReturn("Priorität");
      when(mockLocalizations.recommendation_manager_field_notes).thenReturn("Notizen");
      when(mockLocalizations.recommendation_manager_field_connector).thenReturn(" und ");
      when(mockLocalizations.recommendation_manager_edit_message("Multi Editor", "Priorität und Notizen"))
          .thenReturn("Multi Editor hat Priorität und Notizen angepasst");
      when(mockCubit.getUserDisplayName(otherUserID))
          .thenAnswer((_) async => "Multi Editor");
      
      final now = DateTime.now();
      final recommendationWithMultipleSameUserEdits = recommendation.copyWith(
        lastEdits: [
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: now.subtract(const Duration(minutes: 30)),
          ),
          LastEdit(
            fieldName: "notes",
            editedBy: otherUserID,
            editedAt: now.subtract(const Duration(minutes: 20)),
          ),
          LastEdit(
            fieldName: "priority",
            editedBy: otherUserID,
            editedAt: now.subtract(const Duration(minutes: 10)),
          ),
        ],
      );
      
      // When
      final result = await RecommendationManagerListTileHelper.buildLastEditMessage(
        recommendationWithMultipleSameUserEdits,
        currentUserID,
        mockLocalizations,
      );
      
      // Then
      expect(result, "Multi Editor hat Priorität und Notizen angepasst");
      verify(mockCubit.getUserDisplayName(otherUserID));
    });
  });
}