import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_tree_view.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_hierarchy/landing_page_builder_hierarchy_overlay_resize_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  double _overlayWidth = 320.0;
  double _overlayHeight = 400.0;
  Offset? _position;
  bool _isDragging = false;
  bool _isResizing = false;
  bool _isInitialized = false;

  static const double _minWidth = 250.0;
  static const double _maxWidth = 600.0;
  static const double _minHeight = 300.0;
  static const double _maxHeight = 800.0;

  @override
  void initState() {
    super.initState();
    // Force a rebuild after first frame to ensure widget tree is stable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    _position ??= Offset(responsiveValue.screenWidth - _overlayWidth - 16, 80);

    return Positioned(
      left: _position!.dx,
      top: _position!.dy,
      width: _overlayWidth,
      height: _overlayHeight,
      child: Material(
        elevation: (_isDragging || _isResizing) ? 12 : 8,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              width: _overlayWidth,
              height: _overlayHeight,
              decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: themeData.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.move,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: (details) {
                        setState(() {
                          _position = Offset(
                            _position!.dx + details.delta.dx,
                            _position!.dy + details.delta.dy,
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
                      child: Container(
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
                              localization.pagebuilder_hierarchy_overlay_title,
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
                    ),
                  ),
                  Expanded(
                    child: LandingPageBuilderHierarchyTreeView(
                      key: const ValueKey('hierarchy-tree-view'),
                      page: widget.page,
                      onItemSelected: widget.onItemSelected,
                      onSectionReorder: (oldIndex, newIndex) {
                        Modular.get<PagebuilderBloc>()
                            .add(ReorderSectionsEvent(oldIndex, newIndex));
                      },
                      onWidgetReorder: (parentId, oldIndex, newIndex) {
                        Modular.get<PagebuilderBloc>()
                            .add(ReorderWidgetEvent(parentId, oldIndex, newIndex));
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Resize controls
            LandingPageBuilderHierarchyOverlayResizeControls(
              width: _overlayWidth,
              height: _overlayHeight,
              position: _position!,
              minWidth: _minWidth,
              maxWidth: _maxWidth,
              minHeight: _minHeight,
              maxHeight: _maxHeight,
              onResize: (width, height, position) {
                setState(() {
                  _overlayWidth = width;
                  _overlayHeight = height;
                  _position = position;
                });
              },
              onResizeStart: () {
                setState(() {
                  _isResizing = true;
                });
              },
              onResizeEnd: () {
                setState(() {
                  _isResizing = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
