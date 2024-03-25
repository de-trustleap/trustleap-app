// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class PromotersOverviewGridTile extends StatelessWidget {
  final Promoter promoter;

  const PromotersOverviewGridTile({
    Key? key,
    required this.promoter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (promoter.registered != null && promoter.registered!) ...[
            CachedNetworkImage(
              width: responsiveValue.largerThan(MOBILE) ? 150 : 140,
              height: responsiveValue.largerThan(MOBILE) ? 150 : 140,
              imageUrl: promoter.thumbnailDownloadURL ?? "",
              imageBuilder: (context, imageProvider) {
                return Container(
                    decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
          ] else ...[
            placeHolderImage(responsiveValue)
          ],
          const SizedBox(height: 8),
          Text(promoter.firstName ?? "",
              style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(promoter.lastName ?? "",
              style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16))
        ]);
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 150 : 140,
            responsiveValue.largerThan(MOBILE) ? 150 : 140),
        hovered: false);
  }
}
