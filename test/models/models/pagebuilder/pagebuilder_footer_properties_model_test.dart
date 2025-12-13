import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_footer_properties_model.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderFooterPropertiesModel_CopyWith", () {
    test(
        "set privacyPolicyTextProperties with copyWith should set privacyPolicyTextProperties for resulting object",
        () {
      // Given
      final model = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });

      // When
      final result = model.copyWith(privacyPolicyTextProperties: {
        "text": "Test",
        "fontSize": 16.0,
        "fontFamily": "Poppins"
      });
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderFooterPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = {
        "privacyPolicyTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "impressumTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "initialInformationTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "termsAndConditionsTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderFooterPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "privacyPolicyTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "impressumTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "initialInformationTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "termsAndConditionsTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        }
      };
      final expectedResult = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      // When
      final result = PagebuilderFooterPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderFooterPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderFooterPropertiesModel to PagebuilderFooterProperties works",
        () {
      // Given
      final model = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              textShadow: null),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              textShadow: null),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              textShadow: null),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              textShadow: null));
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderFooterPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderFooterProperties to PagebuilderFooterPropertiesModel works",
        () {
      // Given
      final model = PagebuilderFooterProperties(
          privacyPolicyTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: null,
              textShadow: null),
          impressumTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: null,
              textShadow: null),
          initialInformationTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: null,
              textShadow: null),
          termsAndConditionsTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              color: null,
              alignment: null,
              textShadow: null));
      final expectedResult = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      // When
      final result = PagebuilderFooterPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderFooterPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final properties2 = PagebuilderFooterPropertiesModel(
          privacyPolicyTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          impressumTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          initialInformationTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          termsAndConditionsTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      // Then
      expect(properties1, properties2);
    });
  });
}
