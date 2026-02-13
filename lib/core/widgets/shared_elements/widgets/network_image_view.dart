// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatefulWidget {
  final String imageURL;
  final double? cornerRadius;
  final double? width;
  final double? height;
  final BoxFit? contentMode;

  const NetworkImageView(
      {super.key,
      required this.imageURL,
      this.cornerRadius,
      required this.width,
      required this.height,
      required this.contentMode});

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
          child: Image.network(widget.imageURL,
              fit: widget.contentMode ?? BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const LoadingIndicator();
          }, errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/images/placeholder.png");
          })),
    );
  }
}
