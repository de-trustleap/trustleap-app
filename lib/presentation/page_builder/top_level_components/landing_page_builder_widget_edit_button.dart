import 'package:flutter/material.dart';

class LandingPageBuilderWidgetEditButton extends StatelessWidget {
  const LandingPageBuilderWidgetEditButton({super.key});

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
              print("PRESSED WIDGET");
            },
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
