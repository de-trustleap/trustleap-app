import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LandingPageModel_CopyWith", () {
    test("set ownerID with copyWith should set ownerID for resulting object",
        () {
      // Given
      final landingPage = LandingPageModel(
          id: "1", name: "Test", ownerID: "5", createdAt: Timestamp(100000, 0));
      final expectedResult = LandingPageModel(
          id: "1", name: "Test", ownerID: "6", createdAt: Timestamp(100000, 0));
      // When
      final result = landingPage.copyWith(ownerID: "6");
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageModel_ToMap", () {
    final lastUpdated = DateTime.now();
    test("check if model is successfully converted to a map", () {
      final model = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          promotionTemplate: "Template Test",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          contentID: "1",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: lastUpdated,
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          isActive: true,
          impressum: "Test",
          privacyPolicy: "Test",
          initialInformation: "Test",
          termsAndConditions: "Test",
          scriptTags: "<script> Test </script>",
          contactEmailAddress: "test@x.de",
          calendlyEventURL: null,
          companyData: null);

      final expectedResult = {
        "id": "1",
        "name": "Test",
        "description": "TestX",
        "promotionTemplate": "Template Test",
        "downloadImageUrl": "url",
        "thumbnailDownloadURL": "thumb_url",
        "ownerID": "2",
        "contentID": "1",
        "associatedUsersIDs": ["1", "2"],
        "lastUpdatedAt": lastUpdated,
        "isDefaultPage": false,
        "createdAt": Timestamp(100000, 0),
        "isActive": true,
        "impressum": "Test",
        "privacyPolicy": "Test",
        "initialInformation": "Test",
        "termsAndConditions": "Test",
        "scripts": "<script> Test </script>",
        "contactEmailAddress": "test@x.de",
        "businessModel": null,
        "contactOption": null,
        "calendlyEventURL": null,
        "companyData": null,
        "visitsTotal": null
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "name": "Test",
        "description": "TestX",
        "downloadImageUrl": "url",
        "thumbnailDownloadURL": "thumb_url",
        "ownerID": "2",
        "associatedUsersIDs": ["1", "2"],
        "lastUpdatedAt": Timestamp(100000, 0),
        "isDefaultPage": false,
        "createdAt": Timestamp(100000, 0),
        "isActive": true
      };
      final expectedResult = LandingPageModel(
          id: "",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          isActive: true,
          calendlyEventURL: null);
      // When
      final result = LandingPageModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "",
        "name": "Test",
        "description": "TestX",
        "downloadImageUrl": "url",
        "thumbnailDownloadURL": "thumb_url",
        "ownerID": "2",
        "associatedUsersIDs": ["1", "2"],
        "lastUpdatedAt": Timestamp(100000, 0),
        "isDefaultPage": false,
        "createdAt": Timestamp(100000, 0)
      };
      final expectedResult = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          calendlyEventURL: null);
      // When
      final result = LandingPageModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("LandingPageModel_ToDomain", () {
    test("check if conversion from LandingPageModel to LandingPage works", () {
      // Given
      final model = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          calendlyEventURL: null);
      final exoectedResult = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: UniqueID.fromUniqueString("2"),
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0).toDate());
      // When
      final result = model.toDomain();
      expect(result, exoectedResult);
    });
  });

  group("LandingPageModel_FromDomain", () {
    test("check if conversion from LandingPage to LandingPageModel works", () {
      // Given
      final model = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: UniqueID.fromUniqueString("2"),
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0).toDate());
      final expectedResult = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          calendlyEventURL: null);
      // When
      final result = LandingPageModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          calendlyEventURL: null);
      final model2 = LandingPageModel(
          id: "1",
          name: "Test",
          description: "TestX",
          downloadImageUrl: "url",
          thumbnailDownloadURL: "thumb_url",
          ownerID: "2",
          associatedUsersIDs: const ["1", "2"],
          lastUpdatedAt: Timestamp(100000, 0).toDate(),
          isDefaultPage: false,
          createdAt: Timestamp(100000, 0),
          calendlyEventURL: null);
      // Then
      expect(model, model2);
    });
  });
}
