// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';

class CachedImageView extends StatefulWidget {
  final Size imageSize;
  final String imageDownloadURL;
  final String thumbnailDownloadURL;
  final bool hovered;

  const CachedImageView({
    super.key,
    required this.imageSize,
    required this.imageDownloadURL,
    required this.thumbnailDownloadURL,
    required this.hovered,
  });

  @override
  State<CachedImageView> createState() => _CachedImageViewState();
}

class _CachedImageViewState extends State<CachedImageView> {
  bool isImageClickable = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return MouseRegion(
      cursor: isImageClickable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () async {
          if (isImageClickable) {
            final imageProvider = Image.network(widget.imageDownloadURL).image;
            showImageViewer(context, imageProvider,
                swipeDismissible: true,
                doubleTapZoomable: true,
                useSafeArea: true,
                closeButtonTooltip: localization
                    .profile_page_image_section_large_image_view_close_button_tooltip_title);
          }
        },
        child: CachedNetworkImage(
          width: widget.imageSize.width,
          height: widget.imageSize.height,
          imageUrl: widget.thumbnailDownloadURL,
          imageBuilder: (context, imageProvider) {
            isImageClickable = true;
            return Container(
                decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5,
                  color: widget.hovered
                      ? themeData.colorScheme.secondary
                      : Colors.transparent),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ));
          },
          placeholder: (context, url) {
            return Stack(children: [
              PlaceholderImage(
                  imageSize: widget.imageSize, hovered: widget.hovered),
              const LoadingIndicator()
            ]);
          },
          errorWidget: (context, url, error) {
            isImageClickable = false;
            return PlaceholderImage(
                imageSize: widget.imageSize, hovered: widget.hovered);
          },
        ),
      ),
    );
  }
}
