import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PagebuilderRowProperties extends Equatable
    implements PageBuilderProperties {
  final bool? equalHeights;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const PagebuilderRowProperties(
      {required this.equalHeights,
      required this.mainAxisAlignment,
      required this.crossAxisAlignment});

  PagebuilderRowProperties copyWith(
      {bool? equalHeights,
      MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment}) {
    return PagebuilderRowProperties(
        equalHeights: equalHeights ?? this.equalHeights,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment);
  }

  PagebuilderRowProperties deepCopy() {
    return PagebuilderRowProperties(
      equalHeights: equalHeights,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  @override
  List<Object?> get props =>
      [equalHeights, mainAxisAlignment, crossAxisAlignment];
}
