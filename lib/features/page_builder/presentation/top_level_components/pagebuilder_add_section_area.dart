import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/pagebuilder_overlay.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_add_section_button.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_section_template_library_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderAddSectionArea extends StatelessWidget {
  const PagebuilderAddSectionArea({super.key});

  void _showSectionTemplateMenu(BuildContext context) {
    PagebuilderOverlay.show(
      context: context,
      content: _SectionTemplateGrid(
        onColumnCountSelected: (count) {
          Navigator.pop(context);
          Modular.get<PagebuilderBloc>().add(AddSectionEvent(count));
        },
      ),
      positionRelativeToWidget: true,
    );
  }

  void _showTemplateLibrary(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Dialog(
        child: PagebuilderSectionTemplateLibraryDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: themeData.colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (buttonContext) {
                return PagebuilderAddSectionButton(
                  tooltip: localization.pagebuilder_add_section_create_empty_tooltip,
                  icon: Icons.add,
                  iconSize: 32,
                  color: themeData.colorScheme.secondary,
                  onTap: () => _showSectionTemplateMenu(buttonContext),
                );
              },
            ),
            const SizedBox(width: 16),
            PagebuilderAddSectionButton(
              tooltip: localization.pagebuilder_add_section_create_from_template_tooltip,
              icon: Icons.dashboard,
              iconSize: 28,
              color: themeData.colorScheme.secondary,
              onTap: () => _showTemplateLibrary(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTemplateGrid extends StatelessWidget {
  final void Function(int columnCount) onColumnCountSelected;

  const _SectionTemplateGrid({
    required this.onColumnCountSelected,
  });

  Widget _buildColumnIcon(int columnCount, Color color) {
    const double maxWidth = 42.0;
    final double containerWidth =
        (maxWidth - (columnCount - 1) * 2) / columnCount;

    return SizedBox(
      width: maxWidth,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          columnCount,
          (index) => Container(
            width: containerWidth,
            height: 30,
            margin: EdgeInsets.only(left: index > 0 ? 2 : 0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.pagebuilder_add_section_choose_layout_heading,
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final columnCount = index + 1;
              return Padding(
                padding: EdgeInsets.only(left: index > 0 ? 8 : 0),
                child: InkWell(
                  onTap: () => onColumnCountSelected(columnCount),
                  borderRadius: BorderRadius.circular(16),
                  child: CardContainer(
                    maxWidth: 60,
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: _buildColumnIcon(
                        columnCount,
                        themeData.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
