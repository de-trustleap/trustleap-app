import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';

class PagebuilderWidgetTemplate {
  final String name;
  final IconData icon;
  final PageBuilderWidgetType widgetType;

  const PagebuilderWidgetTemplate({
    required this.name,
    required this.icon,
    required this.widgetType,
  });
}

class PagebuilderWidgetTemplates {
  static const List<PagebuilderWidgetTemplate> templates = [
    PagebuilderWidgetTemplate(
      name: 'Text',
      icon: Icons.text_fields,
      widgetType: PageBuilderWidgetType.text,
    ),
    PagebuilderWidgetTemplate(
      name: 'Button',
      icon: Icons.smart_button,
      widgetType: PageBuilderWidgetType.button,
    ),
    PagebuilderWidgetTemplate(
      name: 'Bild',
      icon: Icons.image,
      widgetType: PageBuilderWidgetType.image,
    ),
    PagebuilderWidgetTemplate(
      name: 'Container',
      icon: Icons.crop_square,
      widgetType: PageBuilderWidgetType.container,
    ),
    PagebuilderWidgetTemplate(
      name: 'Icon',
      icon: Icons.star,
      widgetType: PageBuilderWidgetType.icon,
    ),
    PagebuilderWidgetTemplate(
      name: 'Video',
      icon: Icons.play_circle,
      widgetType: PageBuilderWidgetType.videoPlayer,
    ),
    PagebuilderWidgetTemplate(
      name: 'Kontaktformular',
      icon: Icons.contact_mail,
      widgetType: PageBuilderWidgetType.contactForm,
    ),
    PagebuilderWidgetTemplate(
      name: 'Anchor Button',
      icon: Icons.anchor,
      widgetType: PageBuilderWidgetType.anchorButton,
    ),
    PagebuilderWidgetTemplate(
      name: 'Calendly',
      icon: Icons.calendar_month,
      widgetType: PageBuilderWidgetType.calendly,
    ),
  ];
}
