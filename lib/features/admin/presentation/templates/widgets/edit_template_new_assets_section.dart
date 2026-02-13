import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EditTemplateNewAssetsSection extends StatelessWidget {
  final List<PlatformFile> newAssetFiles;
  final VoidCallback onPickAssets;
  final void Function(int index) onRemoveAsset;

  const EditTemplateNewAssetsSection({
    super.key,
    required this.newAssetFiles,
    required this.onPickAssets,
    required this.onRemoveAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.admin_area_template_manager_new_assets_label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: onPickAssets,
              icon: const Icon(Icons.add_photo_alternate),
              label:
                  Text(localization.admin_area_template_manager_add_images_button),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (newAssetFiles.isEmpty)
          _buildEmptyState(theme, localization)
        else
          _buildAssetGrid(theme),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations localization) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          localization.admin_area_template_manager_no_assets_selected,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetGrid(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: newAssetFiles.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return _NewAssetTile(
          file: file,
          onRemove: () => onRemoveAsset(index),
        );
      }).toList(),
    );
  }
}

class _NewAssetTile extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onRemove;

  const _NewAssetTile({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            image: file.bytes != null
                ? DecorationImage(
                    image: MemoryImage(file.bytes!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
