// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

abstract class PageBuilderProperties {}

class PageBuilderWidget extends Equatable {
  final UniqueID id;
  final PageBuilderWidgetType? elementType;
  final PageBuilderProperties? properties;
  final List<PageBuilderWidget>? children;
  final PageBuilderWidget? containerChild;
  final double? widthPercentage;
  final PagebuilderBackground? background;
  final PageBuilderSpacing? padding;
  final PageBuilderSpacing? margin;
  final double? maxWidth;
  final Alignment? alignment;

  const PageBuilderWidget(
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

  PageBuilderWidget copyWith(
      {UniqueID? id,
      PageBuilderWidgetType? elementType,
      PageBuilderProperties? properties,
      List<PageBuilderWidget>? children,
      PageBuilderWidget? containerChild,
      double? widthPercentage,
      PagebuilderBackground? background,
      PageBuilderSpacing? padding,
      PageBuilderSpacing? margin,
      double? maxWidth,
      Alignment? alignment}) {
    return PageBuilderWidget(
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
      default:
        return localization.landingpage_pagebuilder_config_menu_unknown_type;
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
