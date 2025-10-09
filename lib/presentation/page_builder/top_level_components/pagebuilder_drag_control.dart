import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:flutter/material.dart';

class PagebuilderDragControl<T> extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const PagebuilderDragControl({
    super.key,
    this.icon = Icons.drag_indicator,
    this.color = Colors.white,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final provider = DraggableItemProvider.of<T>(context);

    if (provider == null) {
      return Icon(icon, color: color, size: size);
    }

    return Draggable<DragData<T>>(
      data: provider.dragData,
      onDragStarted: provider.onDragStarted,
      onDragEnd: (_) => provider.onDragEnd(),
      onDraggableCanceled: (_, __) => provider.onDragEnd(),
      feedback: Transform.scale(
        scale: 0.5,
        alignment: Alignment.topLeft,
        child: Opacity(
          opacity: 0.7,
          child: provider.buildFeedback(context),
        ),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: Icon(icon, color: color, size: size),
    );
  }
}
