import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_height_properties_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PageBuilderHeightPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      final expectedResult = {
        "height": 40,
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("check if model with null height is converted to empty map", () {
      // Given
      const model = PageBuilderHeightPropertiesModel(
        height: null,
      );
      final expectedResult = <String, dynamic>{};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderHeightPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "height": 40,
      };
      const expectedResult = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      // When
      final result = PageBuilderHeightPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map without height is converted to model with null", () {
      // Given
      final map = <String, dynamic>{};
      const expectedResult = PageBuilderHeightPropertiesModel(
        height: null,
      );
      // When
      final result = PageBuilderHeightPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderHeightPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PageBuilderHeightPropertiesModel to PageBuilderHeightProperties works",
        () {
      // Given
      const model = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      const expectedResult = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if null height is correctly converted", () {
      // Given
      const model = PageBuilderHeightPropertiesModel(
        height: null,
      );
      const expectedResult = PageBuilderHeightProperties(
        height: null,
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderHeightPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PageBuilderHeightProperties to PageBuilderHeightPropertiesModel works",
        () {
      // Given
      const domain = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      const expectedResult = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      // When
      final result = PageBuilderHeightPropertiesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });

    test("check if null height is correctly converted", () {
      // Given
      const domain = PageBuilderHeightProperties(
        height: null,
      );
      const expectedResult = PageBuilderHeightPropertiesModel(
        height: null,
      );
      // When
      final result = PageBuilderHeightPropertiesModel.fromDomain(domain);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderHeightPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      const properties2 = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      // Then
      expect(properties1, properties2);
    });

    test("check if inequality works with different height", () {
      // Given
      const properties1 = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(40),
      );
      const properties2 = PageBuilderHeightPropertiesModel(
        height: PagebuilderResponsiveOrConstantModel.constant(60),
      );
      // Then
      expect(properties1, isNot(equals(properties2)));
    });

    test("check if equality works with null height", () {
      // Given
      const properties1 = PageBuilderHeightPropertiesModel(
        height: null,
      );
      const properties2 = PageBuilderHeightPropertiesModel(
        height: null,
      );
      // Then
      expect(properties1, properties2);
    });
  });
}
