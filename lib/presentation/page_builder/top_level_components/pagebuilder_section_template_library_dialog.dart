import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_section_template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderSectionTemplateLibraryDialog extends StatefulWidget {
  const PagebuilderSectionTemplateLibraryDialog({super.key});

  @override
  State<PagebuilderSectionTemplateLibraryDialog> createState() =>
      _PagebuilderSectionTemplateLibraryDialogState();
}

class _PagebuilderSectionTemplateLibraryDialogState
    extends State<PagebuilderSectionTemplateLibraryDialog> {
  SectionType _selectedType = SectionType.hero;
  final PagebuilderSectionTemplateCubit _cubit =
      Modular.get<PagebuilderSectionTemplateCubit>();

  @override
  void initState() {
    super.initState();
    // Load all template metas when dialog opens
    _cubit.getAllTemplateMetas();
  }

  List<PagebuilderSectionTemplateMeta> _filterMetasByType(
      List<PagebuilderSectionTemplateMeta> metas) {
    return metas.where((meta) => meta.type == _selectedType).toList();
  }

  String _getSectionTypeLabel(SectionType type, AppLocalizations localization) {
    switch (type) {
      case SectionType.hero:
        return 'Hero';
      case SectionType.about:
        return 'Über';
      case SectionType.product:
        return 'Produkt';
      case SectionType.callToAction:
        return 'Call to Action';
      case SectionType.advantages:
        return 'Vorteile';
      case SectionType.footer:
        return 'Fußzeile';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Vorlagen Auswahl',
                style: themeData.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SectionType.values.map((type) {
              final isSelected = _selectedType == type;
              return ChoiceChip(
                label: Text(_getSectionTypeLabel(type, localization)),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  }
                },
                selectedColor: themeData.colorScheme.secondary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Template Grid
          Expanded(
            child: BlocBuilder<PagebuilderSectionTemplateCubit,
                PagebuilderSectionTemplateState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state is PagebuilderSectionTemplateFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: themeData.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Fehler beim Laden der Templates',
                          style: themeData.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                } else if (state is PagebuilderSectionTemplateMetasLoadSuccess) {
                  final filteredMetas = _filterMetasByType(state.metas);

                  if (filteredMetas.isEmpty) {
                    return Center(
                      child: Text(
                        'Keine Templates für ${_getSectionTypeLabel(_selectedType, localization)} verfügbar',
                        style: themeData.textTheme.bodyLarge?.copyWith(
                          color: themeData.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 16 / 10,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredMetas.length,
                    itemBuilder: (context, index) {
                      final meta = filteredMetas[index];
                      return PagebuilderSectionTemplateCard(
                        meta: meta,
                        onSelected: () {
                          // TODO: Load full template and add to page
                          // _cubit.getTemplateById(meta.id);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                }

                // Loading state (initial and loading)
                return Center(
                  child: CircularProgressIndicator(
                    color: themeData.colorScheme.secondary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
