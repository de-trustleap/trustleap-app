import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderHierarchyTreeView extends StatefulWidget {
  final PageBuilderPage page;
  final Function(String widgetId, bool isSection) onItemSelected;

  const LandingPageBuilderHierarchyTreeView({
    super.key,
    required this.page,
    required this.onItemSelected,
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

    return BlocBuilder<PagebuilderSelectionCubit, String?>(
      bloc: selectionCubit,
      builder: (context, selectedWidgetId) {
        _hierarchyHelper ??= LandingPageBuilderHierarchyHelper(
          page: widget.page,
        );

        // Auto-expand tree when selection changes
        if (selectedWidgetId != null &&
            selectedWidgetId != _lastSelectedWidgetId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _autoExpandForWidget(selectedWidgetId);
          });
          _lastSelectedWidgetId = selectedWidgetId;
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return _buildSectionItem(
                section, selectedWidgetId, index + 1, themeData, localization);
          },
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
                        "${localization.pagebuilder_hierarchy_overlay_section_element} $sectionNumber",
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${widgets.length}',
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : themeData.colorScheme.onSurfaceVariant,
                      ),
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
            child: Column(
              children: widgets
                  .map((widget) => _buildWidgetItem(
                      widget, selectedWidgetId, 0, themeData, localization))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildWidgetItem(PageBuilderWidget widget, String? selectedWidgetId,
      int depth, ThemeData themeData, AppLocalizations localization) {
    final widgetId = widget.id.value;
    final isExpanded = _expandedWidgets.contains(widgetId);
    final isSelected = selectedWidgetId == widgetId;
    final hasChildren =
        (widget.children != null && widget.children!.isNotEmpty) ||
            widget.containerChild != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: isSelected
                ? themeData.colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () {
                this.widget.onItemSelected(widgetId, false);
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: EdgeInsets.only(
                  left: depth * 16.0 + 8,
                  right: 8,
                  top: 4,
                  bottom: 4,
                ),
                child: Row(
                  children: [
                    if (hasChildren)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedWidgets.remove(widgetId);
                            } else {
                              _expandedWidgets.add(widgetId);
                            }
                          });
                        },
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          child: Icon(
                            isExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            size: 12,
                            color: isSelected
                                ? Colors.white
                                : themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 4),
                    Icon(
                      _getWidgetIcon(widget.elementType),
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : themeData.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getWidgetLabel(widget.elementType, localization),
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: isSelected ? Colors.white : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded && hasChildren)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  if (widget.children != null)
                    ...widget.children!.map((child) => _buildWidgetItem(child,
                        selectedWidgetId, depth + 1, themeData, localization)),
                  if (widget.containerChild != null)
                    _buildWidgetItem(widget.containerChild!, selectedWidgetId,
                        depth + 1, themeData, localization),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getWidgetIcon(PageBuilderWidgetType? elementType) {
    switch (elementType) {
      case PageBuilderWidgetType.text:
        return Icons.text_fields;
      case PageBuilderWidgetType.image:
        return Icons.image;
      case PageBuilderWidgetType.button:
        return Icons.smart_button;
      case PageBuilderWidgetType.anchorButton:
        return Icons.link;
      case PageBuilderWidgetType.container:
        return Icons.crop_square;
      case PageBuilderWidgetType.row:
        return Icons.view_column;
      case PageBuilderWidgetType.column:
        return Icons.view_agenda;
      case PageBuilderWidgetType.icon:
        return Icons.star;
      case PageBuilderWidgetType.contactForm:
        return Icons.contact_mail;
      case PageBuilderWidgetType.footer:
        return Icons.web_asset;
      case PageBuilderWidgetType.videoPlayer:
        return Icons.play_circle;
      default:
        return Icons.widgets;
    }
  }

  String _getWidgetLabel(
      PageBuilderWidgetType? elementType, AppLocalizations localization) {
    switch (elementType) {
      case PageBuilderWidgetType.text:
        return localization.pagebuilder_hierarchy_overlay_text;
      case PageBuilderWidgetType.image:
        return localization.pagebuilder_hierarchy_overlay_image;
      case PageBuilderWidgetType.button:
        return localization.pagebuilder_hierarchy_overlay_button;
      case PageBuilderWidgetType.anchorButton:
        return localization.pagebuilder_hierarchy_overlay_anchor_button;
      case PageBuilderWidgetType.container:
        return localization.pagebuilder_hierarchy_overlay_container;
      case PageBuilderWidgetType.row:
        return localization.pagebuilder_hierarchy_overlay_row;
      case PageBuilderWidgetType.column:
        return localization.pagebuilder_hierarchy_overlay_column;
      case PageBuilderWidgetType.icon:
        return localization.pagebuilder_hierarchy_overlay_icon;
      case PageBuilderWidgetType.contactForm:
        return localization.pagebuilder_hierarchy_overlay_contact_form;
      case PageBuilderWidgetType.footer:
        return localization.pagebuilder_hierarchy_overlay_footer;
      case PageBuilderWidgetType.videoPlayer:
        return localization.pagebuilder_hierarchy_overlay_video_player;
      default:
        return elementType?.name ?? "";
    }
  }

  /// Auto-expands the tree to make the selected widget visible using intelligent expansion
  void _autoExpandForWidget(String widgetId) {
    if (_hierarchyHelper == null) return;

    final expansionState = _hierarchyHelper!.getOptimalExpansionState(widgetId);
    final sectionsToExpand = expansionState['sectionsToExpand'] ?? <String>[];
    final widgetsToExpand = expansionState['widgetsToExpand'] ?? <String>[];
    final sectionsToCollapse =
        expansionState['sectionsToCollapse'] ?? <String>[];
    final widgetsToCollapse = expansionState['widgetsToCollapse'] ?? <String>[];

    setState(() {
      // First collapse sections and widgets that should be closed
      for (final sectionId in sectionsToCollapse) {
        _expandedSections.remove(sectionId);
      }

      for (final widgetId in widgetsToCollapse) {
        _expandedWidgets.remove(widgetId);
      }

      // Then expand the required sections and widgets
      for (final sectionId in sectionsToExpand) {
        _expandedSections.add(sectionId);
      }

      for (final widgetId in widgetsToExpand) {
        _expandedWidgets.add(widgetId);
      }
    });
  }
}
