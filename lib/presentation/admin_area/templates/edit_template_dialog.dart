import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder_section_template_upload/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/widgets/edit_template_dropdowns.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/widgets/edit_template_existing_assets_section.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/widgets/edit_template_json_editor_section.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/widgets/edit_template_new_assets_section.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/widgets/edit_template_thumbnail_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
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

  void _removeExistingAsset(String url) {
    setState(() {
      _existingAssetUrls.remove(url);
      _deletedAssetUrls.add(url);
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
            Navigator.of(context).pop();
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
                  ? _buildLoadingState(theme, localization)
                  : _buildContent(theme, localization, isUpdating),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppLocalizations localization) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(localization.admin_area_template_manager_edit_loading),
        ],
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    AppLocalizations localization,
    bool isUpdating,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, localization),
          const SizedBox(height: 24),
          EditTemplateThumbnailSection(
            currentThumbnailUrl: widget.meta.thumbnailUrl,
            selectedThumbnailFile: _thumbnailFile,
            onPickThumbnail: _pickThumbnail,
          ),
          const SizedBox(height: 16),
          EditTemplateExistingAssetsSection(
            existingAssetUrls: _existingAssetUrls,
            onRemoveAsset: _removeExistingAsset,
          ),
          const SizedBox(height: 16),
          EditTemplateJsonEditorSection(
            jsonController: _jsonController,
            hasError: _jsonHasError,
            onFormat: _formatJson,
            onPickFile: _pickJsonFile,
          ),
          const SizedBox(height: 16),
          EditTemplateNewAssetsSection(
            newAssetFiles: _newAssetFiles,
            onPickAssets: _pickNewAssets,
            onRemoveAsset: _removeNewAsset,
          ),
          const SizedBox(height: 16),
          EditTemplateTypeDropdown(
            selectedType: _selectedType,
            onChanged: (value) => setState(() => _selectedType = value),
          ),
          const SizedBox(height: 16),
          EditTemplateEnvironmentDropdown(
            environment: _environment,
            onChanged: (value) => setState(() => _environment = value),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            title: localization.admin_area_template_manager_edit_button,
            onTap: _updateTemplate,
            isLoading: isUpdating,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    AppLocalizations localization,
  ) {
    return Row(
      children: [
        Text(
          localization.admin_area_template_manager_edit_dialog_title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
