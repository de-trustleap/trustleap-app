import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_compensation_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RecommendationCompensationModel_ToMap", () {
    test("converts model to map correctly", () {
      // Given
      final model = RecommendationCompensationModel(
        status: "manualIssued",
        timestamps: {"manualIssued": "2024-01-01T00:00:00.000"},
        tremendousOrderID: "order1",
        tremendousRewardID: "reward1",
        tremendousProductID: "product1",
        amount: 50.0,
        currency: "EUR",
        error: null,
      );
      final expectedResult = {
        "status": "manualIssued",
        "timestamps": {"manualIssued": "2024-01-01T00:00:00.000"},
        "tremendousOrderID": "order1",
        "tremendousRewardID": "reward1",
        "tremendousProductID": "product1",
        "amount": 50.0,
        "currency": "EUR",
        "error": null,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("converts model with null fields to map correctly", () {
      // Given
      final model = RecommendationCompensationModel(
        status: "pending",
        timestamps: {},
      );
      // When
      final result = model.toMap();
      // Then
      expect(result["status"], "pending");
      expect(result["tremendousOrderID"], isNull);
      expect(result["amount"], isNull);
      expect(result["timestamps"], {});
    });
  });

  group("RecommendationCompensationModel_FromMap", () {
    test("converts map to model correctly", () {
      // Given
      final map = {
        "status": "voucherSent",
        "timestamps": {"voucherSent": "2024-03-15T10:00:00.000"},
        "tremendousOrderID": "order42",
        "tremendousRewardID": null,
        "tremendousProductID": "prod1",
        "amount": 25.0,
        "currency": "USD",
        "error": null,
      };
      // When
      final result = RecommendationCompensationModel.fromMap(map);
      // Then
      expect(result.status, "voucherSent");
      expect(result.timestamps, {"voucherSent": "2024-03-15T10:00:00.000"});
      expect(result.tremendousOrderID, "order42");
      expect(result.tremendousProductID, "prod1");
      expect(result.amount, 25.0);
      expect(result.currency, "USD");
    });

    test("handles missing timestamps gracefully", () {
      // Given
      final map = {
        "status": "pending",
      };
      // When
      final result = RecommendationCompensationModel.fromMap(map);
      // Then
      expect(result.timestamps, {});
    });

    test("handles amount as int from map", () {
      // Given
      final map = {
        "status": "pending",
        "amount": 100,
        "timestamps": <String, String>{},
      };
      // When
      final result = RecommendationCompensationModel.fromMap(map);
      // Then
      expect(result.amount, 100.0);
      expect(result.amount, isA<double>());
    });
  });

  group("RecommendationCompensationModel_ToDomain", () {
    test("converts model to domain correctly", () {
      // Given
      final ts = DateTime(2024, 1, 15, 12, 0, 0);
      final model = RecommendationCompensationModel(
        status: "manualIssued",
        timestamps: {"manualIssued": ts.toIso8601String()},
        tremendousOrderID: "order1",
        amount: 50.0,
        currency: "EUR",
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result.status, RecommendationCompensationStatus.manualIssued);
      expect(result.tremendousOrderID, "order1");
      expect(result.amount, 50.0);
      expect(result.currency, "EUR");
      expect(result.timestamps[RecommendationCompensationStatus.manualIssued], ts);
    });

    test("unknown status string falls back to pending", () {
      // Given
      final model = RecommendationCompensationModel(
        status: "unknownStatus",
        timestamps: {},
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result.status, RecommendationCompensationStatus.pending);
    });

    test("converts timestamps map correctly", () {
      // Given
      final ts1 = DateTime(2024, 1, 1);
      final ts2 = DateTime(2024, 2, 1);
      final model = RecommendationCompensationModel(
        status: "voucherSent",
        timestamps: {
          "pending": ts1.toIso8601String(),
          "voucherSent": ts2.toIso8601String(),
        },
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result.timestamps[RecommendationCompensationStatus.pending], ts1);
      expect(result.timestamps[RecommendationCompensationStatus.voucherSent], ts2);
    });
  });

  group("RecommendationCompensationModel_FromDomain", () {
    test("converts domain to model correctly", () {
      // Given
      final ts = DateTime(2024, 6, 1);
      final domain = RecommendationCompensation(
        status: RecommendationCompensationStatus.voucherSent,
        timestamps: {RecommendationCompensationStatus.voucherSent: ts},
        tremendousOrderID: "order99",
        tremendousRewardID: "reward99",
        amount: 30.0,
        currency: "EUR",
      );
      // When
      final result = RecommendationCompensationModel.fromDomain(domain);
      // Then
      expect(result.status, "voucherSent");
      expect(result.tremendousOrderID, "order99");
      expect(result.tremendousRewardID, "reward99");
      expect(result.amount, 30.0);
      expect(result.currency, "EUR");
      expect(result.timestamps["voucherSent"], ts.toIso8601String());
    });

    test("serializes all status enum values by name", () {
      for (final status in RecommendationCompensationStatus.values) {
        final domain = RecommendationCompensation(
          status: status,
          timestamps: {status: DateTime(2024)},
        );
        final model = RecommendationCompensationModel.fromDomain(domain);
        expect(model.status, status.name);
        expect(model.timestamps[status.name], DateTime(2024).toIso8601String());
      }
    });
  });

  group("RecommendationCompensationModel_Props", () {
    test("value equality works", () {
      // Given
      final model1 = RecommendationCompensationModel(
        status: "pending",
        timestamps: {"pending": "2024-01-01T00:00:00.000"},
        amount: 10.0,
        currency: "EUR",
      );
      final model2 = RecommendationCompensationModel(
        status: "pending",
        timestamps: {"pending": "2024-01-01T00:00:00.000"},
        amount: 10.0,
        currency: "EUR",
      );
      // Then
      expect(model1, model2);
    });
  });
}
