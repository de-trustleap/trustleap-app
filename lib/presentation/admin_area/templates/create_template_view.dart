import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/application/pagebuilder_section_template_upload/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateTemplateView extends StatefulWidget {
  const CreateTemplateView({super.key});

  @override
  State<CreateTemplateView> createState() => _CreateTemplateViewState();
}

class _CreateTemplateViewState extends State<CreateTemplateView> {
  PlatformFile? _jsonFile;
  PlatformFile? _thumbnailFile;
  List<PlatformFile> _assetFiles = [];
  String _environment = "both";
  SectionType? _selectedType;

  Future<void> _pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _jsonFile = result.files.first;
      });
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

  Future<void> _pickAssets() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _assetFiles = result.files;
      });
    }
  }

  void _removeAsset(int index) {
    setState(() {
      _assetFiles.removeAt(index);
    });
  }

  void _uploadTemplate() {
    final localization = AppLocalizations.of(context);

    if (_jsonFile == null || _thumbnailFile == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        localization.admin_area_template_manager_error_missing_files,
        SnackBarType.failure,
      );
      return;
    }

    if (_selectedType == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        localization.admin_area_template_manager_error_missing_type,
        SnackBarType.failure,
      );
      return;
    }

    if (_jsonFile!.bytes == null || _thumbnailFile!.bytes == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        localization.admin_area_template_manager_error_reading_files,
        SnackBarType.failure,
      );
      return;
    }

    final template = PagebuilderSectionTemplateUpload(
      jsonData: _jsonFile!.bytes!,
      jsonFileName: _jsonFile!.name,
      thumbnailData: _thumbnailFile!.bytes!,
      thumbnailFileName: _thumbnailFile!.name,
      assetDataList: _assetFiles
          .where((file) => file.bytes != null)
          .map((file) => file.bytes!)
          .toList(),
      assetFileNames: _assetFiles
          .where((file) => file.bytes != null)
          .map((file) => file.name)
          .toList(),
      environment: _environment,
      type: _selectedType!.name,
    );

    Modular.get<PagebuilderSectionTemplateUploadCubit>()
        .uploadTemplate(template);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<PagebuilderSectionTemplateUploadCubit>();

    return BlocConsumer<PagebuilderSectionTemplateUploadCubit,
        PagebuilderSectionTemplateUploadState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is PagebuilderSectionTemplateUploadSuccess) {
          CustomSnackBar.of(context).showCustomSnackBar(
            localization.admin_area_template_manager_success_message,
            SnackBarType.success,
          );
          setState(() {
            _jsonFile = null;
            _thumbnailFile = null;
            _assetFiles = [];
            _environment = "both";
            _selectedType = null;
          });
        } else if (state is PagebuilderSectionTemplateUploadFailure) {
          final errorMessage = DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization);
          CustomSnackBar.of(context).showCustomSnackBar(
            errorMessage,
            SnackBarType.failure,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PagebuilderSectionTemplateUploadLoading;

        return ListView(
          shrinkWrap: true,
          children: [
            CardContainer(
              maxWidth: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localization.admin_area_template_manager_upload_heading,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFilePicker(
                    label: localization
                        .admin_area_template_manager_section_json_label,
                    file: _jsonFile,
                    icon: Icons.code,
                    onPick: _pickJsonFile,
                    theme: theme,
                    localization: localization,
                  ),
                  const SizedBox(height: 16),
                  _buildFilePicker(
                    label:
                        localization.admin_area_template_manager_thumbnail_label,
                    file: _thumbnailFile,
                    icon: Icons.image,
                    onPick: _pickThumbnail,
                    theme: theme,
                    localization: localization,
                    isImage: true,
                  ),
                  const SizedBox(height: 16),
                  _buildAssetPicker(theme, localization),
                  const SizedBox(height: 16),
                  _buildTypeDropdown(theme, localization),
                  const SizedBox(height: 16),
                  _buildEnvironmentDropdown(theme, localization),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    title: localization.admin_area_template_manager_upload_button,
                    onTap: _uploadTemplate,
                    isLoading: isLoading,
                    width: 200,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilePicker({
    required String label,
    required PlatformFile? file,
    required IconData icon,
    required VoidCallback onPick,
    required ThemeData theme,
    required AppLocalizations localization,
    bool isImage = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (isImage && file?.bytes != null)
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: MemoryImage(file!.bytes!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              file?.name ??
                                  localization
                                      .admin_area_template_manager_file_picker_hint,
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (file != null)
                        Text(
                          "${(file.size / 1024).toStringAsFixed(1)} KB",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.upload_file,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetPicker(ThemeData theme, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.admin_area_template_manager_asset_images_label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _pickAssets,
              icon: const Icon(Icons.add_photo_alternate),
              label:
                  Text(localization.admin_area_template_manager_add_images_button),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_assetFiles.isEmpty)
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
            children: _assetFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
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
                      onTap: () => _removeAsset(index),
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
            hint: Text(localization.admin_area_template_manager_type_hint),
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
              DropdownMenuItem(
                value: SectionType.contact,
                child: Text(
                    localization.admin_area_template_manager_type_contact_form),
              ),
              DropdownMenuItem(
                value: SectionType.calendly,
                child:
                    Text(localization.admin_area_template_manager_type_calendly),
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
