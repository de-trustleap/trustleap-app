import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LandingPage_CopyWith", () {
    test(
        "set name, text and downloadImageUrl with copyWith should set name, text and downloadImageUrl for resulting object",
        () {
      // Given
      final landingPage = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          text: "TestText",
          downloadImageUrl: "www.downloadImageUrl.de");

      final expectedResult = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "TestNew",
          text: "TestTextNew",
          downloadImageUrl: "https://trust-leap.de");
      // When
      final result =
          landingPage.copyWith(name: "TestNew", text: "TestTextNew", downloadImageUrl: "https://trust-leap.de");
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPage_Props", () {
    test("check if value equality works", () {
      // Given
      final landingPage1 = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          text: "TestText",
          downloadImageUrl: "https://trust-leap.de",
          thumbnailDownloadURL: "TestThumbnailDownloadURL",
          ownerID: UniqueID.fromUniqueString("1"),
          isDefaultPage: false
          );

      final landingPage2 = LandingPage(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          text: "TestText",
          downloadImageUrl: "https://trust-leap.de",
          thumbnailDownloadURL: "TestThumbnailDownloadURL",
          ownerID: UniqueID.fromUniqueString("1"),
          isDefaultPage: false);
      // Then
      expect(landingPage1, landingPage2);
    });
  });
}
