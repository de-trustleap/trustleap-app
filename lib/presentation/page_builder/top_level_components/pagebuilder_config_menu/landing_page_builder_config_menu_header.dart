import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuHeader extends StatelessWidget {
  final String title;
  final Function closePressed;
  const LandingPageBuilderConfigMenuHeader(
      {super.key, required this.title, required this.closePressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(title,
                  style: themeData.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis)),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
                onPressed: () => closePressed(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close),
                iconSize: 24),
          )
        ],
      ),
    );
  }
}
