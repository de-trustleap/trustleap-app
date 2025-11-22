import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetControls extends StatelessWidget {
  final Function onEdit;
  final Function onDelete;
  final int? index;
  final double? parentWidth;

  const LandingPageBuilderWidgetControls({
    super.key,
    required this.onEdit,
    required this.onDelete,
    this.index,
    this.parentWidth,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final hasDragHandle = index != null;

    final minWidthForAllControls = hasDragHandle ? 85.0 : 50.0;
    final hasEnoughSpace =
        parentWidth != null && parentWidth! >= minWidthForAllControls;

    return Positioned(
      top: 0,
      left: 0,
      child: hasEnoughSpace
          ? Container(
              width: minWidthForAllControls,
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
                            onEdit();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            onDelete();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete,
                              color: Colors.white, size: 16),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            onEdit();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            onDelete();
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete,
                              color: Colors.white, size: 16),
                        ),
                      ],
                    ),
            )
          : Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: themeData.colorScheme.secondary,
              ),
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon:
                    const Icon(Icons.more_vert, color: Colors.white, size: 12),
                iconSize: 12,
                onSelected: (value) {
                  if (value == "edit") {
                    onEdit();
                  } else if (value == "delete") {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "edit",
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit,
                            size: 14, color: themeData.colorScheme.secondary),
                        const SizedBox(width: 6),
                        Text(localization.pagebuilder_widget_controls_edit,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete,
                            size: 14, color: themeData.colorScheme.secondary),
                        const SizedBox(width: 6),
                        Text(localization.pagebuilder_widget_controls_delete,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
// TODO: ACTIONS FUNKTIONIEREN NOCH NICHT
// TODO: DOPPELKLICK EINFÜHREN UM EDIT MODE ZU ÖFFNEN
