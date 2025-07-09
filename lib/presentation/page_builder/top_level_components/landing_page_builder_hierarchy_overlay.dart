import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_hierarchy_tree_view.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderHierarchyOverlay extends StatefulWidget {
  final PageBuilderPage page;
  final VoidCallback onClose;
  final Function(String widgetId, bool isSection) onItemSelected;

  const LandingPageBuilderHierarchyOverlay({
    super.key,
    required this.page,
    required this.onClose,
    required this.onItemSelected,
  });

  @override
  State<LandingPageBuilderHierarchyOverlay> createState() =>
      _LandingPageBuilderHierarchyOverlayState();
}

class _LandingPageBuilderHierarchyOverlayState
    extends State<LandingPageBuilderHierarchyOverlay> {
  Offset _position = const Offset(20, 100);
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
        },
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        child: Material(
          elevation: _isDragging ? 12 : 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 320,
            height: 400,
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeData.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Seitenstruktur",
                          style: themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                Expanded(
                  child: LandingPageBuilderHierarchyTreeView(
                    page: widget.page,
                    onItemSelected: widget.onItemSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
