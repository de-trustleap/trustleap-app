import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_hierarchy/hierarchy_widgets_list.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
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
  final Set<String> _expandedSections = {};
  final Set<String> _expandedWidgets = {};
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

    return BlocBuilder<PagebuilderSelectionCubit, String?>(
      bloc: selectionCubit,
      builder: (context, selectedWidgetId) {
        // Auto-expand tree when selection changes
        if (selectedWidgetId != null &&
            selectedWidgetId != _lastSelectedWidgetId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _autoExpandForWidget(selectedWidgetId);
          });
          _lastSelectedWidgetId = selectedWidgetId;
        }

        return ListView(
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
                return _buildSectionItem(section, selectedWidgetId, index + 1,
                    themeData, localization);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionItem(PageBuilderSection section, String? selectedWidgetId,
      int sectionNumber, ThemeData themeData, AppLocalizations localization) {
    final isExpanded = _expandedSections.contains(section.id.value);
    final isSelected = selectedWidgetId == section.id.value;
    final widgets = section.widgets ?? [];

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
                        setState(() {
                          if (isExpanded) {
                            _expandedSections.remove(section.id.value);
                          } else {
                            _expandedSections.add(section.id.value);
                          }
                        });
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
              selectedWidgetId: selectedWidgetId,
              onItemSelected: widget.onItemSelected,
              onWidgetReorder: widget.onWidgetReorder,
              expandedWidgets: _expandedWidgets,
              onToggleExpand: (widgetId) {
                setState(() {
                  if (_expandedWidgets.contains(widgetId)) {
                    _expandedWidgets.remove(widgetId);
                  } else {
                    _expandedWidgets.add(widgetId);
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  void _autoExpandForWidget(String widgetId) {
    if (_hierarchyHelper == null) return;

    final expansionState = _hierarchyHelper!.getOptimalExpansionState(widgetId);
    final sectionsToExpand = expansionState['sectionsToExpand'] ?? <String>[];
    final widgetsToExpand = expansionState['widgetsToExpand'] ?? <String>[];
    final sectionsToCollapse =
        expansionState['sectionsToCollapse'] ?? <String>[];
    final widgetsToCollapse = expansionState['widgetsToCollapse'] ?? <String>[];

    setState(() {
      for (final sectionId in sectionsToCollapse) {
        _expandedSections.remove(sectionId);
      }

      for (final widgetId in widgetsToCollapse) {
        _expandedWidgets.remove(widgetId);
      }

      for (final sectionId in sectionsToExpand) {
        _expandedSections.add(sectionId);
      }

      for (final widgetId in widgetsToExpand) {
        _expandedWidgets.add(widgetId);
      }
    });
  }
}
