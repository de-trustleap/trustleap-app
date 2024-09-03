// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_widget_model.dart';

class PageBuilderSectionModel extends Equatable {
  final String id;
  final String? layout;
  final List<Map<String, dynamic>>? widgets;

  const PageBuilderSectionModel({
    required this.id,
    required this.layout,
    required this.widgets,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'layout': layout, 'widgets': widgets};
  }

  factory PageBuilderSectionModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderSectionModel(
        id: map['id'] != null ? map['id'] as String : "",
        layout: map['layout'] != null ? map['layout'] as String : "none",
        widgets: map['widgets'] != null
            ? List<Map<String, dynamic>>.from((map['widgets'] as List)
                .map((item) => item as Map<String, dynamic>))
            : null);
  }

  PageBuilderSectionModel copyWith({
    String? id,
    String? layout,
    List<Map<String, dynamic>>? widgets,
  }) {
    return PageBuilderSectionModel(
      id: id ?? this.id,
      layout: layout ?? this.layout,
      widgets: widgets ?? this.widgets,
    );
  }

  factory PageBuilderSectionModel.fromFirestore(
      Map<String, dynamic> doc, String id) {
    return PageBuilderSectionModel.fromMap(doc).copyWith(id: id);
  }

  PageBuilderSection toDomain() {
    return PageBuilderSection(
        id: UniqueID.fromUniqueString(id),
        layout: layout == null
            ? PageBuilderSectionLayout.none
            : PageBuilderSectionLayout.values
                .firstWhere((element) => element.name == layout),
        widgets: _getPageBuilderWidgetList(widgets));
  }

    factory PageBuilderSectionModel.fromDomain(PageBuilderSection widget) {
    return PageBuilderSectionModel(
        id: widget.id.value,
        layout: widget.layout?.name,
        widgets: _getMapFromPageBuilderWidgetList(widget.widgets));
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

  static List<Map<String, dynamic>>? _getMapFromPageBuilderWidgetList(List<PageBuilderWidget>? widgets) {
    if (widgets == null) {
      return null;
    }
    final widgetModels = widgets.map((model) => PageBuilderWidgetModel.fromDomain(model)).toList();
    return widgetModels.map((model) => model.toMap()).toList();
  } 

  @override
  List<Object?> get props => [id, layout];
}
