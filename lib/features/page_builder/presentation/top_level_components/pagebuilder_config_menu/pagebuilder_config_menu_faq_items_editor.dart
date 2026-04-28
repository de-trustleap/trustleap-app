import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_item.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuFaqItemsEditor extends StatelessWidget {
  final PageBuilderWidget model;
  final PagebuilderBloc bloc;
  final AppLocalizations localization;

  const PagebuilderConfigMenuFaqItemsEditor({
    super.key,
    required this.model,
    required this.bloc,
    required this.localization,
  });

  PageBuilderFaqProperties get _props =>
      model.properties as PageBuilderFaqProperties;

  void _update(PageBuilderFaqProperties updated) {
    bloc.add(UpdateWidgetEvent(model.copyWith(properties: updated)));
  }

  @override
  Widget build(BuildContext context) {
    final items = _props.items ?? [];

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          CollapsibleTile(
            title:
                '${localization.pagebuilder_faq_config_item_question_label} ${i + 1}',
            children: [
              PagebuilderTextField(
                initialText: items[i].question,
                placeholder:
                    localization.pagebuilder_faq_config_item_question_label,
                onChanged: (text) {
                  final updated = List<PagebuilderFAQItem>.from(items);
                  updated[i] = items[i].copyWith(question: text);
                  _update(_props.copyWith(items: updated));
                },
              ),
              const SizedBox(height: 8),
              PagebuilderTextField(
                initialText: items[i].answer,
                placeholder:
                    localization.pagebuilder_faq_config_item_answer_label,
                minLines: 3,
                maxLines: 8,
                onChanged: (text) {
                  final updated = List<PagebuilderFAQItem>.from(items);
                  updated[i] = items[i].copyWith(answer: text);
                  _update(_props.copyWith(items: updated));
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Tooltip(
                  message: localization.pagebuilder_faq_config_delete_item,
                  child: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      final updated = List<PagebuilderFAQItem>.from(items)
                        ..removeAt(i);
                      _update(_props.copyWith(items: updated));
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        SubtleButton(
          title: localization.pagebuilder_faq_config_add_item,
          icon: Icons.add,
          onTap: () {
            final updated = List<PagebuilderFAQItem>.from(items)
              ..add(const PagebuilderFAQItem(question: null, answer: null));
            _update(_props.copyWith(items: updated));
          },
        ),
      ],
    );
  }
}
