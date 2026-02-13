import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class EditTemplateJsonEditorSection extends StatelessWidget {
  final CodeController? jsonController;
  final bool hasError;
  final VoidCallback onFormat;
  final VoidCallback onPickFile;

  const EditTemplateJsonEditorSection({
    super.key,
    required this.jsonController,
    required this.hasError,
    required this.onFormat,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              localization.admin_area_template_manager_section_json_label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onFormat,
              icon: const Icon(Icons.format_align_left),
              tooltip: localization.admin_area_template_manager_json_format_tooltip,
            ),
            IconButton(
              onPressed: onPickFile,
              icon: const Icon(Icons.upload_file),
              tooltip: localization.admin_area_template_manager_json_upload_tooltip,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: hasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: jsonController != null
                ? CodeTheme(
                    data: CodeThemeData(styles: monokaiSublimeTheme),
                    child: CodeField(
                      controller: jsonController!,
                      textStyle: const TextStyle(
                        fontFamily: "monospace",
                        fontSize: 14,
                      ),
                      expands: true,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              localization.admin_area_template_manager_json_invalid,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
