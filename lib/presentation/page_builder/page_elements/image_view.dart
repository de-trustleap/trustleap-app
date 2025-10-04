import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/network_image_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  BoxFit _getBoxFit(PagebuilderResponsiveBreakpoint breakpoint) {
    if (widget.isConfigMenu) {
      return BoxFit.cover;
    } else if (widget.properties.contentMode != null) {
      return widget.properties.contentMode!.getValueForBreakpoint(breakpoint) ??
          BoxFit.cover;
    } else {
      return BoxFit.cover;
    }
  }

  double? _getWidth(PagebuilderResponsiveBreakpoint breakpoint) {
    if (widget.isConfigMenu) return 200;
    return widget.properties.width?.getValueForBreakpoint(breakpoint);
  }

  double? _getHeight(PagebuilderResponsiveBreakpoint breakpoint) {
    if (widget.isConfigMenu) return 200;
    return widget.properties.height?.getValueForBreakpoint(breakpoint);
  }

  Widget _imageContainer(
      ImageProvider child, PagebuilderResponsiveBreakpoint breakpoint) {
    return Container(
        width: _getWidth(breakpoint),
        height: _getHeight(breakpoint),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(widget.properties.borderRadius ?? 0),
            image: DecorationImage(fit: _getBoxFit(breakpoint), image: child)));
  }

  Widget _imageElement(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        final width = _getWidth(breakpoint);
        final height = _getHeight(breakpoint);
        final boxFit = _getBoxFit(breakpoint);

        return SizedBox(
          width: width,
          height: height,
          child: MouseRegion(
            onEnter: (event) => setHovered(true),
            onExit: (event) => setHovered(false),
            child: Stack(
              key: myWidgetKey,
              alignment: Alignment.center,
              children: [
                if (widget.properties.localImage != null) ...[
                  _imageContainer(
                      MemoryImage(widget.properties.localImage!), breakpoint)
                ] else if (widget.properties.url != null) ...[
                  NetworkImageView(
                    imageURL: widget.properties.url!,
                    cornerRadius:
                        widget.isConfigMenu ? 0 : widget.properties.borderRadius,
                    width: width,
                    height: height,
                    contentMode: boxFit,
                  )
                ] else ...[
                  Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/placeholder.png"),
                      ),
                    ),
                  )
                ],
                if (!widget.isConfigMenu &&
                    widget.properties.overlayPaint != null) ...[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(
                          widget.properties.borderRadius ?? 0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  widget.properties.borderRadius ?? 0),
                              color:
                                  widget.properties.overlayPaint?.isColor == true
                                      ? widget.properties.overlayPaint?.color
                                      : null,
                              gradient: widget.properties.overlayPaint
                                          ?.isGradient ==
                                      true
                                  ? widget.properties.overlayPaint?.gradient
                                      ?.toFlutterGradient()
                                  : null),
                          width: width,
                          height: height))
                ],
                if (_hovered) ...[
                  Container(
                    width: width,
                    height: height,
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
      },
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
