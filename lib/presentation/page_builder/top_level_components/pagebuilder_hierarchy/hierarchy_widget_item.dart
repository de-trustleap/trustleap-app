import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/draggable_item_provider.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';

class HierarchyWidgetItem extends StatelessWidget {
  final PageBuilderWidget widget;
  final String? selectedWidgetId;
  final int depth;
  final Function(String widgetId, bool isSection) onItemSelected;
  final Function(String parentId, int oldIndex, int newIndex)? onWidgetReorder;
  final Set<String> expandedWidgets;
  final Function(String widgetId) onToggleExpand;
  final bool showDragHandle;

  const HierarchyWidgetItem({
    super.key,
    required this.widget,
    required this.selectedWidgetId,
    required this.depth,
    required this.onItemSelected,
    required this.onWidgetReorder,
    required this.expandedWidgets,
    required this.onToggleExpand,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final widgetId = widget.id.value;
    final isExpanded = expandedWidgets.contains(widgetId);
    final isSelected = selectedWidgetId == widgetId;
    final hasChildren =
        (widget.children != null && widget.children!.isNotEmpty) ||
            widget.containerChild != null;

    final isInFeedback =
        DraggableItemProvider.of<PageBuilderWidget>(context) == null;

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
                onItemSelected(widgetId, false);
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
                          onToggleExpand(widgetId);
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
                    if (!isInFeedback && showDragHandle) ...[
                      const SizedBox(width: 4),
                      PagebuilderDragControl<PageBuilderWidget>(
                        icon: Icons.drag_indicator,
                        color: isSelected
                            ? Colors.white
                            : themeData.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded && hasChildren && !isInFeedback)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildChildren(isInFeedback),
            ),
        ],
      ),
    );
  }

  Widget _buildChildren(bool parentIsInFeedback) {
    // For containers with single child, just render directly
    if (widget.containerChild != null &&
        (widget.children == null || widget.children!.isEmpty)) {
      return HierarchyWidgetItem(
        widget: widget.containerChild!,
        selectedWidgetId: selectedWidgetId,
        depth: depth + 1,
        onItemSelected: onItemSelected,
        onWidgetReorder: onWidgetReorder,
        expandedWidgets: expandedWidgets,
        onToggleExpand: onToggleExpand,
        showDragHandle: false,
      );
    }

    // For rows/columns with children, wrap in PagebuilderReorderableElement
    if (widget.children != null && widget.children!.isNotEmpty) {
      final hasMultipleChildren = widget.children!.length > 1;

      return PagebuilderReorderableElement<PageBuilderWidget>(
        containerId: widget.id.value,
        items: widget.children!,
        getItemId: (child) => child.id.value,
        isContainer: (child) =>
            child.elementType == PageBuilderWidgetType.container,
        onReorder: (oldIndex, newIndex) {
          onWidgetReorder?.call(widget.id.value, oldIndex, newIndex);
        },
        buildChild: (child, index) {
          return HierarchyWidgetItem(
            widget: child,
            selectedWidgetId: selectedWidgetId,
            depth: depth + 1,
            onItemSelected: onItemSelected,
            onWidgetReorder: onWidgetReorder,
            expandedWidgets: expandedWidgets,
            onToggleExpand: onToggleExpand,
            showDragHandle: hasMultipleChildren,
          );
        },
      );
    }

    return const SizedBox.shrink();
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
}
