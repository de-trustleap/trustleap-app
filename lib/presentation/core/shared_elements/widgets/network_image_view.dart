// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatefulWidget {
  final String imageURL;
  final double? cornerRadius;
  final double? width;
  final double? height;

  const NetworkImageView(
      {super.key,
      required this.imageURL,
      this.cornerRadius,
      required this.width,
      required this.height});

  @override
  State<NetworkImageView> createState() => _NetworkImageViewState();
}

class _NetworkImageViewState extends State<NetworkImageView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0),
          child: Image.network(widget.imageURL, fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const LoadingIndicator();
          }, errorBuilder: (context, error, stackTrace) {
            return Image.asset(kDebugMode
                ? "images/placeholder.png"
                : "assets/images/placeholder.png");
          })),
    );
  }
}
