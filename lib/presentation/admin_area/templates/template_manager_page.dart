import 'package:file_picker/file_picker.dart';
import 'package:finanzbegleiter/application/pagebuilder_section_template_upload/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TemplateManagerPage extends StatelessWidget {
  const TemplateManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CenteredConstrainedWrapper(
        child: TemplateManagerContent(),
      ),
    );
  }
}

class TemplateManagerContent extends StatefulWidget {
  const TemplateManagerContent({super.key});

  @override
  State<TemplateManagerContent> createState() => _TemplateManagerContentState();
}

class _TemplateManagerContentState extends State<TemplateManagerContent> {
  // Form state
  PlatformFile? _jsonFile;
  PlatformFile? _thumbnailFile;
  List<PlatformFile> _assetFiles = [];
  String _environment = 'both';
  SectionType? _selectedType;

  Future<void> _pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
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
    if (_jsonFile == null || _thumbnailFile == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        'Bitte wähle mindestens JSON und Thumbnail aus',
        SnackBarType.failure,
      );
      return;
    }

    if (_selectedType == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        'Bitte wähle einen Type aus',
        SnackBarType.failure,
      );
      return;
    }

    if (_jsonFile!.bytes == null || _thumbnailFile!.bytes == null) {
      CustomSnackBar.of(context).showCustomSnackBar(
        'Fehler beim Lesen der Dateien',
        SnackBarType.failure,
      );
      return;
    }

    // Create template upload entity
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

    // Upload using cubit
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
            'Template erfolgreich hochgeladen!',
            SnackBarType.success,
          );
          // Reset form
          setState(() {
            _jsonFile = null;
            _thumbnailFile = null;
            _assetFiles = [];
            _environment = 'both';
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
              // Header
              Row(
                children: [
                  Icon(
                    Icons.dashboard_customize,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Template Manager',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Section Templates für den Pagebuilder hochladen',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Upload Section Header
              Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Section Template hochladen',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upload Form
              // JSON File Picker
              _buildFilePicker(
                label: 'Section JSON',
                file: _jsonFile,
                icon: Icons.code,
                onPick: _pickJsonFile,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // Thumbnail Picker
              _buildFilePicker(
                label: 'Thumbnail',
                file: _thumbnailFile,
                icon: Icons.image,
                onPick: _pickThumbnail,
                theme: theme,
                isImage: true,
              ),
              const SizedBox(height: 16),

              // Asset Images Picker
              _buildAssetPicker(theme),
              const SizedBox(height: 16),

              // Type Dropdown
              _buildTypeDropdown(theme),
              const SizedBox(height: 16),

              // Environment Dropdown
              _buildEnvironmentDropdown(theme),
              const SizedBox(height: 32),

              // Upload Button
              PrimaryButton(
                title: 'Template hochladen',
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
                              file?.name ?? 'Datei auswählen...',
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (file != null)
                        Text(
                          '${(file.size / 1024).toStringAsFixed(1)} KB',
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

  Widget _buildAssetPicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Asset Images',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _pickAssets,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Bilder hinzufügen'),
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
                'Keine Assets ausgewählt',
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

  Widget _buildTypeDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section Type',
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
            hint: const Text('Type auswählen...'),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: SectionType.hero,
                child: Text('Hero'),
              ),
              DropdownMenuItem(
                value: SectionType.product,
                child: Text('Produkt'),
              ),
              DropdownMenuItem(
                value: SectionType.about,
                child: Text('Über'),
              ),
              DropdownMenuItem(
                value: SectionType.callToAction,
                child: Text('Call To Action'),
              ),
              DropdownMenuItem(
                value: SectionType.advantages,
                child: Text('Vorteile'),
              ),
              DropdownMenuItem(
                value: SectionType.footer,
                child: Text('Footer'),
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

  Widget _buildEnvironmentDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Environment',
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
          items: const [
            DropdownMenuItem(
              value: 'both',
              child: Text('Staging & Production'),
            ),
            DropdownMenuItem(
              value: 'staging',
              child: Text('Staging only'),
            ),
            DropdownMenuItem(
              value: 'prod',
              child: Text('Production only'),
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
