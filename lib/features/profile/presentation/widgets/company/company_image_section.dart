// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/images/application/company/company_image_bloc.dart';
import 'package:finanzbegleiter/core/failures/storage_failure_mapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_crop_dialog.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_section.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_dropped_file.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_upload_dropzone.dart'
    if (dart.library.io) 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_upload_dropzone_stub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class CompanyImageSection extends StatefulWidget {
  final Company company;
  final Function imageUploadSuccessful;

  const CompanyImageSection(
      {super.key, required this.company, required this.imageUploadSuccessful});

  @override
  State<CompanyImageSection> createState() => _CompanyImageSectionState();
}

class _CompanyImageSectionState extends State<CompanyImageSection> {
  final GlobalKey<_CompanyImageSectionState> myWidgetKey = GlobalKey();
  bool hovered = false;

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (context != null && context.mounted) {
      Modular.get<CompanyImageBloc>().add(
          UploadCompanyImageTriggeredEvent(
              rawImage: image, id: widget.company.id.value));
    }
  }

  void onDroppedFile(List<ImageDroppedFile> files) {
    Modular.get<CompanyImageBloc>().add(
        UploadCompanyImageFromDropZoneTriggeredEvent(
            files: files, id: widget.company.id.value));
  }

  String? _getImageUploadFailureMessage(
      CompanyImageState state, AppLocalizations localization) {
    if (state is CompanyImageUploadFailureState) {
      return StorageFailureMapper.mapFailureMessage(
          state.failure, localization);
    } else if (state is CompanyImageExceedsFileSizeLimitFailureState) {
      return localization
          .profile_page_image_section_validation_exceededFileSize;
    } else if (state is CompanyImageIsNotValidFailureState) {
      return localization.profile_page_image_section_validation_not_valid;
    } else if (state is CompanyImageOnlyOneAllowedFailureState) {
      return localization.profile_page_image_section_only_one_allowed;
    } else if (state is CompanyImageUploadNotFoundFailureState) {
      return localization.profile_page_image_section_upload_not_found;
    } else {
      return null;
    }
  }

  String _getImageThumbnailURL(CompanyImageState state, String? thumbnailURL) {
    if (state is CompanyImageUploadSuccessState) {
      return state.imageURL;
    } else if (thumbnailURL != null) {
      return thumbnailURL;
    } else {
      return "";
    }
  }

  void setHovered(bool isHovered) {
    setState(() {
      hovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    const Size imageSize = Size(120, 120);

    return BlocConsumer<CompanyImageBloc, CompanyImageState>(
      bloc: Modular.get<CompanyImageBloc>(),
      listener: (context, state) {
        if (state is CompanyImageUploadSuccessState) {
          widget.imageUploadSuccessful();
          PaintingBinding.instance.imageCache.clear();
        } else if (state is CompanyImageReadyToCropState) {
          final bloc = Modular.get<CompanyImageBloc>();
          showImageCropDialog(
            context,
            state.imageBytes,
            aspectRatio: 1.0,
            aspectRatioLabel: "1:1",
          ).then((croppedBytes) {
            if (croppedBytes != null) {
              bloc.add(CompanyImageContinueWithCroppedEvent(
                croppedBytes: croppedBytes,
                id: widget.company.id.value,
              ));
            } else {
              bloc.add(const CompanyImageCropCancelledEvent());
            }
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: imageSize.width,
              height: imageSize.height,
              child: ImageUploadDropzone(
                  onDroppedFile: (file) {
                    setHovered(false);
                    onDroppedFile([file]);
                  },
                  onHover: () {
                    setHovered(true);
                  },
                  onLeave: () {
                    setHovered(false);
                  },
                  child: ImageSection(
                      widgetKey: myWidgetKey,
                      imageDownloadURL:
                          widget.company.companyImageDownloadURL ?? "",
                      thumbnailDownloadURL: _getImageThumbnailURL(
                          state, widget.company.thumbnailDownloadURL),
                      imageSize: imageSize,
                      hovered: hovered,
                      isLoading: state is CompanyImageUploadLoadingState,
                      pickImage: () => _pickImage())),
            ),
            if (_getImageUploadFailureMessage(state, localization) != null) ...[
              const SizedBox(height: 20),
              FormErrorView(
                  message: _getImageUploadFailureMessage(state, localization)!)
            ]
          ],
        );
      },
    );
  }
}
