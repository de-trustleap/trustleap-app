import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_calendly_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderCalendlyPropertiesModel_CopyWith", () {
    test(
        "set calendlyEventURL and eventTypeName with copyWith should set calendlyEventURL and eventTypeName for resulting object",
        () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test2",
        eventTypeName: "Test Event 2",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = model.copyWith(
        calendlyEventURL: "https://calendly.com/test2",
        eventTypeName: "Test Event 2",
      );
      // Then
      expect(result, expectedResult);
    });

    test("set hideEventTypeDetails with copyWith should set hideEventTypeDetails for resulting object", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = model.copyWith(hideEventTypeDetails: true);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      final expectedResult = {
        "width": 300.0,
        "height": 200.0,
        "borderRadius": 8.0,
        "calendlyEventURL": "https://calendly.com/test",
        "eventTypeName": "Test Event",
        "textColor": "FF000000",
        "backgroundColor": "FFFFFFFF",
        "primaryColor": "FF2196F3",
        "hideEventTypeDetails": true,
        "useIntrinsicHeight": false,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with null values is successfully converted to a map", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "width": 300.0,
        "height": 200.0,
        "borderRadius": 8.0,
        "calendlyEventURL": "https://calendly.com/test",
        "eventTypeName": "Test Event",
        "textColor": "FF000000",
        "backgroundColor": "FFFFFFFF",
        "primaryColor": "FF2196F3",
        "hideEventTypeDetails": true,
        "useIntrinsicHeight": false,
      };
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with missing values is successfully converted to model", () {
      // Given
      const map = <String, dynamic>{};
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderCalendlyPropertiesModel to PagebuilderCalendlyProperties works",
        () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: const Color(0xFF2196F3),
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with null values works", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyProperties(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderCalendlyProperties to PagebuilderCalendlyPropertiesModel works",
        () {
      // Given
      const model = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: const Color(0xFF2196F3),
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with null values works", () {
      // Given
      const model = PagebuilderCalendlyProperties(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_GlobalStyles", () {
    test("check if textColor token is resolved with globalStyles in toDomain", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: "@primary",
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.textColor, Color(0xFFFF5722));
      expect(result.textColorToken, "@primary");
    });

    test("check if backgroundColor token is resolved with globalStyles in toDomain", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: "@secondary",
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: null,
          secondary: Color(0xFF2196F3),
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.backgroundColor, Color(0xFF2196F3));
      expect(result.backgroundColorToken, "@secondary");
    });

    test("check if primaryColor token is resolved with globalStyles in toDomain", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: "@tertiary",
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: null,
          secondary: null,
          tertiary: Color(0xFF4CAF50),
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.primaryColor, Color(0xFF4CAF50));
      expect(result.primaryColorToken, "@tertiary");
    });

    test("check if all three color tokens are resolved with globalStyles in toDomain", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: "@primary",
        backgroundColor: "@secondary",
        primaryColor: "@tertiary",
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: Color(0xFF2196F3),
          tertiary: Color(0xFF4CAF50),
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.textColor, Color(0xFFFF5722));
      expect(result.textColorToken, "@primary");
      expect(result.backgroundColor, Color(0xFF2196F3));
      expect(result.backgroundColorToken, "@secondary");
      expect(result.primaryColor, Color(0xFF4CAF50));
      expect(result.primaryColorToken, "@tertiary");
    });

    test("check if hex colors do not create tokens even with globalStyles present", () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: "FFFF5722",
        backgroundColor: "FF2196F3",
        primaryColor: "FF4CAF50",
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF5722),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );
      // When
      final result = model.toDomain(globalStyles);
      // Then
      expect(result.textColor, Color(0xFFFF5722));
      expect(result.textColorToken, null);
      expect(result.backgroundColor, Color(0xFF2196F3));
      expect(result.backgroundColorToken, null);
      expect(result.primaryColor, Color(0xFF4CAF50));
      expect(result.primaryColorToken, null);
    });

    test("check if conversion from domain with tokens preserves tokens in fromDomain", () {
      // Given
      const domainProperties = PagebuilderCalendlyProperties(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: Color(0xFFFF5722),
        textColorToken: "@primary",
        backgroundColor: Color(0xFF2196F3),
        backgroundColorToken: "@secondary",
        primaryColor: Color(0xFF4CAF50),
        primaryColorToken: "@tertiary",
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.textColor, "@primary");
      expect(result.backgroundColor, "@secondary");
      expect(result.primaryColor, "@tertiary");
    });

    test("check if conversion from domain without tokens uses hex colors in fromDomain", () {
      // Given
      const domainProperties = PagebuilderCalendlyProperties(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: Color(0xFFFF5722),
        textColorToken: null,
        backgroundColor: Color(0xFF2196F3),
        backgroundColorToken: null,
        primaryColor: Color(0xFF4CAF50),
        primaryColorToken: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromDomain(domainProperties);
      // Then
      expect(result.textColor, "FFFF5722");
      expect(result.backgroundColor, "FF2196F3");
      expect(result.primaryColor, "FF4CAF50");
    });
  });

  group("PagebuilderCalendlyPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const properties2 = PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.constant(300.0),
        height: PagebuilderResponsiveOrConstantModel.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // Then
      expect(properties1, properties2);
    });

    test("check if value equality works with null values", () {
      // Given
      const properties1 = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      const properties2 = PagebuilderCalendlyPropertiesModel(
        width: null,
        height: null,
        borderRadius: null,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: null,
        useIntrinsicHeight: null,
        shadow: null,
      );
      // Then
      expect(properties1, properties2);
    });
  });
}