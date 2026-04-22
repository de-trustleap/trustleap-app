import "dart:typed_data";

import "package:finanzbegleiter/features/landing_pages/application/landing_page_creator/landing_page_creator_cubit.dart";
import "package:finanzbegleiter/features/profile/domain/company.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page.dart";
import "package:finanzbegleiter/features/landing_pages/domain/landing_page_image_data.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_crop_dialog.dart";
import "package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_creator_image_picker_box.dart";
import "package:finanzbegleiter/l10n/generated/app_localizations.dart";
import "package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/tooltip_buttons/info_button.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_upload_dropzone.dart"
    if (dart.library.io) "package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_upload_dropzone_stub.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";
import "package:responsive_framework/responsive_framework.dart";

class LandingPageCreatorFourthStep extends StatefulWidget {
  final LandingPage? landingPage;
  final LandingPageImageData imageData;
  final Company? company;
  final bool buttonsDisabled;
  final bool isLoading;
  final bool isEditMode;
  final Function(LandingPage) onBack;
  final Function(LandingPage, LandingPageImageData) onContinue;

  const LandingPageCreatorFourthStep({
    super.key,
    required this.landingPage,
    required this.imageData,
    this.company,
    required this.buttonsDisabled,
    required this.isLoading,
    required this.isEditMode,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<LandingPageCreatorFourthStep> createState() =>
      _LandingPageCreatorFourthStepState();
}

class _LandingPageCreatorFourthStepState
    extends State<LandingPageCreatorFourthStep> {
  final double _shareImageAspectRatio = 1.91;

  Uint8List? _faviconBytes;
  bool _faviconHasChanged = false;
  bool _faviconHovered = false;

  Uint8List? _shareImageBytes;
  bool _shareImageHasChanged = false;
  bool _shareImageHovered = false;
  String? _selectedShareTemplateUrl;

  final GlobalKey _faviconKey = GlobalKey();
  final GlobalKey _shareImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _faviconBytes = widget.imageData.faviconImage;
    _faviconHasChanged = widget.imageData.faviconImageHasChanged;
    _shareImageBytes = widget.imageData.shareImage;
    _shareImageHasChanged = widget.imageData.shareImageHasChanged;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<LandingPageCreatorCubit>().loadShareImageTemplates();
    });
  }

  Future<void> _cropAndSetFavicon(Uint8List bytes) async {
    final cropped = await showImageCropDialog(
      context,
      bytes,
      aspectRatio: 1.0,
      aspectRatioLabel: "1:1",
    );
    if (cropped != null && mounted) {
      setState(() {
        _faviconBytes = cropped;
        _faviconHasChanged = true;
        _faviconHovered = false;
      });
    }
  }

  Future<void> _cropAndSetShareImage(Uint8List bytes) async {
    final cropped = await showImageCropDialog(
      context,
      bytes,
      aspectRatio: _shareImageAspectRatio,
      aspectRatioLabel: "1.91:1",
    );
    if (cropped != null && mounted) {
      setState(() {
        _shareImageBytes = cropped;
        _shareImageHasChanged = true;
        _selectedShareTemplateUrl = null;
        _shareImageHovered = false;
      });
    }
  }

  Future<void> _pickFavicon() async {
    final picker = ImagePicker();
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (file != null) {
      final bytes = await file.readAsBytes();
      if (mounted) await _cropAndSetFavicon(bytes);
    }
  }

  Future<void> _pickShareImage() async {
    final picker = ImagePicker();
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (file != null) {
      final bytes = await file.readAsBytes();
      if (mounted) await _cropAndSetShareImage(bytes);
    }
  }

  Future<void> _selectShareImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (mounted) await _cropAndSetShareImage(response.bodyBytes);
    } catch (_) {}
  }

  Future<void> _selectFaviconFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (mounted) await _cropAndSetFavicon(response.bodyBytes);
    } catch (_) {}
  }

  void _onContinue() {
    if (widget.landingPage != null) {
      widget.onContinue(
        widget.landingPage!,
        widget.imageData.copyWith(
          faviconImage: _faviconBytes,
          faviconImageHasChanged: _faviconHasChanged,
          shareImage: _shareImageBytes,
          shareImageHasChanged: _shareImageHasChanged,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final creatorCubit = Modular.get<LandingPageCreatorCubit>();

    return BlocBuilder<LandingPageCreatorCubit, LandingPageCreatorDataState>(
      bloc: creatorCubit,
      builder: (context, creatorState) {
        final shareTemplateUrls = creatorState.shareImageTemplateUrls ?? [];
        final companyImageUrl = widget.company?.companyImageDownloadURL;
        final shareOutpaintedUrl = widget.company?.companyShareOutpaintedImageUrl ?? companyImageUrl;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              CenteredConstrainedWrapper(
                child: CardContainer(
                  maxWidth: 800,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          widget.isEditMode
                              ? localization.landingpage_creation_edit_button_text
                              : localization.landingpage_create_txt,
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),

                        // ── Favicon ───────────────────────────────────────
                        Row(
                          children: [
                            SelectableText(
                              localization.landingpage_creator_favicon_section_title,
                              style: themeData.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            InfoButton(text: localization.landingpage_creator_favicon_info_tooltip),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: ImageUploadDropzone(
                            onDroppedFile: (file) =>
                                _cropAndSetFavicon(file.data),
                            onHover: () =>
                                setState(() => _faviconHovered = true),
                            onLeave: () =>
                                setState(() => _faviconHovered = false),
                            child: LandingPageCreatorImagePickerBox(
                              key: _faviconKey,
                              size: const Size(160, 160),
                              imageBytes: _faviconBytes,
                              imageUrl: widget.isEditMode &&
                                      _faviconBytes == null
                                  ? widget.landingPage?.faviconUrl
                                  : null,
                              hovered: _faviconHovered,
                              onTap: _pickFavicon,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          localization.landingpage_creator_favicon_crop_hint,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (companyImageUrl != null) ...[
                          const SizedBox(height: 16),
                          SelectableText(
                            localization.landingpage_creator_share_image_templates_label,
                            style: themeData.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          _SelectableThumbnail(
                            imageUrl: companyImageUrl,
                            size: const Size(80, 80),
                            isSelected: false,
                            onTap: () => _selectFaviconFromUrl(companyImageUrl),
                          ),
                        ],
                        const SizedBox(height: 40),

                        // ── Share-Bild ────────────────────────────────────
                        Row(
                          children: [
                            SelectableText(
                              localization.landingpage_creator_share_image_section_title,
                              style: themeData.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            InfoButton(text: localization.landingpage_creator_share_image_info_tooltip),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: maxWidth,
                          height: (maxWidth / _shareImageAspectRatio)
                              .clamp(0.0, 240.0),
                          child: ImageUploadDropzone(
                            onDroppedFile: (file) =>
                                _cropAndSetShareImage(file.data),
                            onHover: () =>
                                setState(() => _shareImageHovered = true),
                            onLeave: () =>
                                setState(() => _shareImageHovered = false),
                            child: LandingPageCreatorImagePickerBox(
                              key: _shareImageKey,
                              size: Size(maxWidth,
                                  (maxWidth / _shareImageAspectRatio).clamp(0.0, 240.0)),
                              imageBytes: _shareImageBytes,
                              imageUrl: widget.isEditMode &&
                                      _shareImageBytes == null
                                  ? widget.landingPage?.shareImageUrl
                                  : null,
                              hovered: _shareImageHovered,
                              onTap: _pickShareImage,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          localization.landingpage_creator_share_image_crop_hint,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (shareOutpaintedUrl != null ||
                            shareTemplateUrls.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          SelectableText(
                            localization
                                .landingpage_creator_share_image_templates_label,
                            style: themeData.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (shareOutpaintedUrl != null)
                                  _SelectableThumbnail(
                                    imageUrl: shareOutpaintedUrl,
                                    size: const Size(120, 120),
                                    isSelected:
                                        _selectedShareTemplateUrl ==
                                            shareOutpaintedUrl,
                                    onTap: () =>
                                        _selectShareImageFromUrl(shareOutpaintedUrl),
                                  ),
                                ...shareTemplateUrls.map((url) => Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: _SelectableThumbnail(
                                        imageUrl: url,
                                        size: const Size(120, 120),
                                        isSelected:
                                            _selectedShareTemplateUrl == url,
                                        onTap: () =>
                                            _selectShareImageFromUrl(url),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 48),
                        ResponsiveRowColumn(
                          rowMainAxisAlignment: MainAxisAlignment.center,
                          layout: responsiveValue.largerThan(MOBILE)
                              ? ResponsiveRowColumnType.ROW
                              : ResponsiveRowColumnType.COLUMN,
                          children: [
                            ResponsiveRowColumnItem(
                              child: SecondaryButton(
                                title: localization
                                    .landingpage_creation_back_button_text,
                                disabled: widget.buttonsDisabled,
                                width: responsiveValue.isMobile
                                    ? maxWidth - 20
                                    : maxWidth / 2 - 20,
                                onTap: () {
                                  if (widget.landingPage != null) {
                                    widget.onBack(widget.landingPage!);
                                  }
                                },
                              ),
                            ),
                            const ResponsiveRowColumnItem(
                              child: SizedBox(width: 20, height: 20),
                            ),
                            ResponsiveRowColumnItem(
                              child: PrimaryButton(
                                title: widget.isEditMode
                                    ? localization
                                        .landingpage_creation_edit_button_text
                                    : localization.landingpage_creation_continue,
                                disabled: widget.buttonsDisabled,
                                isLoading: widget.isLoading,
                                width: responsiveValue.isMobile
                                    ? maxWidth - 20
                                    : maxWidth / 2 - 20,
                                onTap: _onContinue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectableThumbnail extends StatelessWidget {
  final String imageUrl;
  final Size size;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableThumbnail({
    required this.imageUrl,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? themeData.colorScheme.secondary
                  : themeData.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
