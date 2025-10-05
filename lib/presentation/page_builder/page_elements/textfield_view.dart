// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:flutter/material.dart';

class PageBuilderTextFieldView extends StatelessWidget {
  final PageBuilderTextFieldProperties properties;
  final PageBuilderWidget widgetModel;
  final TextStyleParser parser = TextStyleParser();

  PageBuilderTextFieldView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  double _calculateContainerMinHeight() {
    if (properties.minLines == null || properties.minLines == 1) {
      return 0;
    }
    return (properties.textProperties?.fontSize?.getValue() ?? 16) *
        (properties.textProperties?.lineHeight?.getValue() ?? 1) *
        (properties.minLines ?? 1) *
        2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: properties.width,
        constraints: BoxConstraints(
          minHeight: _calculateContainerMinHeight(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(color: properties.borderColor ?? Colors.black),
            borderRadius: BorderRadius.circular(4),
            color: properties.backgroundColor),
        child: Text(properties.placeHolderTextProperties?.text ?? "",
            style: parser.getTextStyleFromProperties(
                properties.placeHolderTextProperties),
            textAlign: properties.textProperties?.alignment?.getValue() ??
                TextAlign.start));
  }
}

// TODO: RESPONSIVE PADDING AND MARGIN (DONE)
// TODO: WIDTH UND HEIGHT FÜR VIDEO PLAYER (DONE)
// TODO: WIDTH UND HEIGHT FÜR BUTTON (DONE)
// TODO: onBreakpointChanged ÜBERALL DA LÖSCHEN WO ES NUR SETBREAKPOINT AUFRUFT. DAS IST NICHT NÖTIG UND KANN DIREKT IN DEN ELEMENTEN GEMACHT WERDEN (DONE)
// TODO: WIDTH UND HEIGHT FÜR CALENDLY (DONE)
// TODO: SIZE FÜR ICON
// TODO: WIDTH FÜR TEXTFIELD
// TODO: EDITIEREN FUNKTIONIERT NICHT MEHR WENN MAN CALENDLY ODER BOTH ANZEIGEN WILL
// TODO: RESPONSIVE HIDING
// TODO: RESPONSIVE ROWS AND COLUMNS
// TODO: LOCALIZATION
