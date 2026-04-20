import "dart:typed_data";

import "package:finanzbegleiter/l10n/generated/app_localizations.dart";
import "package:flutter/material.dart";

class LandingPageCreatorImagePickerBox extends StatelessWidget {
  final Size size;
  final Uint8List? imageBytes;
  final String? imageUrl;
  final bool hovered;
  final VoidCallback onTap;

  const LandingPageCreatorImagePickerBox({
    super.key,
    required this.size,
    required this.imageBytes,
    required this.imageUrl,
    required this.hovered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    Widget content;
    if (imageBytes != null) {
      content = Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(imageBytes!),
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: themeData.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              localization.landingpage_creator_image_upload_hint,
              style: themeData.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: hovered
                ? themeData.colorScheme.surfaceContainerHighest
                : themeData.colorScheme.surface,
            border: Border.all(
              color: hovered
                  ? themeData.colorScheme.secondary
                  : themeData.colorScheme.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: content,
        ),
      ),
    );
  }
}
