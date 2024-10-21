import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/network_image_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class PageBuilderImageView extends StatefulWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderImageView(
      {super.key, required this.properties, required this.widgetModel});

  @override
  State<PageBuilderImageView> createState() => _PageBuilderImageViewState();
}

class _PageBuilderImageViewState extends State<PageBuilderImageView> {
  final GlobalKey<_PageBuilderImageViewState> myWidgetKey = GlobalKey();
  final fileSizeLimit = 5000000;
  Uint8List? _selectedImage;
  bool _hovered = false;

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final convertedTempImage = await image.readAsBytes();
      if (convertedTempImage.lengthInBytes > fileSizeLimit) {
        if (context != null && context.mounted) {
          CustomSnackBar.of(context).showCustomSnackBar(
              AppLocalizations.of(context)
                  .landingpage_pagebuilder_image_upload_exceeds_file_size_error,
              SnackBarType.failure);
        }
      } else {
        setState(() {
          _selectedImage = convertedTempImage;
        });
        final updatedProperties = widget.properties
            .copyWith(localImage: convertedTempImage, hasChanged: true);
        final updatedWidget =
            widget.widgetModel.copyWith(properties: updatedProperties);
        Modular.get<PagebuilderCubit>().updateWidget(updatedWidget);
      }
    }
  }

  void setHovered(bool isHovered) {
    setState(() {
      _hovered = isHovered;
    });
  }

  Widget _imageContainer(ImageProvider child) {
    return Container(
        width: widget.properties.width,
        height: widget.properties.height,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(widget.properties.borderRadius ?? 0),
            image: DecorationImage(fit: BoxFit.cover, image: child)));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return LandingPageBuilderWidgetContainer(
      model: widget.widgetModel,
      child: SizedBox(
        width: widget.properties.width,
        height: widget.properties.height,
        child: MouseRegion(
            onEnter: (event) => setHovered(true),
            onExit: (event) => setHovered(false),
            child: Stack(
                key: myWidgetKey,
                alignment: widget.properties.alignment ?? Alignment.center,
                children: [
                  if (_selectedImage != null) ...[
                    _imageContainer(MemoryImage(_selectedImage!))
                  ] else if (widget.properties.url != null) ...[
                    NetworkImageView(
                        imageURL: widget.properties.url!,
                        cornerRadius: widget.properties.borderRadius,
                        width: widget.properties.width,
                        height: widget.properties.height)
                  ] else ...[
                    Container(
                      width: widget.properties.width,
                      height: widget.properties.height,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(kDebugMode
                                  ? "images/placeholder.png"
                                  : "assets/images/placeholder.png"))),
                    )
                  ],
                  if (_hovered) ...[
                    Container(
                        width: widget.properties.width,
                        height: widget.properties.height,
                        alignment:
                            widget.properties.alignment ?? Alignment.center,
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                            child: Tooltip(
                          message: localization.profile_image_upload_tooltip,
                          child: ElevatedButton(
                              onPressed: () {
                                _pickImage();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor:
                                      themeData.colorScheme.secondary),
                              child: const Icon(Icons.add_a_photo,
                                  color: Colors.white)),
                        ))),
                  ]
                ])),
      ),
    );
  }
}
