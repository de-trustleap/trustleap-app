import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderHeightResizeOverlay extends StatefulWidget {
  final PageBuilderWidget model;
  final PagebuilderResponsiveBreakpoint breakpoint;
  final double currentHeight;
  final bool isResizing;
  final double resizeDelta;
  final void Function({
    required bool isResizing,
    required double resizeDelta,
    required double startHeight,
  }) onResizeStateChange;

  const PageBuilderHeightResizeOverlay({
    super.key,
    required this.model,
    required this.breakpoint,
    required this.currentHeight,
    required this.isResizing,
    required this.resizeDelta,
    required this.onResizeStateChange,
  });

  @override
  State<PageBuilderHeightResizeOverlay> createState() =>
      _PageBuilderHeightResizeOverlayState();
}

class _PageBuilderHeightResizeOverlayState
    extends State<PageBuilderHeightResizeOverlay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final properties = widget.model.properties as PageBuilderHeightProperties;
    final shouldShowIndicator = _isHovered || widget.isResizing;

    // Calculate current height during resize
    double displayHeight = widget.currentHeight;
    if (widget.isResizing) {
      displayHeight =
          (widget.currentHeight + widget.resizeDelta).clamp(1.0, 10000.0);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.resizeRow,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        if (!widget.isResizing) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: GestureDetector(
        onVerticalDragStart: (_) {
          widget.onResizeStateChange(
            isResizing: true,
            resizeDelta: 0.0,
            startHeight: widget.currentHeight,
          );
          Modular.get<PagebuilderHoverCubit>().setDisabled(true);
        },
        onVerticalDragUpdate: (details) {
          widget.onResizeStateChange(
            isResizing: widget.isResizing,
            resizeDelta: widget.resizeDelta + details.delta.dy,
            startHeight: widget.currentHeight,
          );
        },
        onVerticalDragEnd: (_) {
          final newHeight =
              (widget.currentHeight + widget.resizeDelta).clamp(1.0, 10000.0);

          final hoverCubit = Modular.get<PagebuilderHoverCubit>();

          if (newHeight < 1) {
            widget.onResizeStateChange(
              isResizing: false,
              resizeDelta: 0.0,
              startHeight: 0.0,
            );
            hoverCubit.setDisabled(false);
            if (_isHovered) {
              hoverCubit.setHovered(widget.model.id.value);
            }
            return;
          }

          final helper = PagebuilderResponsiveConfigHelper(widget.breakpoint);
          final updatedHeight = helper.setValue(
            properties.height,
            newHeight.round(),
          );
          final updatedProperties = properties.copyWith(height: updatedHeight);
          final updatedWidget =
              widget.model.copyWith(properties: updatedProperties);

          Modular.get<PagebuilderBloc>().add(UpdateWidgetEvent(updatedWidget));
          hoverCubit.setDisabled(false);
          if (_isHovered) {
            hoverCubit.setHovered(widget.model.id.value);
          }
        },
        child: SizedBox(
          height: displayHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: shouldShowIndicator
                        ? Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.15)
                        : Colors.transparent,
                    border: shouldShowIndicator
                        ? Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                ),
              ),
              if (shouldShowIndicator)
                Positioned(
                  left: 0,
                  right: 0,
                  top: (displayHeight / 2) - 14,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${displayHeight.round()}px',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
