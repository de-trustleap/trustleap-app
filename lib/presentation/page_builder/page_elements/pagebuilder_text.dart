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
      color: null,
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
            color: Colors.black,
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
            color: null,
          )),
          "strong": commonTextStyle.merge(Style(
            fontWeight: FontWeight.bold,
            color: null,
          )),
          "i": commonTextStyle.merge(Style(
            fontStyle: FontStyle.italic,
            color: null,
          )),
          "em": commonTextStyle.merge(Style(
            fontStyle: FontStyle.italic,
            color: null,
          )),
          "u": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.underline,
            textDecorationColor: null,
          )),
          "s": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: null,
          )),
          "strike": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: null,
          )),
          "del": commonTextStyle.merge(Style(
            textDecoration: TextDecoration.lineThrough,
            textDecorationColor: null,
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
