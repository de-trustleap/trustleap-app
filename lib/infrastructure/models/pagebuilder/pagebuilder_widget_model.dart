// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_anchor_button_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_background_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_calendly_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_column_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_contact_form_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_container_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_footer_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_height_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_icon_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_row_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_spacing_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_video_player_properties_model.dart';

class PageBuilderWidgetModel extends Equatable {
  final String id;
  final String? elementType;
  final Map<String, dynamic>? properties;
  final Map<String, dynamic>? hoverProperties;
  final List<PageBuilderWidgetModel>? children;
  final PageBuilderWidgetModel? containerChild;
  final PagebuilderResponsiveOrConstantModel<double>? widthPercentage;
  final Map<String, dynamic>? background;
  final Map<String, dynamic>? hoverBackground;
  final Map<String, dynamic>? padding;
  final Map<String, dynamic>? margin;
  final double? maxWidth;
  final PagebuilderResponsiveOrConstantModel<String>? alignment;
  final String? customCSS;

  const PageBuilderWidgetModel(
      {required this.id,
      required this.elementType,
      required this.properties,
      required this.hoverProperties,
      required this.children,
      required this.containerChild,
      required this.widthPercentage,
      required this.background,
      required this.hoverBackground,
      required this.padding,
      required this.margin,
      required this.maxWidth,
      required this.alignment,
      required this.customCSS});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id};
    if (elementType != null) map['elementType'] = elementType;
    if (properties != null) map['properties'] = properties;
    if (hoverProperties != null) map['hoverProperties'] = hoverProperties;
    if (children != null) {
      map['children'] = children!.map((child) => child.toMap()).toList();
    }
    if (containerChild != null) map['containerChild'] = containerChild!.toMap();
    if (widthPercentage != null) {
      map['widthPercentage'] = widthPercentage!.toMapValue();
    }
    if (background != null) map['background'] = background;
    if (hoverBackground != null) map['hoverBackground'] = hoverBackground;
    if (padding != null) map['padding'] = padding;
    if (margin != null) map['margin'] = margin;
    if (maxWidth != null) map['maxWidth'] = maxWidth;
    if (alignment != null) {
      map['alignment'] = alignment!.toMapValue();
    }
    if (customCSS != null) map['customCSS'] = customCSS;
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
        hoverProperties: map['hoverProperties'] != null
            ? map['hoverProperties'] as Map<String, dynamic>
            : null,
        children: map['children'] != null
            ? List<PageBuilderWidgetModel>.from((map['children'] as List<dynamic>)
                .map((child) => PageBuilderWidgetModel.fromMap(
                    child as Map<String, dynamic>)))
            : null,
        containerChild: map['containerChild'] != null
            ? PageBuilderWidgetModel.fromMap(
                map['containerChild'] as Map<String, dynamic>)
            : null,
        widthPercentage: map['widthPercentage'] != null
            ? PagebuilderResponsiveOrConstantModel.fromMapValue(
                map['widthPercentage'], (v) => v as double)
            : null,
        background: map['background'] != null
            ? map['background'] as Map<String, dynamic>
            : null,
        hoverBackground: map['hoverBackground'] != null
            ? map['hoverBackground'] as Map<String, dynamic>
            : null,
        padding: map['padding'] != null ? map['padding'] as Map<String, dynamic> : null,
        margin: map['margin'] != null ? map['margin'] as Map<String, dynamic> : null,
        maxWidth: map['maxWidth'] != null ? map['maxWidth'] as double : null,
        alignment: map['alignment'] != null
            ? PagebuilderResponsiveOrConstantModel.fromMapValue(
                map['alignment'], (v) => v as String)
            : null,
        customCSS: map['customCSS'] != null ? map['customCSS'] as String : null);
  }

  PageBuilderWidgetModel copyWith(
      {String? id,
      String? elementType,
      Map<String, dynamic>? properties,
      Map<String, dynamic>? hoverProperties,
      List<PageBuilderWidgetModel>? children,
      PageBuilderWidgetModel? containerChild,
      PagebuilderResponsiveOrConstantModel<double>? widthPercentage,
      Map<String, dynamic>? background,
      Map<String, dynamic>? hoverBackground,
      Map<String, dynamic>? padding,
      Map<String, dynamic>? margin,
      double? maxWidth,
      PagebuilderResponsiveOrConstantModel<String>? alignment,
      String? customCSS}) {
    return PageBuilderWidgetModel(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        hoverProperties: hoverProperties ?? this.hoverProperties,
        children: children ?? this.children,
        containerChild: containerChild ?? this.containerChild,
        widthPercentage: widthPercentage ?? this.widthPercentage,
        background: background ?? this.background,
        hoverBackground: hoverBackground ?? this.hoverBackground,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        maxWidth: maxWidth ?? this.maxWidth,
        alignment: alignment ?? this.alignment,
        customCSS: customCSS ?? this.customCSS);
  }

  PageBuilderWidget toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderWidget(
        id: UniqueID.fromUniqueString(id),
        elementType: elementType == null
            ? PageBuilderWidgetType.none
            : PageBuilderWidgetType.values
                .firstWhere((element) => element.name == elementType),
        properties: getPropertiesByType(elementType, properties, globalStyles),
        hoverProperties: getPropertiesByType(elementType, hoverProperties, globalStyles),
        children: children?.map((child) => child.toDomain(globalStyles)).toList(),
        containerChild: containerChild?.toDomain(globalStyles),
        widthPercentage: widthPercentage?.toDomain(),
        background: background != null
            ? PagebuilderBackgroundModel.fromMap(background!).toDomain(globalStyles)
            : null,
        hoverBackground: hoverBackground != null
            ? PagebuilderBackgroundModel.fromMap(hoverBackground!).toDomain(globalStyles)
            : null,
        padding: PageBuilderSpacingModel.fromMap(padding).toDomain(),
        margin: PageBuilderSpacingModel.fromMap(margin).toDomain(),
        maxWidth: maxWidth,
        alignment: _convertAlignmentToDomain(alignment),
        customCSS: customCSS);
  }

  factory PageBuilderWidgetModel.fromDomain(PageBuilderWidget widget) {
    return PageBuilderWidgetModel(
        id: widget.id.value,
        elementType: widget.elementType?.name,
        properties: getMapFromProperties(widget.properties),
        hoverProperties: getMapFromProperties(widget.hoverProperties),
        children: widget.children
            ?.map((child) => PageBuilderWidgetModel.fromDomain(child))
            .toList(),
        containerChild: widget.containerChild != null
            ? PageBuilderWidgetModel.fromDomain(widget.containerChild!)
            : null,
        widthPercentage: widget.widthPercentage != null
            ? PagebuilderResponsiveOrConstantModel.fromDomain(
                widget.widthPercentage!)
            : null,
        background: widget.background != null
            ? PagebuilderBackgroundModel.fromDomain(widget.background!).toMap()
            : null,
        hoverBackground: widget.hoverBackground != null
            ? PagebuilderBackgroundModel.fromDomain(widget.hoverBackground!)
                .toMap()
            : null,
        padding: PageBuilderSpacingModel.fromDomain(widget.padding).toMap(),
        margin: PageBuilderSpacingModel.fromDomain(widget.margin).toMap(),
        maxWidth: widget.maxWidth,
        alignment: _convertAlignmentFromDomain(widget.alignment),
        customCSS: widget.customCSS);
  }

  PageBuilderProperties? getPropertiesByType(
      String? type, Map<String, dynamic>? properties, PageBuilderGlobalStyles? globalStyles) {
    if (properties == null) {
      return null;
    }
    final widgetType = type == null
        ? PageBuilderWidgetType.none
        : PageBuilderWidgetType.values
            .firstWhere((element) => element.name == type);
    switch (widgetType) {
      case PageBuilderWidgetType.text:
        return PageBuilderTextPropertiesModel.fromMap(properties).toDomain(globalStyles);
      case PageBuilderWidgetType.image:
        return PageBuilderImagePropertiesModel.fromMap(properties).toDomain(globalStyles);
      case PageBuilderWidgetType.icon:
        return PageBuilderIconPropertiesModel.fromMap(properties).toDomain(globalStyles);
      case PageBuilderWidgetType.container:
        return PageBuilderContainerPropertiesModel.fromMap(properties)
            .toDomain(globalStyles);
      case PageBuilderWidgetType.row:
        return PagebuilderRowPropertiesModel.fromMap(properties).toDomain();
      case PageBuilderWidgetType.column:
        return PagebuilderColumnPropertiesModel.fromMap(properties).toDomain();
      case PageBuilderWidgetType.contactForm:
        return PageBuilderContactFormPropertiesModel.fromMap(properties)
            .toDomain(globalStyles);
      case PageBuilderWidgetType.footer:
        return PagebuilderFooterPropertiesModel.fromMap(properties).toDomain(globalStyles);
      case PageBuilderWidgetType.videoPlayer:
        return PagebuilderVideoPlayerPropertiesModel.fromMap(properties)
            .toDomain();
      case PageBuilderWidgetType.anchorButton:
        return PagebuilderAnchorButtonPropertiesModel.fromMap(properties)
            .toDomain(globalStyles);
      case PageBuilderWidgetType.calendly:
        return PagebuilderCalendlyPropertiesModel.fromMap(properties)
            .toDomain();
      case PageBuilderWidgetType.height:
        return PageBuilderHeightPropertiesModel.fromMap(properties).toDomain();
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
    } else if (properties is PagebuilderAnchorButtonProperties) {
      return PagebuilderAnchorButtonPropertiesModel.fromDomain(properties)
          .toMap();
    } else if (properties is PagebuilderCalendlyProperties) {
      return PagebuilderCalendlyPropertiesModel.fromDomain(properties).toMap();
    } else if (properties is PageBuilderHeightProperties) {
      return PageBuilderHeightPropertiesModel.fromDomain(properties).toMap();
    } else {
      return null;
    }
  }

  static PagebuilderResponsiveOrConstant<Alignment>? _convertAlignmentToDomain(
      PagebuilderResponsiveOrConstantModel<String>? alignmentModel) {
    if (alignmentModel == null) return null;

    final domain = alignmentModel.toDomain();
    if (domain.constantValue != null) {
      return PagebuilderResponsiveOrConstant.constant(
          AlignmentMapper.getAlignmentFromString(domain.constantValue!)!);
    }

    if (domain.responsiveValue != null) {
      final convertedMap = <String, Alignment>{};
      domain.responsiveValue!.forEach((key, value) {
        convertedMap[key] = AlignmentMapper.getAlignmentFromString(value)!;
      });
      return PagebuilderResponsiveOrConstant.responsive(convertedMap);
    }

    return null;
  }

  static PagebuilderResponsiveOrConstantModel<String>? _convertAlignmentFromDomain(
      PagebuilderResponsiveOrConstant<Alignment>? alignment) {
    if (alignment == null) return null;

    if (alignment.constantValue != null) {
      return PagebuilderResponsiveOrConstantModel.constant(
          AlignmentMapper.getStringFromAlignment(alignment.constantValue!)!);
    }

    if (alignment.responsiveValue != null) {
      final convertedMap = <String, String>{};
      alignment.responsiveValue!.forEach((key, value) {
        convertedMap[key] = AlignmentMapper.getStringFromAlignment(value)!;
      });
      return PagebuilderResponsiveOrConstantModel.responsive(convertedMap);
    }

    return null;
  }

  @override
  List<Object?> get props => [
        id,
        elementType,
        properties,
        hoverProperties,
        children,
        containerChild,
        widthPercentage,
        background,
        hoverBackground,
        padding,
        margin,
        maxWidth,
        alignment,
        customCSS
      ];
}
