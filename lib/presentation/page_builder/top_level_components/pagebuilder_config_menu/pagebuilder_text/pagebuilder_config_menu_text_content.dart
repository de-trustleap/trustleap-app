import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_html_text_editor.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_text_placeholder_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class PagebuilderConfigMenuTextContent extends StatefulWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuTextContent({super.key, required this.model});

  @override
  State<PagebuilderConfigMenuTextContent> createState() =>
      _PagebuilderConfigMenuTextContentState();
}

class _PagebuilderConfigMenuTextContentState
    extends State<PagebuilderConfigMenuTextContent> {
  final HtmlEditorController htmlController = HtmlEditorController();

  @override
  void dispose() {
    htmlController.disable();
    super.dispose();
  }

  void updateTextProperties(
      PageBuilderTextProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = widget.model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  void _insertTextAtCursor(String textToInsert) {
    htmlController.insertText(textToInsert);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    if (widget.model.elementType == PageBuilderWidgetType.text &&
        widget.model.properties is PageBuilderTextProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_text_config_content_title,
          children: [
            PagebuilderTextPlaceholderPicker(onSelected: (placeholder) async {
              _insertTextAtCursor(placeholder);
              // Wait a bit for the editor to update, then get the HTML content
              await Future.delayed(const Duration(milliseconds: 100));
              final currentHtml = await htmlController.getText();
              final updatedProperties =
                  (widget.model.properties as PageBuilderTextProperties)
                      .copyWith(text: currentHtml);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            }),
            const SizedBox(height: 16),
            PagebuilderHTMLTextEditor(
              controller: htmlController,
              initialHtml: (widget.model.properties as PageBuilderTextProperties).text,
              onChanged: (html) {
                final updatedProperties =
                    (widget.model.properties as PageBuilderTextProperties)
                        .copyWith(text: html);
                updateTextProperties(updatedProperties, pagebuilderCubit);
              },
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
