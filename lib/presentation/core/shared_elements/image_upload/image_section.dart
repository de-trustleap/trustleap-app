// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/cached_image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final GlobalKey widgetKey;
  final String imageDownloadURL;
  final String thumbnailDownloadURL;
  final Size imageSize;
  final bool hovered;
  final bool isLoading;
  final Uint8List? imageBytes;
  final Function pickImage;

  const ImageSection(
      {super.key,
      required this.widgetKey,
      required this.imageDownloadURL,
      required this.thumbnailDownloadURL,
      required this.imageSize,
      required this.hovered,
      required this.isLoading,
      this.imageBytes,
      required this.pickImage});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Stack(
      key: widgetKey,
      children: [
        CachedImageView(
            imageSize: imageSize,
            imageDownloadURL: imageDownloadURL,
            thumbnailDownloadURL: thumbnailDownloadURL,
            hovered: hovered,
            imageBytes: imageBytes),
        Positioned(
            bottom: 0,
            right: 0,
            child: Tooltip(
              message: localizations.profile_image_upload_tooltip,
              child: ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: themeData.colorScheme.secondary),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.add_a_photo, color: Colors.white)),
            ))
      ],
    );
  }
}
