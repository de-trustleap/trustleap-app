import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_ai_generation_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_ai_generation.dart';

void main() {
  group("PagebuilderAIGenerationsModel_CopyWith", () {
    test(
        "set businessType with copyWith should set businessType for resulting object",
        () {
      // Given
      final model = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      final expectedResult = PagebuilderAiGenerationModel(
          businessType: "Finanzen 2", customDescription: "Test");
      // When
      final result = model.copyWith(businessType: "Finanzen 2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGenerationsModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      final expectedResult = {
        "businessType": "Finanzen",
        "customDescription": "Test"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGenerationsModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"businessType": "Finanzen", "customDescription": "Test"};
      final expectedResult = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      // When
      final result = PagebuilderAiGenerationModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGenerationsModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderAIGenerationsModel to PagebuilderAIGenerations works",
        () {
      // Given
      final model = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      final expectedResult = PagebuilderAiGeneration(
          businessType: "Finanzen", customDescription: "Test");
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGenerationsModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderAIGenerations to PagebuilderAIGenerationsModel works",
        () {
      // Given
      final model = PagebuilderAiGeneration(
          businessType: "Finanzen", customDescription: "Test");
      final expectedResult = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      // When
      final result = PagebuilderAiGenerationModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGenerationsModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      final model2 = PagebuilderAiGenerationModel(
          businessType: "Finanzen", customDescription: "Test");
      // Then
      expect(model, model2);
    });
  });
}
