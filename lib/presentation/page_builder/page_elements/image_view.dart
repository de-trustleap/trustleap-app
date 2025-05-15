import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/network_image_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class PageBuilderImageView extends StatefulWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget? widgetModel;
  final bool isConfigMenu;
  final Function(PageBuilderImageProperties)? onSelectedInConfigMenu;

  const PageBuilderImageView(
      {super.key,
      required this.properties,
      required this.widgetModel,
      this.isConfigMenu = false,
      this.onSelectedInConfigMenu});

  @override
  State<PageBuilderImageView> createState() => _PageBuilderImageViewState();
}

class _PageBuilderImageViewState extends State<PageBuilderImageView> {
  final GlobalKey<_PageBuilderImageViewState> myWidgetKey = GlobalKey();
  final fileSizeLimit = 5000000;
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
        if (widget.isConfigMenu && widget.onSelectedInConfigMenu != null) {
          widget.onSelectedInConfigMenu!(
              widget.properties.copyWith(localImage: convertedTempImage));
        } else {
          if (widget.widgetModel != null) {
            final updatedProperties = widget.properties
                .copyWith(localImage: convertedTempImage, hasChanged: true);
            final updatedWidget =
                widget.widgetModel!.copyWith(properties: updatedProperties);
            Modular.get<PagebuilderBloc>()
                .add(UpdateWidgetEvent(updatedWidget));
          }
        }
      }
    }
  }

  void setHovered(bool isHovered) {
    setState(() {
      _hovered = isHovered;
    });
  }

  BoxFit _getBoxFit() {
    if (widget.isConfigMenu) {
      return BoxFit.cover;
    } else if (widget.properties.contentMode != null) {
      return widget.properties.contentMode!;
    } else {
      return BoxFit.cover;
    }
  }

  Widget _imageContainer(ImageProvider child) {
    return Container(
        width: widget.isConfigMenu ? 200 : widget.properties.width,
        height: widget.isConfigMenu ? 200 : widget.properties.height,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(widget.properties.borderRadius ?? 0),
            image: DecorationImage(fit: _getBoxFit(), image: child)));
  }

  Widget _imageElement(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return SizedBox(
      width: widget.isConfigMenu ? 200 : widget.properties.width,
      height: widget.isConfigMenu ? 200 : widget.properties.height,
      child: MouseRegion(
        onEnter: (event) => setHovered(true),
        onExit: (event) => setHovered(false),
        child: Stack(
          key: myWidgetKey,
          alignment: Alignment.center,
          children: [
            if (widget.properties.localImage != null) ...[
              _imageContainer(MemoryImage(widget.properties.localImage!))
            ] else if (widget.properties.url != null) ...[
              NetworkImageView(
                imageURL: widget.properties.url!,
                cornerRadius:
                    widget.isConfigMenu ? 0 : widget.properties.borderRadius,
                width: widget.isConfigMenu ? 200 : widget.properties.width,
                height: widget.isConfigMenu ? 200 : widget.properties.height,
                contentMode: _getBoxFit(),
              )
            ] else ...[
              Container(
                width: widget.isConfigMenu ? 200 : widget.properties.width,
                height: widget.isConfigMenu ? 200 : widget.properties.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/placeholder.png"),
                  ),
                ),
              )
            ],
            if (!widget.isConfigMenu &&
                widget.properties.overlayColor != null) ...[
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                      widget.properties.borderRadius ?? 0),
                  child: Container(
                      color: widget.properties.overlayColor,
                      width: widget.properties.width,
                      height: widget.properties.height))
            ],
            if (_hovered) ...[
              Container(
                width: widget.isConfigMenu ? 200 : widget.properties.width,
                height: widget.isConfigMenu ? 200 : widget.properties.height,
                alignment: Alignment.center,
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Tooltip(
                    message: localization.profile_image_upload_tooltip,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: themeData.colorScheme.secondary,
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.widgetModel != null) {
      return widget.isConfigMenu
          ? _imageElement(context)
          : LandingPageBuilderWidgetContainer(
              model: widget.widgetModel!, child: _imageElement(context));
    } else {
      return _imageElement(context);
    }
  }
}
