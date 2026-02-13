import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';

void main() {
  group("LandingPageTemplate_CopyWith", () {
    test(
        "set name, thumbnailDownloadURL with copyWith should set name and thumbnailDownloadURL for resulting object",
        () {
      // Given
      final template = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null);
      final expectedResult = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test2",
          thumbnailDownloadURL: "Test2",
          page: null);
      // When
      final result =
          template.copyWith(name: "Test2", thumbnailDownloadURL: "Test2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageTemplate_Props", () {
    test("check if value equality works", () {
      // Given
      final template = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null);
      final template2 = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null);
      // Then
      expect(template, template2);
    });
  });
}
