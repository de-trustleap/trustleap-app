import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ts1 = DateTime(2024, 1, 1);
  final ts2 = DateTime(2024, 2, 1);

  group("RecommendationCompensation_CopyWith", () {
    test("copyWith status changes status", () {
      // Given
      final compensation = RecommendationCompensation(
        status: RecommendationCompensationStatus.pending,
        timestamps: {RecommendationCompensationStatus.pending: ts1},
        amount: 50.0,
        currency: "EUR",
      );
      // When
      final result = compensation.copyWith(
          status: RecommendationCompensationStatus.manualIssued);
      // Then
      expect(result.status, RecommendationCompensationStatus.manualIssued);
      expect(result.amount, 50.0);
      expect(result.currency, "EUR");
    });

    test("copyWith timestamps replaces timestamps", () {
      // Given
      final compensation = RecommendationCompensation(
        status: RecommendationCompensationStatus.pending,
        timestamps: {RecommendationCompensationStatus.pending: ts1},
      );
      final newTimestamps = {
        RecommendationCompensationStatus.pending: ts1,
        RecommendationCompensationStatus.manualIssued: ts2,
      };
      // When
      final result = compensation.copyWith(timestamps: newTimestamps);
      // Then
      expect(result.timestamps, newTimestamps);
    });
  });

  group("RecommendationCompensation_Props", () {
    test("value equality works", () {
      // Given
      final comp1 = RecommendationCompensation(
        status: RecommendationCompensationStatus.voucherSent,
        timestamps: {RecommendationCompensationStatus.voucherSent: ts1},
        tremendousOrderID: "order1",
        amount: 25.0,
        currency: "EUR",
      );
      final comp2 = RecommendationCompensation(
        status: RecommendationCompensationStatus.voucherSent,
        timestamps: {RecommendationCompensationStatus.voucherSent: ts1},
        tremendousOrderID: "order1",
        amount: 25.0,
        currency: "EUR",
      );
      // Then
      expect(comp1, comp2);
    });

    test("objects with different status are not equal", () {
      // Given
      final comp1 = RecommendationCompensation(
        status: RecommendationCompensationStatus.pending,
        timestamps: {},
      );
      final comp2 = RecommendationCompensation(
        status: RecommendationCompensationStatus.manualIssued,
        timestamps: {},
      );
      // Then
      expect(comp1, isNot(equals(comp2)));
    });
  });

  group("RecommendationCompensationStatus_fromString", () {
    test("returns correct status for all known values", () {
      expect(RecommendationCompensationStatus.fromString("pending"),
          RecommendationCompensationStatus.pending);
      expect(RecommendationCompensationStatus.fromString("skipped"),
          RecommendationCompensationStatus.skipped);
      expect(RecommendationCompensationStatus.fromString("voucherSent"),
          RecommendationCompensationStatus.voucherSent);
      expect(RecommendationCompensationStatus.fromString("voucherDelivered"),
          RecommendationCompensationStatus.voucherDelivered);
      expect(RecommendationCompensationStatus.fromString("voucherFailed"),
          RecommendationCompensationStatus.voucherFailed);
      expect(RecommendationCompensationStatus.fromString("manualIssued"),
          RecommendationCompensationStatus.manualIssued);
      expect(RecommendationCompensationStatus.fromString("manualConfirmed"),
          RecommendationCompensationStatus.manualConfirmed);
    });

    test("returns null for unknown string", () {
      expect(RecommendationCompensationStatus.fromString("unknown"), isNull);
    });

    test("returns null for null input", () {
      expect(RecommendationCompensationStatus.fromString(null), isNull);
    });
  });
}
