// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/core/failures/storage_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/image_dropped_file.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class LandingPageCreatorImageSection extends StatefulWidget {
  final LandingPage? landingPage;
  final Function imageSelected;
  final Function imageUploadSuccessful;

  const LandingPageCreatorImageSection(
      {super.key,
      this.landingPage,
      required this.imageSelected,
      required this.imageUploadSuccessful});

  @override
  State<LandingPageCreatorImageSection> createState() =>
      _LandingPageCreatorImageSectionState();
}

class _LandingPageCreatorImageSectionState
    extends State<LandingPageCreatorImageSection> {
  final GlobalKey<_LandingPageCreatorImageSectionState> myWidgetKey =
      GlobalKey();
  bool hovered = false;
  Uint8List? _convertedImage;
  List<ImageDroppedFile>?
      _droppedFiles; // TODO: Muss auch zu Uint8List umgewandelt werden und in _convertedImage abgelegt werden.

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final convertedTempImage = await image.readAsBytes();
      setState(() {
        _convertedImage = convertedTempImage;
      });      
    }
  }

  void onDroppedFile(List<ImageDroppedFile> files) {
    setState(() {
      _convertedImage = files.first.data;
    });
  }

  String? _getImageUploadFailureMessage(
      LandingPageImageState state, AppLocalizations localization) {
    if (state is LandingPageImageUploadFailureState) {
      return StorageFailureMapper.mapFailureMessage(
          state.failure, localization);
    } else if (state is LandingPageImageExceedsFileSizeLimitFailureState) {
      return localization
          .profile_page_image_section_validation_exceededFileSize;
    } else if (state is LandingPageImageIsNotValidFailureState) {
      return localization.profile_page_image_section_validation_not_valid;
    } else if (state is LandingPageImageOnlyOneAllowedFailureState) {
      return localization.profile_page_image_section_only_one_allowed;
    } else if (state is LandingPageImageUploadNotFoundFailureState) {
      return localization.profile_page_image_section_upload_not_found;
    } else {
      return null;
    }
  }

  String _getImageThumbnailURL(
      LandingPageImageState state, String? thumbnailURL) {
    if (state is LandingPageImageUploadSuccessState) {
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
    const Size imageSize = Size(200, 200);

    return BlocConsumer<LandingPageImageBloc, LandingPageImageState>(
      listener: (context, state) {
        if (state is LandingPageImageUploadSuccessState) {
          widget.imageUploadSuccessful();
          PaintingBinding.instance.imageCache.clear();
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
                  onDroppedMultipleFiles: (files) {
                    setHovered(false);
                    onDroppedFile(files);
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
                          widget.landingPage?.downloadImageUrl ?? "",
                      thumbnailDownloadURL: _getImageThumbnailURL(
                          state, widget.landingPage?.thumbnailDownloadURL),
                      imageSize: imageSize,
                      hovered: hovered,
                      imageBytes: _convertedImage,
                      isLoading: state is LandingPageImageUploadLoadingState,
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
