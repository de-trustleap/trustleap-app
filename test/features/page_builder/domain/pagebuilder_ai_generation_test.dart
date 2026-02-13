import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_ai_generation.dart';

void main() {
  group("PagebuilderAIGeneration_CopyWith", () {
    test(
        "set businessType with copyWith should set businessType for resulting object",
        () {
      // Given
      final model = PagebuilderAiGeneration(
          businessType: "Finanzen",
          customDescription: "Gibt es seit 50 Jahren");
      final expectedResult = PagebuilderAiGeneration(
          businessType: "Versicherungen",
          customDescription: "Gibt es seit 50 Jahren");
      // When
      final result = model.copyWith(businessType: "Versicherungen");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAIGeneration_Props", () {
    test("check if value equality works", () {
      // Given
      final model = PagebuilderAiGeneration(
          businessType: "Finanzen",
          customDescription: "Gibt es seit 50 Jahren");
      final model2 = PagebuilderAiGeneration(
          businessType: "Finanzen",
          customDescription: "Gibt es seit 50 Jahren");
      // Then
      expect(model, model2);
    });
  });
}
