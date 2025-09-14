import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';


void main() {
  group('ShadowMapper', () {
    test('returns null when shadow is null', () {
      final result = ShadowMapper.getMapFromShadow(null);
      expect(result, isNull);
    });

    test('returns null when shadow has no properties set', () {
      final emptyShadow = PageBuilderShadow(
        color: null,
        spreadRadius: 0,
        blurRadius: 0,
        offset: null,
      );
      final result = ShadowMapper.getMapFromShadow(emptyShadow);
      expect(result, isNull);
    });

    test('returns map with color property when color is set', () {
      final shadowWithColor = PageBuilderShadow(
        color: Colors.red,
        spreadRadius: 0,
        blurRadius: 0,
        offset: null,
      );
      final result = ShadowMapper.getMapFromShadow(shadowWithColor);
      expect(result, {'color': 'FFF44336'});
    });

    test('returns map with spreadRadius when spreadRadius is non-zero', () {
      final shadowWithSpreadRadius = PageBuilderShadow(
        color: null,
        spreadRadius: 5.0,
        blurRadius: 0,
        offset: null,
      );
      final result = ShadowMapper.getMapFromShadow(shadowWithSpreadRadius);
      expect(result, {'spreadRadius': 5.0});
    });

    test('returns map with blurRadius when blurRadius is non-zero', () {
      final shadowWithBlurRadius = PageBuilderShadow(
        color: null,
        spreadRadius: 0,
        blurRadius: 10.0,
        offset: null,
      );
      final result = ShadowMapper.getMapFromShadow(shadowWithBlurRadius);
      expect(result, {'blurRadius': 10.0});
    });

    test('returns map with offset when offset is set', () {
      final shadowWithOffset = PageBuilderShadow(
        color: null,
        spreadRadius: 0,
        blurRadius: 0,
        offset: const Offset(2, 2),
      );
      final result = ShadowMapper.getMapFromShadow(shadowWithOffset);
      expect(result, {'offset': {'x': 2.0, 'y': 2.0}});
    });

    test('returns map with multiple properties when multiple fields are set', () {
      final shadow = PageBuilderShadow(
        color: Colors.blue,
        spreadRadius: 5.0,
        blurRadius: 10.0,
        offset: const Offset(1, 1),
      );
      final result = ShadowMapper.getMapFromShadow(shadow);
      expect(result, {
        'color': 'FF2196F3',
        'spreadRadius': 5.0,
        'blurRadius': 10.0,
        'offset': {'x': 1.0, 'y': 1.0},
      });
    });

    test('ignores properties with default values or null', () {
      final shadow = PageBuilderShadow(
        color: Colors.green,
        spreadRadius: 0,
        blurRadius: 0,
        offset: null,
      );
      final result = ShadowMapper.getMapFromShadow(shadow);
      expect(result, {'color': 'FF4CAF50'});
    });
  });
}