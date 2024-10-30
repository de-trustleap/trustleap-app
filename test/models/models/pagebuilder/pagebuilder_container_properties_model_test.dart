import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_container_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContainerPropertiesModel_CopyWith", () {
    test("set shadow with copyWith should set shadow for resulting object", () {
      // Given
      final model =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2,
        "blurRadius": 1,
        "offset": {"x": 5, "y": 5}
      });
      final expectedResult =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 5,
        "blurRadius": 5,
        "offset": {"x": 5, "y": 6}
      });
      // When
      final result = model.copyWith(shadow: {
        "color": "ff000000",
        "spreadRadius": 5,
        "blurRadius": 5,
        "offset": {"x": 5, "y": 6}
      });
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2,
        "blurRadius": 1,
        "offset": {"x": 5, "y": 5}
      });
      final expectedResult = {
        "borderRadius": 12.0,
        "shadow": {
          "color": "ff000000",
          "spreadRadius": 2,
          "blurRadius": 1,
          "offset": {"x": 5, "y": 5}
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "borderRadius": 12.0,
        "shadow": {
          "color": "ff000000",
          "spreadRadius": 2,
          "blurRadius": 1,
          "offset": {"x": 5, "y": 5}
        }
      };
      final expectedResult =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2,
        "blurRadius": 1,
        "offset": {"x": 5, "y": 5}
      });
      // When
      final result = PageBuilderContainerPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderContainerPropertiesModel to PagebuilderContainerProperties works",
        () {
      // Given
      final model =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 1.0,
        "offset": {"x": 5.0, "y": 5.0}
      });
      final expectedResult = PageBuilderContainerProperties(
          borderRadius: 12.0,
          shadow: PageBuilderShadow(
              color: Color(0xff000000),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(5, 5)));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderContainerProperties to PagebuilderContainerPropertiesModel works",
        () {
      // Given
      final model = PageBuilderContainerProperties(
          borderRadius: 12.0,
          shadow: PageBuilderShadow(
              color: Color(0xff000000),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(5, 5)));
      final expectedResult =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 1.0,
        "offset": {"x": 5.0, "y": 5.0}
      });
      // When
      final result = PageBuilderContainerPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContainerPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 1.0,
        "offset": {"x": 5.0, "y": 5.0}
      });
      final properties2 =
          PageBuilderContainerPropertiesModel(borderRadius: 12.0, shadow: {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 1.0,
        "offset": {"x": 5.0, "y": 5.0}
      });
      // Then
      expect(properties1, properties2);
    });
  });
}
