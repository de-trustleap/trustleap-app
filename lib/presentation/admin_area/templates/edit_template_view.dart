import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/edit_template_card.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/edit_template_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditTemplateView extends StatefulWidget {
  const EditTemplateView({super.key});

  @override
  State<EditTemplateView> createState() => _EditTemplateViewState();
}

class _EditTemplateViewState extends State<EditTemplateView> {
  SectionType _selectedType = SectionType.hero;
  final PagebuilderSectionTemplateCubit _cubit =
      Modular.get<PagebuilderSectionTemplateCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getAllTemplateMetas();
  }

  List<PagebuilderSectionTemplateMeta> _filterMetasByType(
      List<PagebuilderSectionTemplateMeta> metas) {
    return metas.where((meta) => meta.type == _selectedType).toList();
  }

  String _getSectionTypeLabel(
      SectionType type, AppLocalizations localization) {
    switch (type) {
      case SectionType.hero:
        return localization.pagebuilder_section_type_hero;
      case SectionType.about:
        return localization.pagebuilder_section_type_about;
      case SectionType.product:
        return localization.pagebuilder_section_type_product;
      case SectionType.callToAction:
        return localization.pagebuilder_section_type_call_to_action;
      case SectionType.advantages:
        return localization.pagebuilder_section_type_advantages;
      case SectionType.footer:
        return localization.pagebuilder_section_type_footer;
      case SectionType.contact:
        return localization.pagebuilder_section_type_contact_form;
      case SectionType.calendly:
        return localization.pagebuilder_section_type_calendly;
    }
  }

  void _openEditDialog(PagebuilderSectionTemplateMeta meta) {
    showDialog(
      context: context,
      builder: (context) => EditTemplateDialog(meta: meta),
    ).then((_) {
      // Reload metas when dialog closes to restore grid state
      _cubit.getAllTemplateMetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocBuilder<PagebuilderSectionTemplateCubit,
        PagebuilderSectionTemplateState>(
      bloc: _cubit,
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: [
            CardContainer(
              maxWidth: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: themeData.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localization.admin_area_template_manager_tab_edit,
                        style: themeData.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                  SizedBox(
                    height: 500,
                    child: _buildTemplateGrid(
                        context, state, themeData, localization),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemplateGrid(
    BuildContext context,
    PagebuilderSectionTemplateState state,
    ThemeData themeData,
    AppLocalizations localization,
  ) {
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
              localization.pagebuilder_template_library_error_loading_templates,
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
            localization.admin_area_template_manager_edit_no_templates,
            style: themeData.textTheme.bodyLarge?.copyWith(
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 16 / 10,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredMetas.length,
        itemBuilder: (context, index) {
          final meta = filteredMetas[index];
          return EditTemplateCard(
            meta: meta,
            onSelected: () => _openEditDialog(meta),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: themeData.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              localization.admin_area_template_manager_edit_loading,
              style: themeData.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
  }
}
