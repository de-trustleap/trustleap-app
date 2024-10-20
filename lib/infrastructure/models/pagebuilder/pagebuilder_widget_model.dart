// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_padding.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_column_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_contact_form_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_container_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_icon_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_row_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:flutter/material.dart';

class PageBuilderWidgetModel extends Equatable {
  final String id;
  final String? elementType;
  final Map<String, dynamic>? properties;
  final List<PageBuilderWidgetModel>? children;
  final PageBuilderWidgetModel? containerChild;
  final double? widthPercentage;
  final String? backgroundColor;
  final Map<String, dynamic>? padding;
  final double? maxWidth;

  const PageBuilderWidgetModel(
      {required this.id,
      required this.elementType,
      required this.properties,
      required this.children,
      required this.containerChild,
      required this.widthPercentage,
      required this.backgroundColor,
      required this.padding,
      required this.maxWidth});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (elementType != null) map['elementType'] = elementType;
    if (properties != null) map['properties'] = properties;
    if (children != null) {
      map['children'] = children!.map((child) => child.toMap()).toList();
    }
    if (containerChild != null) map['containerChild'] = containerChild!.toMap();
    if (widthPercentage != null) map['widthPercentage'] = widthPercentage;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (padding != null) map['padding'] = padding;
    if (maxWidth != null) map['maxWidth'] = maxWidth;
    return map;
  }

  factory PageBuilderWidgetModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderWidgetModel(
        id: map['id'] != null ? map['id'] as String : "",
        elementType:
            map['elementType'] != null ? map['elementType'] as String : "none",
        properties: map['properties'] != null
            ? map['properties'] as Map<String, dynamic>
            : null,
        children: map['children'] != null
            ? List<PageBuilderWidgetModel>.from(
                (map['children'] as List<dynamic>).map((child) =>
                    PageBuilderWidgetModel.fromMap(
                        child as Map<String, dynamic>)))
            : null,
        containerChild: map['containerChild'] != null
            ? PageBuilderWidgetModel.fromMap(
                map['containerChild'] as Map<String, dynamic>)
            : null,
        widthPercentage: map['widthPercentage'] != null
            ? map['widthPercentage'] as double
            : null,
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        padding: map['padding'] != null
            ? map['padding'] as Map<String, dynamic>
            : null,
        maxWidth: map['maxWidth'] != null ? map['maxWidth'] as double : null);
  }

  PageBuilderWidgetModel copyWith(
      {String? id,
      String? elementType,
      Map<String, dynamic>? properties,
      List<PageBuilderWidgetModel>? children,
      PageBuilderWidgetModel? containerChild,
      double? widthPercentage,
      String? backgroundColor,
      Map<String, dynamic>? padding,
      double? maxWidth}) {
    return PageBuilderWidgetModel(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        children: children ?? this.children,
        containerChild: containerChild ?? this.containerChild,
        widthPercentage: widthPercentage ?? this.widthPercentage,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        padding: padding ?? this.padding,
        maxWidth: maxWidth ?? this.maxWidth);
  }

  PageBuilderWidget toDomain() {
    return PageBuilderWidget(
        id: UniqueID.fromUniqueString(id),
        elementType: elementType == null
            ? PageBuilderWidgetType.none
            : PageBuilderWidgetType.values
                .firstWhere((element) => element.name == elementType),
        properties: _getPropertiesByType(elementType),
        children: children?.map((child) => child.toDomain()).toList(),
        containerChild: containerChild?.toDomain(),
        widthPercentage: widthPercentage,
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        padding: PageBuilderPadding.fromMap(padding),
        maxWidth: maxWidth);
  }

  factory PageBuilderWidgetModel.fromDomain(PageBuilderWidget widget) {
    return PageBuilderWidgetModel(
        id: widget.id.value,
        elementType: widget.elementType?.name,
        properties: _getMapFromProperties(widget.properties),
        children: widget.children
            ?.map((child) => PageBuilderWidgetModel.fromDomain(child))
            .toList(),
        containerChild: widget.containerChild != null
            ? PageBuilderWidgetModel.fromDomain(widget.containerChild!)
            : null,
        widthPercentage: widget.widthPercentage,
        backgroundColor: widget.backgroundColor?.value != null
            ? widget.backgroundColor!.value.toRadixString(16)
            : null,
        padding: _getMapFromPadding(widget.padding),
        maxWidth: widget.maxWidth);
  }

  PageBuilderProperties? _getPropertiesByType(String? type) {
    if (properties == null) {
      return null;
    }
    final widgetType = type == null
        ? PageBuilderWidgetType.none
        : PageBuilderWidgetType.values
            .firstWhere((element) => element.name == type);
    switch (widgetType) {
      case PageBuilderWidgetType.text:
        return PageBuilderTextPropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.image:
        return PageBuilderImagePropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.icon:
        return PageBuilderIconPropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.container:
        return PageBuilderContainerPropertiesModel.fromMap(properties!)
            .toDomain();
      case PageBuilderWidgetType.row:
        return PagebuilderRowPropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.column:
        return PagebuilderColumnPropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.contactForm:
        return PageBuilderContactFormPropertiesModel.fromMap(properties!)
            .toDomain();
      default:
        return null;
    }
  }

  static Map<String, dynamic>? _getMapFromProperties(
      PageBuilderProperties? properties) {
    if (properties == null) {
      return null;
    }
    if (properties is PageBuilderTextProperties) {
      return PageBuilderTextPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PageBuilderImageProperties) {
      return PageBuilderImagePropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PageBuilderIconProperties) {
      return PageBuilderIconPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PageBuilderContainerProperties) {
      return PageBuilderContainerPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PagebuilderRowProperties) {
      return PagebuilderRowPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PagebuilderColumnProperties) {
      return PagebuilderColumnPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PageBuilderContactFormProperties) {
      return PageBuilderContactFormPropertiesModel.fromDomain(properties)
          .toMap();
    } else {
      return null;
    }
  }

  static Map<String, dynamic>? _getMapFromPadding(PageBuilderPadding? padding) {
    if (padding == null) {
      return null;
    }
    Map<String, dynamic> map = {};
    if (padding.top != null && padding.top != 0) map['top'] = padding.top;
    if (padding.bottom != null && padding.bottom != 0) {
      map['bottom'] = padding.bottom;
    }
    if (padding.left != null && padding.left != 0) map['left'] = padding.left;
    if (padding.right != null && padding.right != 0) {
      map['right'] = padding.right;
    }
    if (map.isEmpty) {
      return null;
    } else {
      return map;
    }
  }

  @override
  List<Object?> get props => [
        id,
        elementType,
        properties,
        children,
        containerChild,
        widthPercentage,
        backgroundColor,
        padding,
        maxWidth
      ];
}
