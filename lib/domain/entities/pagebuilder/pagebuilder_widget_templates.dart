import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PagebuilderWidgetTemplate {
  final IconData icon;
  final PageBuilderWidgetType widgetType;

  const PagebuilderWidgetTemplate({
    required this.icon,
    required this.widgetType,
  });

  String getName(AppLocalizations localizations) {
    switch (widgetType) {
      case PageBuilderWidgetType.text:
        return localizations.pagebuilder_widget_template_text;
      case PageBuilderWidgetType.image:
        return localizations.pagebuilder_widget_template_image;
      case PageBuilderWidgetType.container:
        return localizations.pagebuilder_widget_template_container;
      case PageBuilderWidgetType.icon:
        return localizations.pagebuilder_widget_template_icon;
      case PageBuilderWidgetType.videoPlayer:
        return localizations.pagebuilder_widget_template_video;
      case PageBuilderWidgetType.contactForm:
        return localizations.pagebuilder_widget_template_contact_form;
      case PageBuilderWidgetType.anchorButton:
        return localizations.pagebuilder_widget_template_anchor_button;
      case PageBuilderWidgetType.calendly:
        return localizations.pagebuilder_widget_template_calendly;
      default:
        return localizations.landingpage_pagebuilder_config_menu_unknown_type;
    }
  }
}

class PagebuilderWidgetTemplates {
  static const List<PagebuilderWidgetTemplate> templates = [
    PagebuilderWidgetTemplate(
      icon: Icons.text_fields,
      widgetType: PageBuilderWidgetType.text,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.image,
      widgetType: PageBuilderWidgetType.image,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.crop_square,
      widgetType: PageBuilderWidgetType.container,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.star,
      widgetType: PageBuilderWidgetType.icon,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.play_circle,
      widgetType: PageBuilderWidgetType.videoPlayer,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.contact_mail,
      widgetType: PageBuilderWidgetType.contactForm,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.anchor,
      widgetType: PageBuilderWidgetType.anchorButton,
    ),
    PagebuilderWidgetTemplate(
      icon: Icons.calendar_month,
      widgetType: PageBuilderWidgetType.calendly,
    ),
  ];
}
