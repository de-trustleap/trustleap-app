// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

abstract class PageBuilderProperties {}

class PageBuilderWidget extends Equatable {
  final UniqueID id;
  final PageBuilderWidgetType? elementType;
  final PageBuilderProperties? properties;
  final PageBuilderProperties? hoverProperties;
  final List<PageBuilderWidget>? children;
  final PageBuilderWidget? containerChild;
  final PagebuilderResponsiveOrConstant<double>? widthPercentage;
  final PagebuilderBackground? background;
  final PagebuilderBackground? hoverBackground;
  final PageBuilderSpacing? padding;
  final PageBuilderSpacing? margin;
  final double? maxWidth;
  final PagebuilderResponsiveOrConstant<Alignment>? alignment;
  final String? customCSS;

  const PageBuilderWidget(
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

  PageBuilderWidget copyWith(
      {UniqueID? id,
      PageBuilderWidgetType? elementType,
      PageBuilderProperties? properties,
      PageBuilderProperties? hoverProperties,
      List<PageBuilderWidget>? children,
      PageBuilderWidget? containerChild,
      PagebuilderResponsiveOrConstant<double>? widthPercentage,
      PagebuilderBackground? background,
      PagebuilderBackground? hoverBackground,
      PageBuilderSpacing? padding,
      PageBuilderSpacing? margin,
      double? maxWidth,
      PagebuilderResponsiveOrConstant<Alignment>? alignment,
      String? customCSS,
      bool removeHoverProperties = false,
      bool removeHoverBackground = false}) {
    return PageBuilderWidget(
        id: id ?? this.id,
        elementType: elementType ?? this.elementType,
        properties: properties ?? this.properties,
        hoverProperties: removeHoverProperties
            ? null
            : (hoverProperties ?? this.hoverProperties),
        children: children ?? this.children,
        containerChild: containerChild ?? this.containerChild,
        widthPercentage: widthPercentage ?? this.widthPercentage,
        background: background ?? this.background,
        hoverBackground: removeHoverProperties
            ? null
            : (hoverBackground ?? this.hoverBackground),
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        maxWidth: maxWidth ?? this.maxWidth,
        alignment: alignment ?? this.alignment,
        customCSS: customCSS ?? this.customCSS);
  }

  String getWidgetTitle(AppLocalizations localization) {
    switch (elementType) {
      case == PageBuilderWidgetType.container:
        return localization.landingpage_pagebuilder_config_menu_container_type;
      case == PageBuilderWidgetType.column:
        return localization.landingpage_pagebuilder_config_menu_column_type;
      case == PageBuilderWidgetType.row:
        return localization.landingpage_pagebuilder_config_menu_row_type;
      case == PageBuilderWidgetType.text:
        return localization.landingpage_pagebuilder_config_menu_text_type;
      case == PageBuilderWidgetType.image:
        return localization.landingpage_pagebuilder_config_menu_image_type;
      case == PageBuilderWidgetType.icon:
        return localization.landingpage_pagebuilder_config_menu_icon_type;
      case == PageBuilderWidgetType.button:
        return localization.landingpage_pagebuilder_config_menu_button_type;
      case == PageBuilderWidgetType.contactForm:
        return localization
            .landingpage_pagebuilder_config_menu_contact_form_type;
      case == PageBuilderWidgetType.footer:
        return localization.landingpage_pagebuilder_config_menu_footer_type;
      case == PageBuilderWidgetType.videoPlayer:
        return localization
            .landingpage_pagebuilder_config_menu_video_player_type;
      case == PageBuilderWidgetType.anchorButton:
        return localization
            .landingpage_pagebuilder_config_menu_anchor_button_type;
      case == PageBuilderWidgetType.calendly:
        return localization.landingpage_pagebuilder_config_menu_calendly_type;
      default:
        return localization.landingpage_pagebuilder_config_menu_unknown_type;
    }
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
