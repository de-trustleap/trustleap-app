// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PageBuilderGlobalColors extends Equatable {
  final Color? primary;
  final Color? secondary;
  final Color? tertiary;
  final Color? background;
  final Color? surface;

  const PageBuilderGlobalColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
  });

  PageBuilderGlobalColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? background,
    Color? surface,
  }) {
    return PageBuilderGlobalColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
    );
  }

  @override
  List<Object?> get props => [primary, secondary, tertiary, background, surface];
}
