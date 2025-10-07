import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PagebuilderRowProperties extends Equatable
    implements PageBuilderProperties {
  final bool? equalHeights;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final List<PagebuilderResponsiveBreakpoint>? switchToColumnFor;

  const PagebuilderRowProperties(
      {required this.equalHeights,
      required this.mainAxisAlignment,
      required this.crossAxisAlignment,
      required this.switchToColumnFor});

  PagebuilderRowProperties copyWith(
      {bool? equalHeights,
      MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment,
      List<PagebuilderResponsiveBreakpoint>? switchToColumnFor}) {
    return PagebuilderRowProperties(
        equalHeights: equalHeights ?? this.equalHeights,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
        switchToColumnFor: switchToColumnFor ?? this.switchToColumnFor);
  }

  PagebuilderRowProperties deepCopy() {
    return PagebuilderRowProperties(
      equalHeights: equalHeights,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      switchToColumnFor: switchToColumnFor != null
          ? List<PagebuilderResponsiveBreakpoint>.from(switchToColumnFor!)
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [equalHeights, mainAxisAlignment, crossAxisAlignment, switchToColumnFor];
}
