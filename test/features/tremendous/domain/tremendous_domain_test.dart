import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_organization.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TremendousOrganization_FromMap", () {
    test("parses id and name from map", () {
      // Given
      final map = {"id": "org1", "name": "Meine Firma"};
      // When
      final result = TremendousOrganization.fromMap(map);
      // Then
      expect(result.id, "org1");
      expect(result.name, "Meine Firma");
    });
  });

  group("TremendousOrganization_ToMap", () {
    test("converts to map correctly", () {
      // Given
      const org = TremendousOrganization(id: "org1", name: "Meine Firma");
      // When
      final result = org.toMap();
      // Then
      expect(result, {"id": "org1", "name": "Meine Firma"});
    });
  });

  group("TremendousOrganization_Props", () {
    test("value equality works", () {
      const org1 = TremendousOrganization(id: "org1", name: "Test");
      const org2 = TremendousOrganization(id: "org1", name: "Test");
      expect(org1, org2);
    });

    test("different ids are not equal", () {
      const org1 = TremendousOrganization(id: "org1", name: "Test");
      const org2 = TremendousOrganization(id: "org2", name: "Test");
      expect(org1, isNot(equals(org2)));
    });
  });

  group("TremendousProduct_FromMap", () {
    test("parses all fields from map", () {
      // Given
      final map = {
        "id": "prod1",
        "name": "Amazon Gift Card",
        "category": "GIFT_CARDS",
        "min": 10.0,
        "max": 100.0,
        "images": [
          {"src": "https://example.com/img.png"}
        ],
      };
      // When
      final result = TremendousProduct.fromMap(map);
      // Then
      expect(result.id, "prod1");
      expect(result.name, "Amazon Gift Card");
      expect(result.category, "GIFT_CARDS");
      expect(result.min, 10.0);
      expect(result.max, 100.0);
      expect(result.imageUrl, "https://example.com/img.png");
    });

    test("handles missing optional fields", () {
      // Given
      final map = {
        "id": "prod2",
        "name": "Gift Card",
        "category": "GIFT_CARDS",
      };
      // When
      final result = TremendousProduct.fromMap(map);
      // Then
      expect(result.min, isNull);
      expect(result.max, isNull);
      expect(result.imageUrl, isNull);
    });

    test("handles empty images list", () {
      // Given
      final map = {
        "id": "prod3",
        "name": "Gift Card",
        "category": "GIFT_CARDS",
        "images": <dynamic>[],
      };
      // When
      final result = TremendousProduct.fromMap(map);
      // Then
      expect(result.imageUrl, isNull);
    });

    test("handles missing category with empty string fallback", () {
      // Given
      final map = {"id": "prod4", "name": "Gift Card"};
      // When
      final result = TremendousProduct.fromMap(map);
      // Then
      expect(result.category, "");
    });

    test("handles integer min/max values", () {
      // Given
      final map = {
        "id": "prod5",
        "name": "Gift Card",
        "category": "GIFT_CARDS",
        "min": 5,
        "max": 200,
      };
      // When
      final result = TremendousProduct.fromMap(map);
      // Then
      expect(result.min, 5.0);
      expect(result.max, 200.0);
    });
  });

  group("TremendousProduct_Props", () {
    test("value equality works", () {
      const prod1 = TremendousProduct(
          id: "p1", name: "Card", category: "GIFT_CARDS", min: 10.0, max: 50.0);
      const prod2 = TremendousProduct(
          id: "p1", name: "Card", category: "GIFT_CARDS", min: 10.0, max: 50.0);
      expect(prod1, prod2);
    });
  });

  group("TremendousFundingSource_FromMap", () {
    test("parses all fields from map with meta", () {
      // Given
      final map = {
        "id": "fs1",
        "method": "US_ACH",
        "meta": {
          "available_cents": 100000,
          "available_currency_code": "USD",
        },
      };
      // When
      final result = TremendousFundingSource.fromMap(map);
      // Then
      expect(result.id, "fs1");
      expect(result.method, "US_ACH");
      expect(result.availableCents, 100000);
      expect(result.currencyCode, "USD");
    });

    test("handles missing meta gracefully", () {
      // Given
      final map = {"id": "fs2", "method": "PAYPAL"};
      // When
      final result = TremendousFundingSource.fromMap(map);
      // Then
      expect(result.id, "fs2");
      expect(result.method, "PAYPAL");
      expect(result.availableCents, isNull);
      expect(result.currencyCode, isNull);
    });
  });

  group("TremendousFundingSource_DisplayName", () {
    test("displayName returns method", () {
      const fs = TremendousFundingSource(id: "fs1", method: "US_ACH");
      expect(fs.displayName, "US_ACH");
    });
  });

  group("TremendousFundingSource_Props", () {
    test("value equality works", () {
      const fs1 = TremendousFundingSource(
          id: "fs1", method: "US_ACH", availableCents: 5000, currencyCode: "USD");
      const fs2 = TremendousFundingSource(
          id: "fs1", method: "US_ACH", availableCents: 5000, currencyCode: "USD");
      expect(fs1, fs2);
    });
  });
}
