import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_global_styles_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_global_colors_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_global_fonts_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderGlobalStylesModel_CopyWith", () {
    test("set colors with copyWith should set colors for resulting object", () {
      // Given
      const colorsModel1 = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const colorsModel2 = PageBuilderGlobalColorsModel(
        primary: "#00FF00",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: colorsModel1,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: colorsModel2,
        fonts: null,
      );
      // When
      final result = model.copyWith(colors: colorsModel2);
      // Then
      expect(result, expectedResult);
    });

    test("set fonts with copyWith should set fonts for resulting object", () {
      // Given
      const fontsModel1 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const fontsModel2 = PageBuilderGlobalFontsModel(
        headline: "Arial",
        text: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel1,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel2,
      );
      // When
      final result = model.copyWith(fonts: fontsModel2);
      // Then
      expect(result, expectedResult);
    });

    test("set both colors and fonts with copyWith should update both", () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: fontsModel,
      );
      // When
      final result = model.copyWith(
        colors: colorsModel,
        fonts: fontsModel,
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalStylesModel_ToMap", () {
    test(
        "check if model with colors and fonts is successfully converted to a map",
        () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: null,
        background: null,
        surface: null,
      );
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const model = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: fontsModel,
      );
      final expectedResult = {
        "colors": {
          "primary": "#FF0000",
          "secondary": "#00FF00",
        },
        "fonts": {
          "headline": "Roboto",
          "text": "Open Sans",
        },
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with only colors is successfully converted to a map",
        () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: null,
      );
      final expectedResult = {
        "colors": {
          "primary": "#FF0000",
        },
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with only fonts is successfully converted to a map",
        () {
      // Given
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel,
      );
      final expectedResult = {
        "fonts": {
          "headline": "Roboto",
        },
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if empty model is successfully converted to empty map", () {
      // Given
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      const expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalStylesModel_FromMap", () {
    test(
        "check if map with colors and fonts is successfully converted to model",
        () {
      // Given
      final map = {
        "colors": {
          "primary": "#FF0000",
          "secondary": "#00FF00",
        },
        "fonts": {
          "headline": "Roboto",
          "text": "Open Sans",
        },
      };
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: PageBuilderGlobalColorsModel(
          primary: "#FF0000",
          secondary: "#00FF00",
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: PageBuilderGlobalFontsModel(
          headline: "Roboto",
          text: "Open Sans",
        ),
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with only colors is successfully converted to model",
        () {
      // Given
      final map = {
        "colors": {
          "primary": "#FF0000",
        },
      };
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: PageBuilderGlobalColorsModel(
          primary: "#FF0000",
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with only fonts is successfully converted to model", () {
      // Given
      final map = {
        "fonts": {
          "headline": "Roboto",
        },
      };
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: PageBuilderGlobalFontsModel(
          headline: "Roboto",
          text: null,
        ),
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if empty map is successfully converted to empty model", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalStylesModel_ToDomain", () {
    test(
        "check if conversion from PageBuilderGlobalStylesModel to PageBuilderGlobalStyles works",
        () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: "#00FF00",
        tertiary: null,
        background: null,
        surface: null,
      );
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: "Open Sans",
      );
      const model = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: fontsModel,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF0000),
          secondary: Color(0xFF00FF00),
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: PageBuilderGlobalFonts(
          headline: "Roboto",
          text: "Open Sans",
        ),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with only colors from model to domain works", () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF0000),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with only fonts from model to domain works", () {
      // Given
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: null,
        fonts: PageBuilderGlobalFonts(
          headline: "Roboto",
          text: null,
        ),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty model to empty domain works", () {
      // Given
      const model = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalStylesModel_FromDomain", () {
    test(
        "check if conversion from PageBuilderGlobalStyles to PageBuilderGlobalStylesModel works",
        () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const domain = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: PageBuilderGlobalColorsModel(
          primary: "#FF0000",
          secondary: "#00FF00",
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: PageBuilderGlobalFontsModel(
          headline: "Roboto",
          text: "Open Sans",
        ),
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with only colors from domain to model works", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const domain = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: PageBuilderGlobalColorsModel(
          primary: "#FF0000",
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with only fonts from domain to model works", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: null,
      );
      const domain = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: PageBuilderGlobalFontsModel(
          headline: "Roboto",
          text: null,
        ),
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion from empty domain returns empty model", () {
      // Given
      const domain = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      const expectedResult = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      // When
      final result = PageBuilderGlobalStylesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderGlobalStylesModel_Props", () {
    test("check if value equality works for same styles", () {
      // Given
      const colorsModel = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fontsModel = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const model1 = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: fontsModel,
      );
      const model2 = PageBuilderGlobalStylesModel(
        colors: colorsModel,
        fonts: fontsModel,
      );
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works for different colors", () {
      // Given
      const colorsModel1 = PageBuilderGlobalColorsModel(
        primary: "#FF0000",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const colorsModel2 = PageBuilderGlobalColorsModel(
        primary: "#00FF00",
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const model1 = PageBuilderGlobalStylesModel(
        colors: colorsModel1,
        fonts: null,
      );
      const model2 = PageBuilderGlobalStylesModel(
        colors: colorsModel2,
        fonts: null,
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value inequality works for different fonts", () {
      // Given
      const fontsModel1 = PageBuilderGlobalFontsModel(
        headline: "Roboto",
        text: null,
      );
      const fontsModel2 = PageBuilderGlobalFontsModel(
        headline: "Arial",
        text: null,
      );
      const model1 = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel1,
      );
      const model2 = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: fontsModel2,
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if value equality works for empty models", () {
      // Given
      const model1 = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      const model2 = PageBuilderGlobalStylesModel(
        colors: null,
        fonts: null,
      );
      // Then
      expect(model1, model2);
    });
  });
}
