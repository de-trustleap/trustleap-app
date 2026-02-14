import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_hierarchy_expansion/pagebuilder_hierarchy_expansion_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_drag_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/hierarchy_widgets_list.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderHierarchyTreeView extends StatefulWidget {
  final PageBuilderPage page;
  final Function(String widgetId, bool isSection) onItemSelected;
  final Function(int oldIndex, int newIndex)? onSectionReorder;
  final Function(String parentId, int oldIndex, int newIndex)? onWidgetReorder;

  const LandingPageBuilderHierarchyTreeView({
    super.key,
    required this.page,
    required this.onItemSelected,
    this.onSectionReorder,
    this.onWidgetReorder,
  });

  @override
  State<LandingPageBuilderHierarchyTreeView> createState() =>
      _LandingPageBuilderHierarchyTreeViewState();
}

class _LandingPageBuilderHierarchyTreeViewState
    extends State<LandingPageBuilderHierarchyTreeView> {
  String? _lastSelectedWidgetId;
  LandingPageBuilderHierarchyHelper? _hierarchyHelper;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final selectionCubit = Modular.get<PagebuilderSelectionCubit>();
    final sections = widget.page.sections ?? [];

    if (sections.isEmpty) {
      return Center(
        child: Text(
          localization.pagebuilder_hierarchy_overlay_no_elements,
          style: themeData.textTheme.bodyMedium,
        ),
      );
    }

    _hierarchyHelper ??= LandingPageBuilderHierarchyHelper(
      page: widget.page,
    );

    return BlocListener<PagebuilderSelectionCubit, String?>(
      bloc: selectionCubit,
      listener: (context, selectedWidgetId) {
        // Auto-expand tree when selection changes
        if (selectedWidgetId != null &&
            selectedWidgetId != _lastSelectedWidgetId) {
          _autoExpandForWidget(selectedWidgetId);
          _lastSelectedWidgetId = selectedWidgetId;
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          PagebuilderReorderableElement<PageBuilderSection>(
            key: const ValueKey('hierarchy-overlay-sections'),
            containerId: 'hierarchy-overlay-sections',
            items: sections,
            getItemId: (section) => section.id.value,
            isSection: (section) => true,
            onReorder: (oldIndex, newIndex) {
              widget.onSectionReorder?.call(oldIndex, newIndex);
            },
            buildChild: (section, index) {
              return _buildSectionItemWithSelector(section, index + 1,
                  themeData, localization, selectionCubit);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItemWithSelector(PageBuilderSection section,
      int sectionNumber, ThemeData themeData, AppLocalizations localization,
      PagebuilderSelectionCubit selectionCubit) {
    return BlocSelector<PagebuilderSelectionCubit, String?, bool>(
      bloc: selectionCubit,
      selector: (selectedWidgetId) => selectedWidgetId == section.id.value,
      builder: (context, isSelected) {
        return _buildSectionItem(section, isSelected, sectionNumber, themeData, localization);
      },
    );
  }

  Widget _buildSectionItem(PageBuilderSection section, bool isSelected,
      int sectionNumber, ThemeData themeData, AppLocalizations localization) {
    final widgets = section.widgets ?? [];
    final expansionCubit = Modular.get<PagebuilderHierarchyExpansionCubit>();

    return BlocSelector<PagebuilderHierarchyExpansionCubit, PagebuilderHierarchyExpansionState, bool>(
      bloc: expansionCubit,
      selector: (state) => state.expandedSections.contains(section.id.value),
      builder: (context, isExpanded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: isSelected
                    ? themeData.colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    widget.onItemSelected(section.id.value, true);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            expansionCubit.toggleSection(section.id.value);
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            child: Icon(
                              isExpanded ? Icons.expand_more : Icons.chevron_right,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : themeData.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.view_agenda,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : themeData.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            section.name ??
                                "${localization.pagebuilder_hierarchy_overlay_section_element} $sectionNumber",
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PagebuilderDragControl<PageBuilderSection>(
                          icon: Icons.drag_indicator,
                          color: isSelected
                              ? Colors.white
                              : themeData.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: HierarchyWidgetsList(
                  sectionId: section.id.value,
                  widgets: widgets,
                  onItemSelected: widget.onItemSelected,
                  onWidgetReorder: widget.onWidgetReorder,
                ),
              ),
          ],
        );
      },
    );
  }

  void _autoExpandForWidget(String widgetId) {
    if (_hierarchyHelper == null) return;

    final expansionState = _hierarchyHelper!.getOptimalExpansionState(widgetId);
    final sectionsToExpand = (expansionState['sectionsToExpand'] ?? <String>[]).toSet();
    final widgetsToExpand = (expansionState['widgetsToExpand'] ?? <String>[]).toSet();
    final sectionsToCollapse = (expansionState['sectionsToCollapse'] ?? <String>[]).toSet();
    final widgetsToCollapse = (expansionState['widgetsToCollapse'] ?? <String>[]).toSet();

    final expansionCubit = Modular.get<PagebuilderHierarchyExpansionCubit>();
    expansionCubit.setExpansionState(
      sectionsToExpand: sectionsToExpand,
      widgetsToExpand: widgetsToExpand,
      sectionsToCollapse: sectionsToCollapse,
      widgetsToCollapse: widgetsToCollapse,
    );
  }
}
