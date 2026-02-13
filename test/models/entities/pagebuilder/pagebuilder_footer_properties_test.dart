import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderFooterProperties_CopyWith", () {
    test(
        "set privacyPolicyTextProperties with copyWith should set minLines and privacyPolicyTextProperties for resulting object",
        () {
      // Given
      final model = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      final expectedResult = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center)),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      // When
      final result = model.copyWith(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center)));
      // Then
      expect(expectedResult, result);
    });
  });

  group("PagebuilderFooterProperties_Props", () {
    test("check if value equality works", () {
      // Given
      // Given
      final model = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      final model2 = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      // Then
      expect(model, model2);
    });
  });
}
