// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_widget_model.dart';
import 'package:flutter/material.dart';

class PageBuilderSectionModel extends Equatable {
  final String id;
  final String? layout;
  final String? backgroundColor;
  final double? maxWidth;
  final List<Map<String, dynamic>>? widgets;

  const PageBuilderSectionModel({
    required this.id,
    required this.layout,
    required this.backgroundColor,
    required this.maxWidth,
    required this.widgets,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (layout != null) map['layout'] = layout;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (maxWidth != null) map['maxWidth'] = maxWidth;
    if (widgets != null) map['widgets'] = widgets;
    return map;
  }

  factory PageBuilderSectionModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderSectionModel(
        id: map['id'] != null ? map['id'] as String : "",
        layout: map['layout'] != null ? map['layout'] as String : "none",
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        maxWidth: map['maxWidth'] != null ? map['maxWidth'] as double : null,
        widgets: map['widgets'] != null
            ? List<Map<String, dynamic>>.from((map['widgets'] as List)
                .map((item) => item as Map<String, dynamic>))
            : null);
  }

  PageBuilderSectionModel copyWith({
    String? id,
    String? layout,
    String? backgroundColor,
    double? maxWidth,
    List<Map<String, dynamic>>? widgets,
  }) {
    return PageBuilderSectionModel(
      id: id ?? this.id,
      layout: layout ?? this.layout,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      maxWidth: maxWidth ?? this.maxWidth,
      widgets: widgets ?? this.widgets,
    );
  }

  PageBuilderSection toDomain() {
    return PageBuilderSection(
        id: UniqueID.fromUniqueString(id),
        layout: layout == null
            ? PageBuilderSectionLayout.none
            : PageBuilderSectionLayout.values
                .firstWhere((element) => element.name == layout),
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        maxWidth: maxWidth,
        widgets: _getPageBuilderWidgetList(widgets));
  }

  factory PageBuilderSectionModel.fromDomain(PageBuilderSection section) {
    return PageBuilderSectionModel(
        id: section.id.value,
        layout: section.layout?.name,
        backgroundColor: section.backgroundColor?.value != null
            ? section.backgroundColor!.value.toRadixString(16)
            : null,
        maxWidth: section.maxWidth,
        widgets: _getMapFromPageBuilderWidgetList(section.widgets));
  }

  List<PageBuilderWidget>? _getPageBuilderWidgetList(
      List<Map<String, dynamic>>? widgets) {
    if (widgets == null) {
      return null;
    }
    final widgetModels =
        widgets.map((map) => PageBuilderWidgetModel.fromMap(map)).toList();
    return widgetModels.map((model) => model.toDomain()).toList();
  }

  static List<Map<String, dynamic>>? _getMapFromPageBuilderWidgetList(
      List<PageBuilderWidget>? widgets) {
    if (widgets == null) {
      return null;
    }
    final widgetModels = widgets
        .map((model) => PageBuilderWidgetModel.fromDomain(model))
        .toList();
    return widgetModels.map((model) => model.toMap()).toList();
  }

  @override
  List<Object?> get props => [id, layout, backgroundColor, maxWidth, widgets];
}
