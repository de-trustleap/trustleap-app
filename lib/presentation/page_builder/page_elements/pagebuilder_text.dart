import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PagebuilderText extends StatelessWidget {
  final PageBuilderTextProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;

  const PagebuilderText({
    super.key,
    required this.properties,
    required this.widgetModel,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final htmlContent = properties.text ?? "";
    final baseStyle = TextStyleParser().getTextStyleFromProperties(properties);

    final commonTextStyle = Style(
      fontFamily: baseStyle.fontFamily,
      fontFamilyFallback: baseStyle.fontFamilyFallback,
      fontSize:
          baseStyle.fontSize != null ? FontSize(baseStyle.fontSize!) : null,
      color: baseStyle.color,
      lineHeight:
          baseStyle.height != null ? LineHeight(baseStyle.height!) : null,
      letterSpacing: baseStyle.letterSpacing,
    );

    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      index: index,
      child: Html(
        data: htmlContent,
        style: {
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontFamily: baseStyle.fontFamily,
            fontFamilyFallback: baseStyle.fontFamilyFallback,
            fontSize: baseStyle.fontSize != null
                ? FontSize(baseStyle.fontSize!)
                : null,
            color: baseStyle.color,
            lineHeight:
                baseStyle.height != null ? LineHeight(baseStyle.height!) : null,
            letterSpacing: baseStyle.letterSpacing,
            textAlign: properties.alignment?.getValue(),
          ),
          "p": commonTextStyle.merge(Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          )),
          "div": commonTextStyle,
          "span": commonTextStyle,
          "b": commonTextStyle.merge(Style(
            fontWeight: FontWeight.bold,
          )),
          "strong": commonTextStyle.merge(Style(
            fontWeight: FontWeight.bold,
          )),
          "i": commonTextStyle.merge(Style(
            fontStyle: FontStyle.italic,
          )),
          "em": commonTextStyle.merge(Style(
            fontStyle: FontStyle.italic,
          )),
          "u": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.underline,
            textDecorationColor: baseStyle.color,
          )),
          "s": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: baseStyle.color,
          )),
          "strike": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: baseStyle.color,
          )),
          "del": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: baseStyle.color,
          )),
          "sup": commonTextStyle.merge(Style(
            verticalAlign: VerticalAlign.sup,
          )),
          "sub": commonTextStyle.merge(Style(
            verticalAlign: VerticalAlign.sub,
          )),
          "ul": commonTextStyle.merge(Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          )),
          "ol": commonTextStyle.merge(Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          )),
          "li": commonTextStyle.merge(Style(
            margin: Margins.zero,
          )),
        },
      ),
    );
  }
}

// TODO: STRIKETHROUGH LINE IST SCHWARZ STATT FONT COLOR (DONE)
// TODO: UNDERLINE LINE IST SCHWARZ STATT FONT COLOR (DONE)
// TODO: FARBE ANPASSBAR MACHEN (DONE)
// TODO: COLOR PICKER SOLL SWITCH NICHT ANZEIGEN WENN ES NUR EINEN TAB GIBT (DONE)
// TODO: COLOR PICKER SOLL JE NACHDEM WELCHEN TEXT MAN AUSWÄHLT DIE AKTUELLE FARBE WIDERSPIEGELN
// TODO: TEMPLATES MIT HTML TAGS ANPASSEN
// TODO: PAGEBUILDER PROJECT ANPASSEN. ALSO ISBOLD UND ISITALIC LÖSCHEN
// TODO: SCHAUEN OB SPEICHERN FUNKTIONIERT
