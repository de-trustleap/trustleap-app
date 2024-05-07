// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final Size imageSize;
  final bool hovered;

  const PlaceholderImage(
      {super.key, required this.imageSize, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      width: imageSize.width,
      height: imageSize.height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 5,
              color: hovered
                  ? themeData.colorScheme.secondary
                  : Colors.transparent),
          image: const DecorationImage(
              image: AssetImage(kDebugMode
                  ? "images/placeholder.png"
                  : "assets/images/placeholder.png"))),
    );
  }
}
