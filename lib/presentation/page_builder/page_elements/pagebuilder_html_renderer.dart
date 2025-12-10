import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_global_styles_resolver.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderHtmlRenderer extends StatelessWidget {
  final PageBuilderTextProperties? textProperties;
  final bool useInlineDisplay;

  const PagebuilderHtmlRenderer({
    super.key,
    required this.textProperties,
    this.useInlineDisplay = false,
  });

  String _preprocessHtmlTextDecoration(String html) {
    // Add text-decoration-color to span tags that have a color
    // This ensures underline/strikethrough match the text color
    // Matches both "color: #RRGGBB" and "color: (#RRGGBB)"
    final colorRegex = RegExp(r'<span style="color: \(?#([0-9A-Fa-f]{6})\)?');
    return html.replaceAllMapped(colorRegex, (match) {
      final color = match.group(1);
      return '<span style="color: #$color; text-decoration-color: #$color';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get global styles from BLoC
    final blocState = Modular.get<PagebuilderBloc>().state;
    final globalStyles = blocState is GetLandingPageAndUserSuccessState
        ? blocState.content.content?.globalStyles
        : null;

    // Create resolver and resolve all tokens in HTML
    final resolver = PagebuilderGlobalStylesResolver(globalStyles);
    String htmlContent = _preprocessHtmlTextDecoration(textProperties?.text ?? "");
    htmlContent = resolver.resolveHtmlTokens(htmlContent);

    final baseStyle = TextStyleParser().getTextStyleFromProperties(textProperties);
    final textAlignValue = textProperties?.alignment?.getValue();

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

    return Align(
      alignment: AlignmentMapper.getAlignmentFromTextAlignment(textAlignValue),
      child: Html(
        data: htmlContent,
        shrinkWrap: true,
        style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontFamily: baseStyle.fontFamily,
          fontFamilyFallback: baseStyle.fontFamilyFallback,
          fontSize: baseStyle.fontSize != null
              ? FontSize(baseStyle.fontSize!)
              : null,
          color: baseStyle.color ?? Colors.black,
          lineHeight:
              baseStyle.height != null ? LineHeight(baseStyle.height!) : null,
          letterSpacing: baseStyle.letterSpacing,
          textAlign: textProperties?.alignment?.getValue(),
          display: useInlineDisplay ? Display.inline : null,
        ),
        "p": commonTextStyle.merge(Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          textAlign: textProperties?.alignment?.getValue(),
        )),
        "div": commonTextStyle.merge(Style(
          textAlign: textProperties?.alignment?.getValue(),
        )),
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
          padding: HtmlPaddings.only(
            left: baseStyle.fontSize ?? 16,
          ),
        )),
        "ol": commonTextStyle.merge(Style(
          margin: Margins.zero,
          padding: HtmlPaddings.only(
            left: baseStyle.fontSize ?? 16,
          ),
        )),
        "li": commonTextStyle.merge(Style(
          margin: Margins.zero,
        )),
      },
      ),
    );
  }
}
