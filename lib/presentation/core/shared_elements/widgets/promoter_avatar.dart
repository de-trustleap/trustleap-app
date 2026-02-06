import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class PromoterAvatar extends StatelessWidget {
  final String? thumbnailDownloadURL;
  final String? firstName;
  final String? lastName;
  final double size;

  const PromoterAvatar({
    super.key,
    required this.thumbnailDownloadURL,
    required this.firstName,
    required this.lastName,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (thumbnailDownloadURL != null) {
      return CachedNetworkImage(
        width: size,
        height: size,
        imageUrl: thumbnailDownloadURL!,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) {
          return _buildInitialsAvatar(themeData, showLoading: true);
        },
        errorWidget: (context, url, error) {
          return _buildInitialsAvatar(themeData);
        },
      );
    }

    return _buildInitialsAvatar(themeData);
  }

  Widget _buildInitialsAvatar(ThemeData themeData, {bool showLoading = false}) {
    final initials = _getInitials();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeData.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: showLoading
          ? const LoadingIndicator()
          : Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.35,
                ),
              ),
            ),
    );
  }

  String _getInitials() {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final firstInitial = first.isNotEmpty ? first[0].toUpperCase() : '';
    final lastInitial = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }
}
