// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:flutter/material.dart';

class PageBuilderGlobalColorsModel extends Equatable {
  final String? primary;
  final String? secondary;
  final String? tertiary;
  final String? background;
  final String? surface;

  const PageBuilderGlobalColorsModel({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (primary != null) map['primary'] = primary;
    if (secondary != null) map['secondary'] = secondary;
    if (tertiary != null) map['tertiary'] = tertiary;
    if (background != null) map['background'] = background;
    if (surface != null) map['surface'] = surface;
    return map;
  }

  factory PageBuilderGlobalColorsModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderGlobalColorsModel(
      primary: map['primary'] as String?,
      secondary: map['secondary'] as String?,
      tertiary: map['tertiary'] as String?,
      background: map['background'] as String?,
      surface: map['surface'] as String?,
    );
  }

  PageBuilderGlobalColorsModel copyWith({
    String? primary,
    String? secondary,
    String? tertiary,
    String? background,
    String? surface,
  }) {
    return PageBuilderGlobalColorsModel(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
    );
  }

  PageBuilderGlobalColors toDomain() {
    return PageBuilderGlobalColors(
      primary: primary != null ? _colorFromHex(primary!) : null,
      secondary: secondary != null ? _colorFromHex(secondary!) : null,
      tertiary: tertiary != null ? _colorFromHex(tertiary!) : null,
      background: background != null ? _colorFromHex(background!) : null,
      surface: surface != null ? _colorFromHex(surface!) : null,
    );
  }

  factory PageBuilderGlobalColorsModel.fromDomain(
      PageBuilderGlobalColors colors) {
    return PageBuilderGlobalColorsModel(
      primary: colors.primary != null ? _colorToHex(colors.primary!) : null,
      secondary:
          colors.secondary != null ? _colorToHex(colors.secondary!) : null,
      tertiary: colors.tertiary != null ? _colorToHex(colors.tertiary!) : null,
      background:
          colors.background != null ? _colorToHex(colors.background!) : null,
      surface: colors.surface != null ? _colorToHex(colors.surface!) : null,
    );
  }

  static Color _colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  List<Object?> get props => [primary, secondary, tertiary, background, surface];
}
