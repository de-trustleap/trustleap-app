import 'package:flutter/material.dart';

class LandingPageBuilderSectionEditButton extends StatelessWidget {
  final Function onPressed;
  const LandingPageBuilderSectionEditButton(
      {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Positioned(
      top: 0,
      child: ClipPath(
        clipper: InvertedTrapezoidClipper(),
        child: Container(
          width: 60,
          height: 30,
          decoration: BoxDecoration(
            color: themeData.colorScheme.secondary,
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                onPressed();
              },
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
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
