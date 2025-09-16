import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_reason.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_form_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecommendationFormHelper', () {
    late RecommendationFormHelper helper;

    setUp(() {
      helper = RecommendationFormHelper();
    });

    group('isRecommendationLimitReached', () {
      test('should return false for non-promoter users', () {
        // Given
        final user = CustomUser(
          id: UniqueID.fromUniqueString("test"),
          role: Role.company,
          recommendationCountLast30Days: 10,
        );

        // When
        final result = helper.isRecommendationLimitReached(user);

        // Then
        expect(result, false);
      });

      test('should return false when recommendationCountLast30Days is null', () {
        // Given
        final user = CustomUser(
          id: UniqueID.fromUniqueString("test"),
          role: Role.promoter,
          recommendationCountLast30Days: null,
        );

        // When
        final result = helper.isRecommendationLimitReached(user);

        // Then
        expect(result, false);
      });

      test('should return false when under limit for promoter', () {
        // Given
        final user = CustomUser(
          id: UniqueID.fromUniqueString("test"),
          role: Role.promoter,
          recommendationCountLast30Days: 3,
        );

        // When
        final result = helper.isRecommendationLimitReached(user);

        // Then
        expect(result, false);
      });

      test('should return true when limit reached for promoter', () {
        // Given
        final user = CustomUser(
          id: UniqueID.fromUniqueString("test"),
          role: Role.promoter,
          recommendationCountLast30Days: 6,
        );

        // When
        final result = helper.isRecommendationLimitReached(user);

        // Then
        expect(result, true);
      });

      test('should return true when over limit for promoter', () {
        // Given
        final user = CustomUser(
          id: UniqueID.fromUniqueString("test"),
          role: Role.promoter,
          recommendationCountLast30Days: 8,
        );

        // When
        final result = helper.isRecommendationLimitReached(user);

        // Then
        expect(result, true);
      });

      test('should return false when user is null', () {
        // When
        final result = helper.isRecommendationLimitReached(null);

        // Then
        expect(result, false);
      });
    });

    group('hasActiveReasons', () {
      test('should return true when at least one reason is active', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Reason 1",
            isActive: false,
            promotionTemplate: null,
          ),
          const RecommendationReason(
            id: null,
            reason: "Reason 2",
            isActive: true,
            promotionTemplate: null,
          ),
          const RecommendationReason(
            id: null,
            reason: "Reason 3",
            isActive: false,
            promotionTemplate: null,
          ),
        ];

        // When
        final result = helper.hasActiveReasons(reasons);

        // Then
        expect(result, true);
      });

      test('should return false when no reasons are active', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Reason 1",
            isActive: false,
            promotionTemplate: null,
          ),
          const RecommendationReason(
            id: null,
            reason: "Reason 2",
            isActive: false,
            promotionTemplate: null,
          ),
        ];

        // When
        final result = helper.hasActiveReasons(reasons);

        // Then
        expect(result, false);
      });

      test('should return false when reasons list is empty', () {
        // Given
        final reasons = <RecommendationReason>[];

        // When
        final result = helper.hasActiveReasons(reasons);

        // Then
        expect(result, false);
      });

      test('should return false when all reasons have null isActive', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Reason 1",
            isActive: null,
            promotionTemplate: null,
          ),
        ];

        // When
        final result = helper.hasActiveReasons(reasons);

        // Then
        expect(result, false);
      });
    });

    group('getReasonValues', () {
      test('should return selectedReason value when provided', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Reason 1",
            isActive: true,
            promotionTemplate: null,
          ),
        ];
        const selectedReason = RecommendationReason(
          id: null,
          reason: "Selected Reason",
          isActive: true,
          promotionTemplate: null,
        );

        // When
        final result = helper.getReasonValues(reasons, selectedReason);

        // Then
        expect(result, "Selected Reason");
      });

      test('should return first active reason when selectedReason is null', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Inactive Reason",
            isActive: false,
            promotionTemplate: null,
          ),
          const RecommendationReason(
            id: null,
            reason: "Active Reason",
            isActive: true,
            promotionTemplate: null,
          ),
        ];

        // When
        final result = helper.getReasonValues(reasons, null);

        // Then
        expect(result, "Active Reason");
      });

      test('should return default reason when no active reasons exist', () {
        // Given
        final reasons = [
          const RecommendationReason(
            id: null,
            reason: "Inactive Reason",
            isActive: false,
            promotionTemplate: null,
          ),
        ];

        // When
        final result = helper.getReasonValues(reasons, null);

        // Then
        expect(result, "null");
      });
    });

    group('createRecommendationItem', () {
      test('should create RecommendationItem with current user data', () {
        // Given
        final currentUser = CustomUser(
          id: UniqueID.fromUniqueString("current-user"),
          defaultLandingPageID: "default-landing-page",
        );
        final selectedReason = RecommendationReason(
          id: UniqueID.fromUniqueString("reason-id"),
          reason: "Test Reason",
          isActive: true,
          promotionTemplate: "Test Template",
        );
        final reasons = [selectedReason];

        // When
        final result = helper.createRecommendationItem(
          leadName: "John Doe",
          promoterName: "Jane Smith",
          serviceProviderName: "Service Provider",
          selectedReason: selectedReason,
          reasons: reasons,
          currentUser: currentUser,
          parentUser: null,
        );

        // Then
        expect(result.name, "John Doe");
        expect(result.reason, "Test Reason");
        expect(result.landingPageID, "reason-id");
        expect(result.promoterName, "Jane Smith");
        expect(result.serviceProviderName, "Service Provider");
        expect(result.defaultLandingPageID, "default-landing-page");
        expect(result.statusLevel.toString(), StatusLevel.recommendationSend.toString());
        expect(result.userID, "current-user");
        expect(result.promotionTemplate, "Test Template");
        expect(result.statusTimestamps, isNotEmpty);
      });

      test('should create RecommendationItem with parent user data when current user is null', () {
        // Given
        final parentUser = CustomUser(
          id: UniqueID.fromUniqueString("parent-user"),
          defaultLandingPageID: "parent-landing-page",
        );
        final selectedReason = RecommendationReason(
          id: UniqueID.fromUniqueString("reason-id"),
          reason: "Test Reason",
          isActive: true,
          promotionTemplate: "Test Template",
        );
        final reasons = [selectedReason];

        // When
        final result = helper.createRecommendationItem(
          leadName: "  John Doe  ",
          promoterName: "  Jane Smith  ",
          serviceProviderName: "  Service Provider  ",
          selectedReason: selectedReason,
          reasons: reasons,
          currentUser: null,
          parentUser: parentUser,
        );

        // Then
        expect(result.name, "John Doe");
        expect(result.promoterName, "Jane Smith");
        expect(result.serviceProviderName, "Service Provider");
        expect(result.defaultLandingPageID, "parent-landing-page");
        expect(result.userID, "parent-user");
      });
    });

    // Note: getRecommendationLimitResetText tests are skipped because they require
    // BuildContext for localization. These would need to be tested in integration tests
    // or the method would need to be refactored to accept localization strings directly.
  });
}