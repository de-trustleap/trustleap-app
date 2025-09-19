import 'package:flutter/material.dart';

class SectionMaxWidthProvider extends InheritedWidget {
  final double? sectionMaxWidth;

  const SectionMaxWidthProvider({
    super.key,
    required this.sectionMaxWidth,
    required super.child,
  });

  static SectionMaxWidthProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SectionMaxWidthProvider>();
  }

  @override
  bool updateShouldNotify(SectionMaxWidthProvider oldWidget) {
    return sectionMaxWidth != oldWidget.sectionMaxWidth;
  }
}