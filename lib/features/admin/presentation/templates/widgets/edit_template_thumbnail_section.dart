import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EditTemplateThumbnailSection extends StatelessWidget {
  final String currentThumbnailUrl;
  final PlatformFile? selectedThumbnailFile;
  final VoidCallback onPickThumbnail;

  const EditTemplateThumbnailSection({
    super.key,
    required this.currentThumbnailUrl,
    required this.selectedThumbnailFile,
    required this.onPickThumbnail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_thumbnail_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: selectedThumbnailFile?.bytes != null
                ? Image.memory(
                    selectedThumbnailFile!.bytes!,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: currentThumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onPickThumbnail,
          icon: const Icon(Icons.image),
          label: Text(selectedThumbnailFile?.name ??
              localization.admin_area_template_manager_file_picker_hint),
        ),
      ],
    );
  }
}
