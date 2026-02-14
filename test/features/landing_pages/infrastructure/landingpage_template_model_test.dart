import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/landing_page_template_model.dart';

void main() {
  group("LandingPageTemplateModel_CopyWith", () {
    test("set name with copyWith should set name for resulting object", () {
      // Given
      final template = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      final expectedResult = LandingPageTemplateModel(
          id: "1", name: "Test2", thumbnailDownloadURL: "Test", page: null);
      // When
      final result = template.copyWith(name: "Test2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageTemplateModel_ToMap", () {
    final lastUpdated = DateTime.now();
    test("check if model is successfully converted to a map", () {
      // Given
      final model = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      final expectedResult = {
        "id": "1",
        "name": "Test",
        "thumbnailDownloadURL": "Test"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageTemplateModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"id": "1", "name": "Test", "thumbnailDownloadURL": "Test"};
      final expectedResult = LandingPageTemplateModel(
          id: "", name: "Test", thumbnailDownloadURL: "Test", page: null);
      // When
      final result = LandingPageTemplateModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageTemplateModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {"id": "1", "name": "Test", "thumbnailDownloadURL": "Test"};
      final expectedResult = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      // When
      final result = LandingPageTemplateModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("LandingPageTemplateModel_ToDomain", () {
    test(
        "check if conversion from LandingPageTemplateModel to LandingPageTemplate works",
        () {
      // Given
      final model = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      final exoectedResult = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, exoectedResult);
    });
  });

  group("LandingPageTemplateModel_FromDomain", () {
    test(
        "check if conversion from LandingPageTemplate to LandingPageTemplateModel works",
        () {
      // Given
      final model = LandingPageTemplate(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          thumbnailDownloadURL: "Test",
          page: null);
      final expectedResult = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      // When
      final result = LandingPageTemplateModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LandingPageTemplateModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      final model2 = LandingPageTemplateModel(
          id: "1", name: "Test", thumbnailDownloadURL: "Test", page: null);
      // Then
      expect(model, model2);
    });
  });
}
