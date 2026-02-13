import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AnimatedTileGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index, double tileWidth, double? tileHeight)
      itemBuilder;
  final String gridName;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final double desktopTileWidth;
  final double? desktopAspectRatio;
  final double? mobileAspectRatio;
  final int mobileColumnCount;

  const AnimatedTileGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridName,
    this.scrollController,
    this.shrinkWrap = false,
    this.desktopTileWidth = 200,
    this.desktopAspectRatio,
    this.mobileAspectRatio,
    this.mobileColumnCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveHelper.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      final double horizontalSpacing =
          responsiveValue.largerThan(MOBILE) ? 24 : 12;
      final double verticalSpacing =
          responsiveValue.largerThan(MOBILE) ? 24 : 12;

      double tileWidth;
      double? aspectRatio;
      int columnsCount;

      if (responsiveValue.isMobile) {
        columnsCount = mobileColumnCount;
        final double availableWidth = constraints.maxWidth;
        final double totalSpacing = horizontalSpacing * (columnsCount - 1);
        tileWidth = (availableWidth - totalSpacing) / columnsCount;
        aspectRatio = mobileAspectRatio;
      } else {
        tileWidth = desktopTileWidth;
        aspectRatio = desktopAspectRatio;
        columnsCount = (constraints.maxWidth / (tileWidth + horizontalSpacing))
            .floor()
            .clamp(1, double.infinity)
            .toInt();
      }

      final double? tileHeight =
          aspectRatio != null ? tileWidth / aspectRatio : null;

      final wrap = Wrap(
        spacing: horizontalSpacing,
        runSpacing: verticalSpacing,
        children: List.generate(itemCount, (index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 150),
            columnCount: columnsCount,
            child: ScaleAnimation(
              child: tileHeight != null
                  ? SizedBox(
                      width: tileWidth,
                      height: tileHeight,
                      child: itemBuilder(index, tileWidth, tileHeight),
                    )
                  : IntrinsicHeight(
                      child: SizedBox(
                        width: tileWidth,
                        child: itemBuilder(index, tileWidth, null),
                      ),
                    ),
            ),
          );
        }),
      );

      return AnimationLimiter(
        key: ValueKey(
            '$gridName-${responsiveValue.isMobile}-$columnsCount-${tileWidth.toInt()}'),
        child: shrinkWrap
            ? wrap
            : SingleChildScrollView(
                controller: scrollController,
                child: wrap,
              ),
      );
    });
  }
}
