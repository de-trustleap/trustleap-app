// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_background_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_column_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_contact_form_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_container_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_footer_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_icon_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_row_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_video_player_properties_model.dart';

class PageBuilderWidgetModel extends Equatable {
  final String id;
  final String? elementType;
  final Map<String, dynamic>? properties;
  final List<PageBuilderWidgetModel>? children;
  final PageBuilderWidgetModel? containerChild;
  final double? widthPercentage;
  final Map<String, dynamic>? background;
  final Map<String, dynamic>? padding;
  final Map<String, dynamic>? margin;
  final double? maxWidth;
  final String? alignment;

  const PageBuilderWidgetModel(
      {required this.id,
      required this.elementType,
      required this.properties,
      required this.children,
      required this.containerChild,
      required this.widthPercentage,
      required this.background,
      required this.padding,
      required this.margin,
      required this.maxWidth,
      required this.alignment});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (elementType != null) map['elementType'] = elementType;
    if (properties != null) map['properties'] = properties;
    if (children != null) {
      map['children'] = children!.map((child) => child.toMap()).toList();
    }
    if (containerChild != null) map['containerChild'] = containerChild!.toMap();
    if (widthPercentage != null) map['widthPercentage'] = widthPercentage;
    if (background != null) map['background'] = background;
    if (padding != null) map['padding'] = padding;
    if (margin != null) map['margin'] = margin;
    if (maxWidth != null) map['maxWidth'] = maxWidth;
    if (alignment != null) map['alignment'] = alignment;
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
        background: map['background'] != null
            ? map['background'] as Map<String, dynamic>
            : null,
        padding: map['padding'] != null
            ? map['padding'] as Map<String, dynamic>
            : null,
        margin: map['margin'] != null
            ? map['margin'] as Map<String, dynamic>
            : null,
        maxWidth: map['maxWidth'] != null ? map['maxWidth'] as double : null,
        alignment: map['alignment'] != null ? map['alignment'] as String : null);
  }

  PageBuilderWidgetModel copyWith(
      {String? id,
      String? elementType,
      Map<String, dynamic>? properties,
      List<PageBuilderWidgetModel>? children,
      PageBuilderWidgetModel? containerChild,
      double? widthPercentage,
      Map<String, dynamic>? background,
      Map<String, dynamic>? padding,
      Map<String, dynamic>? margin,
      double? maxWidth,
      String? alignment}) {
    return PageBuilderWidgetModel(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        children: children ?? this.children,
        containerChild: containerChild ?? this.containerChild,
        widthPercentage: widthPercentage ?? this.widthPercentage,
        background: background ?? this.background,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        maxWidth: maxWidth ?? this.maxWidth,
        alignment: alignment ?? this.alignment);
  }

  PageBuilderWidget toDomain() {
    return PageBuilderWidget(
        id: UniqueID.fromUniqueString(id),
        elementType: elementType == null
            ? PageBuilderWidgetType.none
            : PageBuilderWidgetType.values
                .firstWhere((element) => element.name == elementType),
        properties: getPropertiesByType(elementType),
        children: children?.map((child) => child.toDomain()).toList(),
        containerChild: containerChild?.toDomain(),
        widthPercentage: widthPercentage,
        background: background != null
            ? PagebuilderBackgroundModel.fromMap(background!).toDomain()
            : null,
        padding: PageBuilderSpacing.fromMap(padding),
        margin: PageBuilderSpacing.fromMap(margin),
        maxWidth: maxWidth,
        alignment: AlignmentMapper.getAlignmentFromString(alignment));
  }

  factory PageBuilderWidgetModel.fromDomain(PageBuilderWidget widget) {
    return PageBuilderWidgetModel(
        id: widget.id.value,
        elementType: widget.elementType?.name,
        properties: getMapFromProperties(widget.properties),
        children: widget.children
            ?.map((child) => PageBuilderWidgetModel.fromDomain(child))
            .toList(),
        containerChild: widget.containerChild != null
            ? PageBuilderWidgetModel.fromDomain(widget.containerChild!)
            : null,
        widthPercentage: widget.widthPercentage,
        background: widget.background != null
            ? PagebuilderBackgroundModel.fromDomain(widget.background!).toMap()
            : null,
        padding: getMapFromPadding(widget.padding),
        margin: getMapFromPadding(widget.margin),
        maxWidth: widget.maxWidth,
        alignment: AlignmentMapper.getStringFromAlignment(widget.alignment));
  }

  PageBuilderProperties? getPropertiesByType(String? type) {
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
      case PageBuilderWidgetType.footer:
        return PagebuilderFooterPropertiesModel.fromMap(properties!).toDomain();
      case PageBuilderWidgetType.videoPlayer:
        return PagebuilderVideoPlayerPropertiesModel.fromMap(properties!)
            .toDomain();
      default:
        return null;
    }
  }

  static Map<String, dynamic>? getMapFromProperties(
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
    } else if (properties is PagebuilderFooterProperties) {
      return PagebuilderFooterPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PagebuilderVideoPlayerProperties) {
      return PagebuilderVideoPlayerPropertiesModel.fromDomain(properties)
          .toMap();
    } else {
      return null;
    }
  }

  static Map<String, dynamic>? getMapFromPadding(PageBuilderSpacing? padding) {
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
        background,
        padding,
        margin,
        maxWidth,
        alignment
      ];
}
