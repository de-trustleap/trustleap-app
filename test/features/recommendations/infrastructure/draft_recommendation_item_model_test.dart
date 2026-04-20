import 'package:finanzbegleiter/features/recommendations/domain/draft_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/draft_recommendation_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("DraftRecommendationItemModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      final expectedResult = {
        'id': "1",
        'ownerID': "owner1",
        'landingPageID': "lp1",
        'defaultLandingPageID': "dlp1",
        'promoterName': "Promoter",
        'name': "Customer",
        'serviceProviderName': "Provider",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("toMap includes null values for optional fields", () {
      // Given
      const model = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
      );
      // When
      final result = model.toMap();
      // Then
      expect(result['landingPageID'], isNull);
      expect(result['defaultLandingPageID'], isNull);
      expect(result['promoterName'], isNull);
      expect(result['name'], isNull);
      expect(result['serviceProviderName'], isNull);
    });
  });

  group("DraftRecommendationItemModel_FromDomain", () {
    test("check if conversion from DraftRecommendationItem to model works", () {
      // Given
      const item = DraftRecommendationItem(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      const expectedResult = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      // When
      final result = DraftRecommendationItemModel.fromDomain(item);
      // Then
      expect(result, expectedResult);
    });
  });

  group("DraftRecommendationItemModel_ToDomain", () {
    test("check if conversion from model to DraftRecommendationItem works", () {
      // Given
      const model = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      const expectedResult = DraftRecommendationItem(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("DraftRecommendationItemModel_Props", () {
    test("two instances with same values should be equal", () {
      // Given
      const model1 = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      const model2 = DraftRecommendationItemModel(
        id: "1",
        ownerID: "owner1",
        landingPageID: "lp1",
        defaultLandingPageID: "dlp1",
        promoterName: "Promoter",
        name: "Customer",
        serviceProviderName: "Provider",
      );
      // Then
      expect(model1, model2);
    });
  });
}
