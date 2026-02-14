import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/drag_data/widget_library_drag_data.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/pagebuilder_add_widget_overlay.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/pagebuilder_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderPlaceholder extends StatefulWidget {
  final PageBuilderWidget widgetModel;
  final int? index;

  const PagebuilderPlaceholder({
    super.key,
    required this.widgetModel,
    this.index,
  });

  @override
  State<PagebuilderPlaceholder> createState() => _PagebuilderPlaceholderState();
}

class _PagebuilderPlaceholderState extends State<PagebuilderPlaceholder> {
  bool _isHovered = false;
  bool _isDragOver = false;

  void _showWidgetMenu(BuildContext context) {
    PagebuilderOverlay.show(
      context: context,
      content: PagebuilderAddWidgetOverlay(
        onWidgetSelected: (widgetType) {
          Navigator.pop(context);
          Modular.get<PagebuilderBloc>().add(ReplacePlaceholderEvent(
            placeholderId: widget.widgetModel.id.value,
            widgetType: widgetType,
          ));
        },
      ),
    );
  }

  void _replacePlaceholder(WidgetLibraryDragData dragData) {
    Modular.get<PagebuilderBloc>().add(ReplacePlaceholderEvent(
      placeholderId: widget.widgetModel.id.value,
      widgetType: dragData.widgetType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return DragTarget<WidgetLibraryDragData>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        _replacePlaceholder(details.data);
        setState(() => _isDragOver = false);
      },
      onLeave: (_) {
        setState(() => _isDragOver = false);
      },
      onMove: (_) {
        if (!_isDragOver) {
          setState(() => _isDragOver = true);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: Builder(
            builder: (context) {
              return InkWell(
                onTap: () => _showWidgetMenu(context),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isDragOver
                        ? themeData.colorScheme.secondary.withValues(alpha: 0.2)
                        : _isHovered
                            ? themeData.colorScheme.secondary.withValues(alpha: 0.1)
                            : Colors.transparent,
                    border: Border.all(
                      color: themeData.colorScheme.secondary,
                      width: _isDragOver ? 3 : 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 48,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
