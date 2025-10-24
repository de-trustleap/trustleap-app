import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_drag_control.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderSectionControls extends StatelessWidget {
  final Function onEditPressed;
  final Function onDeletePressed;
  final int index;
  const LandingPageBuilderSectionControls({
    super.key,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

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
              const PagebuilderDragControl<PageBuilderSection>(
                icon: Icons.drag_indicator,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  onEditPressed();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  onDeletePressed();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete, color: Colors.white, size: 20),
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
