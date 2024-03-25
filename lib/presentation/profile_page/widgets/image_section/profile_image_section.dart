// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:finanzbegleiter/application/images/images_bloc.dart';
import 'package:finanzbegleiter/core/failures/storage_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageSection extends StatefulWidget {
  final CustomUser user;
  final Function imageUploadSuccessful;

  const ProfileImageSection(
      {Key? key, required this.user, required this.imageUploadSuccessful})
      : super(key: key);

  @override
  State<ProfileImageSection> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileImageSection> {
  final GlobalKey<_MyWidgetState> myWidgetKey = GlobalKey();
  bool hovered = false;
  bool isImageClickable = true;

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (context != null && context.mounted) {
      BlocProvider.of<ImagesBloc>(context).add(UploadImageTriggeredEvent(
          rawImage: image, userID: widget.user.id.value));
    }
  }

  String? _getImageUploadFailureMessage(
      ImagesState state, AppLocalizations localization) {
    if (state is ImageUploadFailureState) {
      return StorageFailureMapper.mapFailureMessage(
          state.failure, localization);
    } else if (state is ImageExceedsFileSizeLimitFailureState) {
      return "Sie haben die zulässige Maximalgröße von 5 MB überschritten";
    } else if (state is ImageIsNotValidFailureState) {
      return "Das ist kein gültiges Bildformat";
    } else if (state is ImageOnlyOneAllowedFailureState) {
      return "Du kannst nur ein Bild gleichzeitig hochladen";
    } else if (state is ImageUploadNotFoundFailureState) {
      return "Das Bild zum Hochladen wurde nicht gefunden";
    } else {
      return null;
    }
  }

  String _getImageThumbnailURL(ImagesState state, String? thumbnailURL) {
    if (state is ImageUploadSuccessState) {
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
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    const Size imageSize = Size(200, 200);

    return BlocConsumer<ImagesBloc, ImagesState>(
      listener: (context, state) {
        if (state is ImageUploadSuccessState) {
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
                  BlocProvider.of<ImagesBloc>(context).add(
                      UploadImageFromDropZoneTriggeredEvent(
                          files: [file], userID: widget.user.id.value));
                },
                onDroppedMultipleFiles: (files) {
                  setHovered(false);
                  BlocProvider.of<ImagesBloc>(context).add(
                      UploadImageFromDropZoneTriggeredEvent(
                          files: files, userID: widget.user.id.value));
                },
                onHover: () {
                  setHovered(true);
                },
                onLeave: () {
                  setHovered(false);
                },
                child: Stack(
                  key: myWidgetKey,
                  children: [
                    MouseRegion(
                      cursor: isImageClickable
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onTap: () async {
                          if (isImageClickable) {
                            final imageProvider = Image.network(
                                    widget.user.profileImageDownloadURL ?? "")
                                .image;
                            showImageViewer(context, imageProvider,
                                swipeDismissible: true,
                                doubleTapZoomable: true,
                                useSafeArea: true,
                                closeButtonTooltip: localization
                                    .profile_page_image_section_large_image_view_close_button_tooltip_title);
                          }
                        },
                        child: CachedNetworkImage(
                          width: imageSize.width,
                          height: imageSize.height,
                          imageUrl: _getImageThumbnailURL(
                              state, widget.user.thumbnailDownloadURL),
                          imageBuilder: (context, imageProvider) {
                            isImageClickable = true;
                            return Container(
                                decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 5,
                                  color: hovered
                                      ? themeData.colorScheme.secondary
                                      : Colors.transparent),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ));
                          },
                          placeholder: (context, url) {
                            return Stack(children: [
                              PlaceholderImage(
                                  imageSize: imageSize, hovered: hovered),
                              const LoadingIndicator()
                            ]);
                          },
                          errorWidget: (context, url, error) {
                            isImageClickable = false;
                            return PlaceholderImage(
                                imageSize: imageSize, hovered: hovered);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: ElevatedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor:
                                    themeData.colorScheme.secondary),
                            child: state is ImageUploadLoadingState
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Icon(Icons.add_a_photo,
                                    color: Colors.white)))
                  ],
                ),
              ),
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
