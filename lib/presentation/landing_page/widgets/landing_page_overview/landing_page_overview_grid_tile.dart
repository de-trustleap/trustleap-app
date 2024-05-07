// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGridTile extends StatelessWidget {
  final LandingPage landingPage;

  const LandingPageOverviewGridTile({
    super.key,
    required this.landingPage,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
      height: responsiveValue.largerThan(MOBILE) ? 300 : 300,
      decoration: BoxDecoration(
          color: themeData.colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                width: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                height: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                imageUrl: landingPage.thumbnailDownloadURL ?? "",
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
              const SizedBox(height: 4),
              Text(landingPage.name ?? "",
                  style: themeData.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          )),
    );
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 120 : 140,
            responsiveValue.largerThan(MOBILE) ? 120 : 140),
        hovered: false);
  }
}
