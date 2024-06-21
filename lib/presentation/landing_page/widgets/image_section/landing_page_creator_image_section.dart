// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/image_dropped_file.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LandingPageCreatorImageSection extends StatefulWidget {
  final LandingPage? landingPage;
  final UniqueID id;
  final Company? company;
  final Function(Uint8List?) imageSelected;

  const LandingPageCreatorImageSection(
      {super.key,
      this.landingPage,
      required this.id,
      this.company,
      required this.imageSelected});

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

  @override
  void didUpdateWidget(covariant LandingPageCreatorImageSection oldWidget) {
    _downloadCompanyImageFromURL();
    super.didUpdateWidget(oldWidget);
  }

  bool _urlIsValid(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final convertedTempImage = await image.readAsBytes();
      setState(() {
        _convertedImage = convertedTempImage;
        widget.imageSelected(_convertedImage);
      });
    }
  }

  _downloadCompanyImageFromURL() async {
    if (widget.company?.companyImageDownloadURL != null &&
        _urlIsValid(widget.company!.companyImageDownloadURL!) &&
        _convertedImage == null) {
      http.Response response =
          await http.get(Uri.parse(widget.company!.companyImageDownloadURL!));
      _convertedImage = response.bodyBytes;
      widget.imageSelected(_convertedImage);
    }
  }

  void onDroppedFile(List<ImageDroppedFile> files) {
    setState(() {
      _convertedImage = files.first.data;
      widget.imageSelected(_convertedImage);
    });
  }

  String _getImageThumbnailURL(
      LandingPageImageState state, String? thumbnailURL) {
    if (state is LandingPageImageUploadSuccessState) {
      return state.imageURL;
    } else if (thumbnailURL != null) {
      return thumbnailURL;
    } else if (widget.company?.companyImageDownloadURL != null) {
      return widget.company!.companyImageDownloadURL!;
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
    const Size imageSize = Size(200, 200);

    return BlocConsumer<LandingPageImageBloc, LandingPageImageState>(
      listener: (context, state) {
        if (state is LandingPageImageUploadSuccessState) {
          //widget.imageUploadSuccessful();
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
          ],
        );
      },
    );
  }
}
