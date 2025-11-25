import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderSectionControls extends StatelessWidget {
  final Function onEditPressed;
  final Function onDeletePressed;
  final Function onDuplicatePressed;
  final int index;
  const LandingPageBuilderSectionControls({
    super.key,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onDuplicatePressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Positioned(
      top: 0,
      child: ClipPath(
        clipper: InvertedTrapezoidClipper(),
        child: Container(
          width: 140,
          height: 30,
          decoration: BoxDecoration(
            color: themeData.colorScheme.secondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: localization.pagebuilder_section_controls_drag_tooltip,
                child: const PagebuilderDragControl<PageBuilderSection>(
                  icon: Icons.drag_indicator,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: localization.pagebuilder_section_controls_edit_tooltip,
                child: IconButton(
                  onPressed: () {
                    onEditPressed();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 20,
                child: PopupMenuButton<String>(
                  icon:
                      const Icon(Icons.more_vert, color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  constraints: const BoxConstraints(),
                  itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'duplicate',
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      onDuplicatePressed();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.content_copy,
                            size: 18, color: themeData.colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                            localization.pagebuilder_section_controls_duplicate,
                            style: themeData.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      onDeletePressed();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete,
                            size: 18, color: themeData.colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(localization.pagebuilder_section_controls_delete,
                            style: themeData.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvertedTrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
