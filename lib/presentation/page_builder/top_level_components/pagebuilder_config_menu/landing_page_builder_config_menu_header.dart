import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuHeader extends StatelessWidget {
  final Function closePressed;
  const LandingPageBuilderConfigMenuHeader(
      {super.key, required this.closePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text("Konfiguration", overflow: TextOverflow.ellipsis)),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
                onPressed: () => closePressed(),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close),
                iconSize: 24),
          )
        ],
      ),
    );
  }
}
