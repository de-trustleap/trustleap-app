import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetControls extends StatelessWidget {
  final Function onPressed;
  final int? index;

  const LandingPageBuilderWidgetControls({
    super.key,
    required this.onPressed,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final hasDragHandle = index != null;

    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: hasDragHandle ? 60 : 25,
        height: 25,
        decoration: BoxDecoration(
          color: themeData.colorScheme.secondary,
        ),
        child: hasDragHandle
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PagebuilderDragControl<PageBuilderWidget>(
                    icon: Icons.drag_indicator,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {
                      onPressed();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ],
              )
            : Center(
                child: IconButton(
                  onPressed: () {
                    onPressed();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
      ),
    );
  }
}
