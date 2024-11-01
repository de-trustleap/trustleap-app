import 'package:flutter/material.dart';

class LandingPageBuilderWidgetEditButton extends StatelessWidget {
  final Function onPressed;
  const LandingPageBuilderWidgetEditButton(
      {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: themeData.colorScheme.secondary,
        ),
        child: Center(
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
