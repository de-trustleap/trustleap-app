// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderSection extends Equatable {
  final UniqueID id;
  final PageBuilderSectionLayout? layout;
  final Color? backgroundColor;
  final List<PageBuilderWidget>? widgets;

  const PageBuilderSection(
      {required this.id,
      required this.layout,
      required this.widgets,
      required this.backgroundColor});

  PageBuilderSection copyWith(
      {UniqueID? id,
      PageBuilderSectionLayout? layout,
      List<PageBuilderWidget>? widgets,
      Color? backgroundColor}) {
    return PageBuilderSection(
        id: id ?? this.id,
        layout: layout ?? this.layout,
        widgets: widgets ?? this.widgets,
        backgroundColor: backgroundColor ?? this.backgroundColor);
  }

  @override
  List<Object?> get props => [id, layout, backgroundColor, widgets];
}
