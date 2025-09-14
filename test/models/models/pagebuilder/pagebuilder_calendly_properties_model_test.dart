import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_calendly_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderCalendlyPropertiesModel_CopyWith", () {
    test(
        "set calendlyEventURL and eventTypeName with copyWith should set calendlyEventURL and eventTypeName for resulting object",
        () {
      // Given
      const model = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test2",
        eventTypeName: "Test Event 2",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
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
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
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
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
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
      };
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
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
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyProperties(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: const Color(0xFF2196F3),
        hideEventTypeDetails: true,
        shadow: null,
      );
      // When
      final result = model.toDomain();
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
        shadow: null,
      );
      // When
      final result = model.toDomain();
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
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: const Color(0xFF2196F3),
        hideEventTypeDetails: true,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
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
        shadow: null,
      );
      // When
      final result = PagebuilderCalendlyPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
        shadow: null,
      );
      const properties2 = PagebuilderCalendlyPropertiesModel(
        width: 300.0,
        height: 200.0,
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: "FF000000",
        backgroundColor: "FFFFFFFF",
        primaryColor: "FF2196F3",
        hideEventTypeDetails: true,
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
        shadow: null,
      );
      // Then
      expect(properties1, properties2);
    });
  });
}