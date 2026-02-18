import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_form_helper.dart';
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

      test('should return false when recommendationCountLast30Days is null',
          () {
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
        expect(result.statusLevel.toString(),
            StatusLevel.recommendationSend.toString());
        expect(result.userID, "current-user");
        expect(result.promotionTemplate, "Test Template");
        expect(result.statusTimestamps, isNotEmpty);
      });

      test(
          'should create RecommendationItem with parent user data when current user is null',
          () {
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

    group('calculateTimeUntilReset', () {
      test('should calculate days until reset correctly', () {
        // Given
        final now = DateTime(2024, 12, 15, 10, 0); // 15.12.2024 10:00
        final resetDateTime = DateTime(2024, 12, 16, 14, 0); // 16.12.2024 14:00

        // When
        final result = helper.calculateTimeUntilReset(now, resetDateTime);

        // Then
        // Sollte bis 17.12.2024 00:00 rechnen (Tag nach resetDateTime)
        final expectedDifference = DateTime(2024, 12, 17, 0, 0).difference(now);
        expect(result, expectedDifference);
        expect(result!.inDays, 1); // Etwa 1 Tag
      });

      test('should calculate hours until reset correctly', () {
        // Given
        final now = DateTime(2024, 12, 16, 20, 0); // 16.12.2024 20:00
        final resetDateTime = DateTime(2024, 12, 16, 14, 0); // 16.12.2024 14:00

        // When
        final result = helper.calculateTimeUntilReset(now, resetDateTime);

        // Then
        // Sollte bis 17.12.2024 00:00 rechnen (Tag nach resetDateTime)
        final expectedDifference = DateTime(2024, 12, 17, 0, 0).difference(now);
        expect(result, expectedDifference);
        expect(result!.inHours, 4); // 4 Stunden bis Mitternacht
      });

      test('should return null when reset time has passed', () {
        // Given
        final now = DateTime(2024, 12, 18, 10, 0); // 18.12.2024 10:00
        final resetDateTime = DateTime(2024, 12, 16, 14, 0); // 16.12.2024 14:00

        // When
        final result = helper.calculateTimeUntilReset(now, resetDateTime);

        // Then
        // Reset war am 17.12.2024 00:00, jetzt ist es schon 18.12.2024
        expect(result, null);
      });

      test('should handle same day reset correctly', () {
        // Given
        final now = DateTime(2024, 12, 16, 10, 0); // 16.12.2024 10:00
        final resetDateTime = DateTime(2024, 12, 16, 14, 0); // 16.12.2024 14:00

        // When
        final result = helper.calculateTimeUntilReset(now, resetDateTime);

        // Then
        // Sollte bis 17.12.2024 00:00 rechnen (Tag nach resetDateTime)
        final expectedDifference = DateTime(2024, 12, 17, 0, 0).difference(now);
        expect(result, expectedDifference);
        expect(result!.inHours,
            14); // 14 Stunden bis Mitternacht des nächsten Tages
      });

      test('should handle edge case at exact midnight', () {
        // Given
        final now = DateTime(
            2024, 12, 17, 0, 0); // 17.12.2024 00:00 (exakt Mitternacht)
        final resetDateTime = DateTime(2024, 12, 16, 14, 0); // 16.12.2024 14:00

        // When
        final result = helper.calculateTimeUntilReset(now, resetDateTime);

        // Then
        // Reset sollte genau jetzt stattfinden
        expect(result, null);
      });
    });
  });
}
