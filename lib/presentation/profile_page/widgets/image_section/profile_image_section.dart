// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/core/failures/storage_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/image_dropped_file.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageSection extends StatefulWidget {
  final CustomUser user;
  final Function imageUploadSuccessful;

  const ProfileImageSection(
      {super.key, required this.user, required this.imageUploadSuccessful});

  @override
  State<ProfileImageSection> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileImageSection> {
  final GlobalKey<_MyWidgetState> myWidgetKey = GlobalKey();
  bool hovered = false;

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (context != null && context.mounted) {
      BlocProvider.of<ProfileImageBloc>(context).add(UploadImageTriggeredEvent(
          rawImage: image,
          id: widget.user.id.value));
    }
  }

  void onDroppedFile(List<ImageDroppedFile> files) {
    BlocProvider.of<ProfileImageBloc>(context).add(
        UploadImageFromDropZoneTriggeredEvent(
            files: files,
            id: widget.user.id.value));
  }

  String? _getImageUploadFailureMessage(
      ProfileImageState state, AppLocalizations localization) {
    if (state is ProfileImageUploadFailureState) {
      return StorageFailureMapper.mapFailureMessage(
          state.failure, localization);
    } else if (state is ProfileImageExceedsFileSizeLimitFailureState) {
      return localization
          .profile_page_image_section_validation_exceededFileSize;
    } else if (state is ProfileImageIsNotValidFailureState) {
      return localization.profile_page_image_section_validation_not_valid;
    } else if (state is ProfileImageOnlyOneAllowedFailureState) {
      return localization.profile_page_image_section_only_one_allowed;
    } else if (state is ProfileImageUploadNotFoundFailureState) {
      return localization.profile_page_image_section_upload_not_found;
    } else {
      return null;
    }
  }

  String _getImageThumbnailURL(ProfileImageState state, String? thumbnailURL) {
    if (state is ProfileImageUploadSuccessState) {
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

    return BlocConsumer<ProfileImageBloc, ProfileImageState>(
      listener: (context, state) {
        if (state is ProfileImageUploadSuccessState) {
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
                          widget.user.profileImageDownloadURL ?? "",
                      thumbnailDownloadURL: _getImageThumbnailURL(
                          state, widget.user.thumbnailDownloadURL),
                      imageSize: imageSize,
                      hovered: hovered,
                      isLoading: state is ProfileImageUploadLoadingState,
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
