// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class LandingPageAvatar extends StatelessWidget {
  final String? thumbnailDownloadURL;
  final String? name;
  final double size;

  const LandingPageAvatar({
    super.key,
    required this.thumbnailDownloadURL,
    required this.name,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (thumbnailDownloadURL != null && thumbnailDownloadURL!.isNotEmpty) {
      return Image.network(
        thumbnailDownloadURL!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return ClipOval(child: SizedBox(width: size, height: size, child: child));
          }
          return _buildInitialsAvatar(themeData, showLoading: true);
        },
        errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(themeData),
      );
    }

    return _buildInitialsAvatar(themeData);
  }

  Widget _buildInitialsAvatar(ThemeData themeData, {bool showLoading = false}) {
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
                _getInitial(),
                style: TextStyle(
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.35,
                ),
              ),
            ),
    );
  }

  String _getInitial() {
    final n = name ?? '';
    return n.isNotEmpty ? n[0].toUpperCase() : '';
  }
}
