import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderCalendlyProperties_CopyWith", () {
    test(
        "set calendlyEventURL and eventTypeName with copyWith should set calendlyEventURL and eventTypeName for resulting object",
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
        primaryColor: Colors.blue,
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test2",
        eventTypeName: "Test Event 2",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
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
      const model = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
        hideEventTypeDetails: false,
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
        primaryColor: Colors.blue,
        hideEventTypeDetails: true,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = model.copyWith(hideEventTypeDetails: true);
      // Then
      expect(result, expectedResult);
    });

    test("set colors with copyWith should set colors for resulting object", () {
      // Given
      const model = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const expectedResult = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.red,
        backgroundColor: Colors.grey,
        primaryColor: Colors.green,
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // When
      final result = model.copyWith(
        textColor: Colors.red,
        backgroundColor: Colors.grey,
        primaryColor: Colors.green,
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderCalendlyProperties_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      const properties2 = PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        borderRadius: 8.0,
        calendlyEventURL: "https://calendly.com/test",
        eventTypeName: "Test Event",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
        hideEventTypeDetails: false,
        useIntrinsicHeight: false,
        shadow: null,
      );
      // Then
      expect(properties1, properties2);
    });

    test("check if value equality works with null values", () {
      // Given
      const properties1 = PagebuilderCalendlyProperties(
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
      const properties2 = PagebuilderCalendlyProperties(
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