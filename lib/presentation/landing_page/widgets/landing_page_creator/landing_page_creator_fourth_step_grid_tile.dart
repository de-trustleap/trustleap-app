import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorFourthStepGridTile extends StatefulWidget {
  final LandingPageTemplate template;
  final bool isSelected;
  final bool disabled;
  final VoidCallback onTap;

  const LandingPageCreatorFourthStepGridTile(
      {super.key,
      required this.template,
      required this.isSelected,
      required this.onTap,
      this.disabled = false});

  @override
  State<LandingPageCreatorFourthStepGridTile> createState() =>
      _LandingPageCreatorThirdStepGridTileState();
}

class _LandingPageCreatorThirdStepGridTileState
    extends State<LandingPageCreatorFourthStepGridTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: MouseRegion(
        cursor: widget.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.disabled) {
            setState(() {
              _isHovered = true;
            });
          }
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: AnimatedScale(
            scale: _isHovered && !widget.disabled ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                  color: themeData.colorScheme.surface,
                  border: Border.all(
                      color: widget.isSelected
                          ? themeData.colorScheme.secondary
                          : Colors.transparent,
                      width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      width: responsiveValue.largerThan(MOBILE) ? 130 : 140,
                      height: responsiveValue.largerThan(MOBILE) ? 130 : 140,
                      imageUrl: widget.template.thumbnailDownloadURL ?? "",
                      imageBuilder: (context, imageProvider) {
                        return Container(
                            decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ));
                      },
                      placeholder: (context, url) {
                        return Stack(children: [
                          placeHolderImage(responsiveValue),
                          const LoadingIndicator()
                        ]);
                      },
                      errorWidget: (context, url, error) {
                        return placeHolderImage(responsiveValue);
                      },
                    ),
                    const SizedBox(height: 16),
                    SelectableText(widget.template.name ?? "",
                        style: themeData.textTheme.bodySmall!
                            .copyWith(overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                        maxLines: 2)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 120 : 140,
            responsiveValue.largerThan(MOBILE) ? 120 : 140),
        hovered: false);
  }
}
