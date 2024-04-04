// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final Size imageSize;
  final bool hovered;

  const PlaceholderImage(
      {Key? key, required this.imageSize, required this.hovered})
      : super(key: key);

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
                  ? "images/placeholder.jpg"
                  : "assets/images/placeholder.jpg"))),
    );
  }
}
