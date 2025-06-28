import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PagebuilderColumnProperties extends Equatable
    implements PageBuilderProperties {
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const PagebuilderColumnProperties(
      {required this.mainAxisAlignment, required this.crossAxisAlignment});

  PagebuilderColumnProperties copyWith(
      {MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment}) {
    return PagebuilderColumnProperties(
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment);
  }

  PagebuilderColumnProperties deepCopy() {
    return PagebuilderColumnProperties(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  @override
  List<Object?> get props => [mainAxisAlignment, crossAxisAlignment];
}
