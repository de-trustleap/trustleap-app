import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/helpers/conversion_rate_formatter.dart';

void main() {
  group("ConversionRateFormatter format", () {
    test("should return '0%' when total is 0", () {
      final result =
          ConversionRateFormatter.format(total: 0, successful: 0);
      expect(result, equals("0%"));
    });

    test("should return '0%' when total is negative", () {
      final result =
          ConversionRateFormatter.format(total: -1, successful: 0);
      expect(result, equals("0%"));
    });

    test("should return '100%' when all are successful", () {
      final result =
          ConversionRateFormatter.format(total: 10, successful: 10);
      expect(result, equals("100%"));
    });

    test("should return '0%' when none are successful", () {
      final result =
          ConversionRateFormatter.format(total: 10, successful: 0);
      expect(result, equals("0%"));
    });

    test("should return '50%' for half successful", () {
      final result =
          ConversionRateFormatter.format(total: 10, successful: 5);
      expect(result, equals("50%"));
    });

    test("should return whole number without decimal when percentage is even",
        () {
      final result =
          ConversionRateFormatter.format(total: 4, successful: 1);
      expect(result, equals("25%"));
    });

    test("should return one decimal place when percentage is not even", () {
      final result =
          ConversionRateFormatter.format(total: 3, successful: 1);
      expect(result, equals("33.3%"));
    });

    test("should return one decimal place for 2/3", () {
      final result =
          ConversionRateFormatter.format(total: 3, successful: 2);
      expect(result, equals("66.7%"));
    });

    test("should handle single total with single successful", () {
      final result =
          ConversionRateFormatter.format(total: 1, successful: 1);
      expect(result, equals("100%"));
    });

    test("should handle large numbers", () {
      final result =
          ConversionRateFormatter.format(total: 10000, successful: 5000);
      expect(result, equals("50%"));
    });

    test("should return '10%' for 1 out of 10", () {
      final result =
          ConversionRateFormatter.format(total: 10, successful: 1);
      expect(result, equals("10%"));
    });

    test("should return decimal for 1 out of 7", () {
      final result =
          ConversionRateFormatter.format(total: 7, successful: 1);
      expect(result, equals("14.3%"));
    });

    test("should return '75%' for 3 out of 4", () {
      final result =
          ConversionRateFormatter.format(total: 4, successful: 3);
      expect(result, equals("75%"));
    });
  });
}
