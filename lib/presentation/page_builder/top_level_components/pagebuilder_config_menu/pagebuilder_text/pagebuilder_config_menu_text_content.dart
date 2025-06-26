import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_text_placeholder_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextContent extends StatefulWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuTextContent({super.key, required this.model});

  @override
  State<PagebuilderConfigMenuTextContent> createState() =>
      _PagebuilderConfigMenuTextContentState();
}

class _PagebuilderConfigMenuTextContentState
    extends State<PagebuilderConfigMenuTextContent> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void updateTextProperties(
      PageBuilderTextProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = widget.model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  void _insertTextAtCursor(String textToInsert) {
    int cursorIndex = controller.selection.baseOffset;

    if (cursorIndex == -1) {
      cursorIndex = 0;
      controller.selection = TextSelection.collapsed(offset: cursorIndex);
    }

    String newText = controller.text.replaceRange(
      cursorIndex,
      cursorIndex,
      textToInsert,
    );
    controller.text = newText;
    controller.selection =
        TextSelection.collapsed(offset: cursorIndex + textToInsert.length);
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
            PagebuilderTextPlaceholderPicker(onSelected: (placeholder) {
              _insertTextAtCursor(placeholder);
              final updatedProperties =
                  (widget.model.properties as PageBuilderTextProperties)
                      .copyWith(text: controller.text);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            }),
            const SizedBox(height: 16),
            PagebuilderTextField(
                controller: controller,
                initialText:
                    (widget.model.properties as PageBuilderTextProperties).text,
                minLines: 5,
                maxLines: 10,
                onChanged: (text) {
                  final updatedProperties =
                      (widget.model.properties as PageBuilderTextProperties)
                          .copyWith(text: text);
                  updateTextProperties(updatedProperties, pagebuilderCubit);
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
