// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_background_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_widget_model.dart';

class PageBuilderSectionModel extends Equatable {
  final String id;
  final String? name;
  final Map<String, dynamic>? background;
  final double? maxWidth;
  final bool? backgroundConstrained;
  final String? customCSS;
  final PagebuilderResponsiveOrConstantModel<bool>? fullHeight;
  final List<Map<String, dynamic>>? widgets;
  final List<String>? visibleOn;

  const PageBuilderSectionModel({
    required this.id,
    required this.name,
    required this.background,
    required this.maxWidth,
    required this.backgroundConstrained,
    required this.customCSS,
    required this.fullHeight,
    required this.widgets,
    required this.visibleOn,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (name != null) map['name'] = name;
    if (background != null) map['background'] = background;
    if (maxWidth != null) map['maxWidth'] = maxWidth;
    if (backgroundConstrained != null) {
      map['backgroundConstrained'] = backgroundConstrained;
    }
    if (customCSS != null) map['customCSS'] = customCSS;
    if (fullHeight != null) map['fullHeight'] = fullHeight!.toMapValue();
    if (widgets != null) map['widgets'] = widgets;
    if (visibleOn != null) map['visibleOn'] = visibleOn;
    return map;
  }

  factory PageBuilderSectionModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderSectionModel(
        id: map['id'] != null ? map['id'] as String : "",
        name: map['name'] != null ? map['name'] as String : null,
        background: map['background'] != null
            ? map['background'] as Map<String, dynamic>
            : null,
        maxWidth: map['maxWidth'] != null ? map['maxWidth'] as double : null,
        backgroundConstrained: map['backgroundConstrained'] != null
            ? map['backgroundConstrained'] as bool
            : null,
        customCSS: map['customCSS'] != null ? map['customCSS'] as String : null,
        fullHeight: map['fullHeight'] != null
            ? PagebuilderResponsiveOrConstantModel.fromMapValue(
                map['fullHeight'], (v) => v as bool)
            : null,
        widgets: map['widgets'] != null
            ? List<Map<String, dynamic>>.from((map['widgets'] as List)
                .map((item) => item as Map<String, dynamic>))
            : null,
        visibleOn: map['visibleOn'] != null
            ? List<String>.from(map['visibleOn'] as List)
            : null);
  }

  PageBuilderSectionModel copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? background,
    double? maxWidth,
    bool? backgroundConstrained,
    String? customCSS,
    PagebuilderResponsiveOrConstantModel<bool>? fullHeight,
    List<Map<String, dynamic>>? widgets,
    List<String>? visibleOn,
  }) {
    return PageBuilderSectionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      background: background ?? this.background,
      maxWidth: maxWidth ?? this.maxWidth,
      backgroundConstrained:
          backgroundConstrained ?? this.backgroundConstrained,
      customCSS: customCSS ?? this.customCSS,
      fullHeight: fullHeight ?? this.fullHeight,
      widgets: widgets ?? this.widgets,
      visibleOn: visibleOn ?? this.visibleOn,
    );
  }

  PageBuilderSection toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderSection(
        id: UniqueID.fromUniqueString(id),
        name: name,
        background: background != null
            ? PagebuilderBackgroundModel.fromMap(background!).toDomain(globalStyles)
            : null,
        maxWidth: maxWidth,
        backgroundConstrained: backgroundConstrained,
        customCSS: customCSS,
        fullHeight: fullHeight?.toDomain(),
        widgets: getPageBuilderWidgetList(widgets, globalStyles),
        visibleOn: visibleOn
            ?.map((breakpointName) => PagebuilderResponsiveBreakpoint.values
                .firstWhere((e) => e.name == breakpointName))
            .toList());
  }

  factory PageBuilderSectionModel.fromDomain(PageBuilderSection section) {
    return PageBuilderSectionModel(
        id: section.id.value,
        name: section.name,
        background: section.background != null
            ? PagebuilderBackgroundModel.fromDomain(section.background!).toMap()
            : null,
        customCSS: section.customCSS,
        maxWidth: section.maxWidth,
        backgroundConstrained: section.backgroundConstrained,
        fullHeight: section.fullHeight != null
            ? PagebuilderResponsiveOrConstantModel.fromDomain(section.fullHeight!)
            : null,
        widgets: getMapFromPageBuilderWidgetList(section.widgets),
        visibleOn: section.visibleOn?.map((e) => e.name).toList());
  }

  List<PageBuilderWidget>? getPageBuilderWidgetList(
      List<Map<String, dynamic>>? widgets, PageBuilderGlobalStyles? globalStyles) {
    if (widgets == null) {
      return null;
    }
    final widgetModels =
        widgets.map((map) => PageBuilderWidgetModel.fromMap(map)).toList();
    return widgetModels.map((model) => model.toDomain(globalStyles)).toList();
  }

  static List<Map<String, dynamic>>? getMapFromPageBuilderWidgetList(
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
  List<Object?> get props => [
        id,
        name,
        background,
        maxWidth,
        backgroundConstrained,
        customCSS,
        fullHeight,
        widgets,
        visibleOn
      ];
}
