import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_global_fonts_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_fonts.dart';

void main() {
  group("PageBuilderGlobalFontsModel_CopyWith", () {
    test("set headline with copyWith should set headline for resulting object",
        () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Arial",
        text: null,
      );
      // When
      final result = model.copyWith(headline: "Arial");
      // Then
      expect(result, expectedResult);
    });

    test("set text with copyWith should set text for resulting object", () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Lato",
      );
      // When
      final result = model.copyWith(text: "Lato");
      // Then
      expect(result, expectedResult);
    });

    test("set both fonts with copyWith should update both fonts", () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Arial",
        text: "Lato",
      );
      // When
      final result = model.copyWith(
        headline: "Arial",
        text: "Lato",
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalFontsModel_ToMap", () {
    test("check if model with both fonts is successfully converted to a map",
        () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      final expectedResult = {
        "headline": "Roboto",
        "text": "Open Sans",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with partial fonts is successfully converted to a map",
        () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      final expectedResult = {
        "headline": "Roboto",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if empty model is successfully converted to empty map", () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      const expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalFontsModel_FromMap", () {
    test("check if map with both fonts is successfully converted to model", () {
      // Given
      final map = {
        "headline": "Roboto",
        "text": "Open Sans",
      };
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with partial fonts is successfully converted to model",
        () {
      // Given
      final map = {
        "headline": "Roboto",
      };
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if empty map is successfully converted to empty model", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalFontsModel_ToDomain", () {
    test(
        "check if conversion from PageBuilderGlobalFontsModel to PageBuilderGlobalFonts works",
        () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion with partial fonts from model to domain works",
        () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty model to empty domain works", () {
      // Given
      const model = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      const expectedResult = PageBuilderGlobalFonts(
        headline: null,
        text: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalFontsModel_FromDomain", () {
    test(
        "check if conversion from PageBuilderGlobalFonts to PageBuilderGlobalFontsModel works",
        () {
      // Given
      const domain = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test(
        "check if conversion with partial fonts from domain to model works",
        () {
      // Given
      const domain = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty domain returns empty model", () {
      // Given
      const domain = PageBuilderGlobalFonts(
        headline: null,
        text: null,
      );
      const expectedResult = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      // When
      final result = PageBuilderGlobalFontsModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalFontsModel_Props", () {
    test("check if value equality works for same fonts", () {
      // Given
      const model1 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const model2 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different fonts", () {
      // Given
      const model1 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const model2 = PageBuilderGlobalFontsModel(
        headline: "Arial",
        text: "Open Sans",
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value equality works for empty models", () {
      // Given
      const model1 = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      const model2 = PageBuilderGlobalFontsModel(
        headline: null,
        text: null,
      );
      // Then
      expect(model1, model2);
    });

    test("check if value equality works for partial fonts", () {
      // Given
      const model1 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const model2 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      // Then
      expect(model1, model2);
    });
  });
}
