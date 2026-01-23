import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder_section_template_upload/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:highlight/languages/json.dart' as highlight_json;

class EditTemplateDialog extends StatefulWidget {
  final PagebuilderSectionTemplateMeta meta;

  const EditTemplateDialog({super.key, required this.meta});

  @override
  State<EditTemplateDialog> createState() => _EditTemplateDialogState();
}

class _EditTemplateDialogState extends State<EditTemplateDialog> {
  final PagebuilderSectionTemplateCubit _templateCubit =
      Modular.get<PagebuilderSectionTemplateCubit>();

  List<String> _existingAssetUrls = [];
  final List<String> _deletedAssetUrls = [];
  PlatformFile? _thumbnailFile;
  List<PlatformFile> _newAssetFiles = [];
  String _environment = "both";
  late SectionType _selectedType;
  bool _isLoadingTemplate = true;

  CodeController? _jsonController;
  String _originalJson = "";
  bool _jsonHasError = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.meta.type;
    _loadTemplate();
  }

  @override
  void dispose() {
    _jsonController?.dispose();
    super.dispose();
  }

  void _loadTemplate() {
    _templateCubit.getTemplateById(widget.meta.id);
  }

  String _formatSectionToJson(PageBuilderSection section) {
    final sectionModel = PageBuilderSectionModel.fromDomain(section);
    const encoder = JsonEncoder.withIndent("  ");
    return encoder.convert(sectionModel.toMap());
  }

  void _formatJson() {
    if (_jsonController == null) return;
    try {
      final parsed = jsonDecode(_jsonController!.text);
      const encoder = JsonEncoder.withIndent("  ");
      _jsonController!.text = encoder.convert(parsed);
      setState(() {
        _jsonHasError = false;
      });
    } catch (e) {
      setState(() {
        _jsonHasError = true;
      });
    }
  }

  List<String> _extractAssetUrlsFromSection(PageBuilderSection section) {
    final sectionModel = PageBuilderSectionModel.fromDomain(section);
    final jsonString = jsonEncode(sectionModel.toMap());
    final urlPattern = RegExp(
      r'https://firebasestorage\.googleapis\.com/[^"]+insidePageImage[^"]+',
    );
    final matches = urlPattern.allMatches(jsonString);
    return matches.map((m) => m.group(0)!).toSet().toList();
  }

  Future<void> _pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        try {
          final jsonString = utf8.decode(file.bytes!);
          final parsed = jsonDecode(jsonString);
          const encoder = JsonEncoder.withIndent("  ");
          final formatted = encoder.convert(parsed);
          _jsonController?.text = formatted;
          setState(() {
            _jsonHasError = false;
          });
        } catch (e) {
          setState(() {
            _jsonHasError = true;
          });
        }
      }
    }
  }

  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _thumbnailFile = result.files.first;
      });
    }
  }

  Future<void> _pickNewAssets() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _newAssetFiles = [..._newAssetFiles, ...result.files];
      });
    }
  }

  void _removeNewAsset(int index) {
    setState(() {
      _newAssetFiles.removeAt(index);
    });
  }

  Uint8List? _getJsonDataIfChanged() {
    if (_jsonController == null) return null;
    final currentJson = _jsonController!.text;
    if (currentJson == _originalJson) return null;
    return utf8.encode(currentJson);
  }

  void _updateTemplate() {
    final template = PagebuilderSectionTemplateEdit(
      templateId: widget.meta.id,
      jsonData: _getJsonDataIfChanged(),
      thumbnailData: _thumbnailFile?.bytes,
      deletedAssetUrls: _deletedAssetUrls,
      newAssetDataList: _newAssetFiles
          .where((file) => file.bytes != null)
          .map((file) => file.bytes!)
          .toList(),
      environment: _environment,
      type: _selectedType.name,
    );

    Modular.get<PagebuilderSectionTemplateUploadCubit>().editTemplate(template);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final uploadCubit = Modular.get<PagebuilderSectionTemplateUploadCubit>();
    final navigator = CustomNavigator.of(context);

    return BlocListener<PagebuilderSectionTemplateCubit,
        PagebuilderSectionTemplateState>(
      bloc: _templateCubit,
      listener: (context, state) {
        if (state is PagebuilderSectionTemplateFullLoadSuccess) {
          final formattedJson = _formatSectionToJson(state.template.section);
          _originalJson = formattedJson;
          _jsonController = CodeController(
            text: formattedJson,
            language: highlight_json.json,
          );
          setState(() {
            _existingAssetUrls =
                _extractAssetUrlsFromSection(state.template.section);
            _isLoadingTemplate = false;
          });
        } else if (state is PagebuilderSectionTemplateFailure) {
          setState(() {
            _isLoadingTemplate = false;
          });
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.pagebuilder_template_library_error_loading_template,
            SnackBarType.failure,
          );
        }
      },
      child: BlocConsumer<PagebuilderSectionTemplateUploadCubit,
          PagebuilderSectionTemplateUploadState>(
        bloc: uploadCubit,
        listener: (context, state) {
          if (state is PagebuilderSectionTemplateEditSuccess) {
            CustomSnackBar.of(context).showCustomSnackBar(
              localization.admin_area_template_manager_edit_success,
              SnackBarType.success,
            );
            navigator.pop();
          } else if (state is PagebuilderSectionTemplateEditFailure) {
            final errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            CustomSnackBar.of(context).showCustomSnackBar(
              errorMessage,
              SnackBarType.failure,
            );
          }
        },
        builder: (context, state) {
          final isUpdating = state is PagebuilderSectionTemplateEditLoading;

          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
              child: _isLoadingTemplate
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(localization
                              .admin_area_template_manager_edit_loading),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                localization
                                    .admin_area_template_manager_edit_dialog_title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => navigator.pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            localization
                                .admin_area_template_manager_thumbnail_label,
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
                              child: _thumbnailFile?.bytes != null
                                  ? Image.memory(
                                      _thumbnailFile!.bytes!,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.meta.thumbnailUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: theme
                                            .colorScheme.surfaceContainerHighest,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: theme
                                            .colorScheme.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 48,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _pickThumbnail,
                            icon: const Icon(Icons.image),
                            label: Text(_thumbnailFile?.name ??
                                localization
                                    .admin_area_template_manager_file_picker_hint),
                          ),
                          const SizedBox(height: 16),
                          _buildExistingAssets(theme, localization),
                          const SizedBox(height: 16),
                          _buildJsonEditor(theme, localization),
                          const SizedBox(height: 16),
                          _buildNewAssetPicker(theme, localization),
                          const SizedBox(height: 16),
                          _buildTypeDropdown(theme, localization),
                          const SizedBox(height: 16),
                          _buildEnvironmentDropdown(theme, localization),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            title: localization
                                .admin_area_template_manager_edit_button,
                            onTap: _updateTemplate,
                            isLoading: isUpdating,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _removeExistingAsset(String url) {
    setState(() {
      _existingAssetUrls.remove(url);
      _deletedAssetUrls.add(url);
    });
  }

  Widget _buildJsonEditor(ThemeData theme, AppLocalizations localization) {
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
              onPressed: _formatJson,
              icon: const Icon(Icons.format_align_left),
              tooltip: "JSON formatieren",
            ),
            IconButton(
              onPressed: _pickJsonFile,
              icon: const Icon(Icons.upload_file),
              tooltip: "JSON-Datei hochladen",
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: _jsonHasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: _jsonHasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _jsonController != null
                ? CodeTheme(
                    data: CodeThemeData(styles: monokaiSublimeTheme),
                    child: CodeField(
                      controller: _jsonController!,
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
        if (_jsonHasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Ungültiges JSON-Format",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExistingAssets(ThemeData theme, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_asset_images_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_existingAssetUrls.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
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
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _existingAssetUrls.map((url) {
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 24,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      onTap: () => _removeExistingAsset(url),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNewAssetPicker(ThemeData theme, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Neue Assets",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _pickNewAssets,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                  localization.admin_area_template_manager_add_images_button),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_newAssetFiles.isEmpty)
          Container(
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
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _newAssetFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
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
                      onTap: () => _removeNewAsset(index),
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
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTypeDropdown(ThemeData theme, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_section_type_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<SectionType>(
            isExpanded: true,
            value: _selectedType,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: SectionType.hero,
                child: Text(localization.admin_area_template_manager_type_hero),
              ),
              DropdownMenuItem(
                value: SectionType.product,
                child:
                    Text(localization.admin_area_template_manager_type_product),
              ),
              DropdownMenuItem(
                value: SectionType.about,
                child: Text(localization.admin_area_template_manager_type_about),
              ),
              DropdownMenuItem(
                value: SectionType.callToAction,
                child: Text(
                    localization.admin_area_template_manager_type_call_to_action),
              ),
              DropdownMenuItem(
                value: SectionType.advantages,
                child: Text(
                    localization.admin_area_template_manager_type_advantages),
              ),
              DropdownMenuItem(
                value: SectionType.footer,
                child:
                    Text(localization.admin_area_template_manager_type_footer),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEnvironmentDropdown(
      ThemeData theme, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.admin_area_template_manager_environment_label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _environment,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "both",
              child:
                  Text(localization.admin_area_template_manager_environment_both),
            ),
            DropdownMenuItem(
              value: "staging",
              child: Text(
                  localization.admin_area_template_manager_environment_staging),
            ),
            DropdownMenuItem(
              value: "prod",
              child: Text(
                  localization.admin_area_template_manager_environment_prod),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _environment = value;
              });
            }
          },
        ),
      ],
    );
  }
}
