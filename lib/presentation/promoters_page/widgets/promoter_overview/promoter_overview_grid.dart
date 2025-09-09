// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Promoter> promoters;
  final Function(String, bool) deletePressed;

  const PromoterOverviewGrid(
      {super.key,
      required this.controller,
      required this.promoters,
      required this.deletePressed});

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 1000),
      child: LayoutBuilder(builder: (context, constraints) {
        final double horizontalSpacing =
            responsiveValue.largerThan(MOBILE) ? 24 : 12;
        final double verticalSpacing =
            responsiveValue.largerThan(MOBILE) ? 24 : 12;

        double tileWidth;
        double aspectRatio;
        int columnsCount;

        if (responsiveValue.isMobile) {
          columnsCount = 2;
          final double availableWidth = constraints.maxWidth;
          final double totalSpacing = horizontalSpacing * (columnsCount - 1);
          tileWidth = (availableWidth - totalSpacing) / columnsCount;
          aspectRatio = 0.5;
        } else {
          tileWidth = 200;
          aspectRatio = 0.64;
          columnsCount =
              (constraints.maxWidth / (tileWidth + horizontalSpacing))
                  .floor()
                  .clamp(1, double.infinity)
                  .toInt();
        }

        return AnimationLimiter(
          key: ValueKey('promoter-grid-${responsiveValue.isMobile}'),
          child: SingleChildScrollView(
            controller: controller,
            child: Wrap(
              spacing: horizontalSpacing,
              runSpacing: verticalSpacing,
              children: promoters.asMap().entries.map((entry) {
                int index = entry.key;
                Promoter promoter = entry.value;

                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 150),
                  columnCount: columnsCount,
                  child: ScaleAnimation(
                    child: SizedBox(
                      width: tileWidth,
                      height: tileWidth / aspectRatio,
                      child: PromotersOverviewGridTile(
                          promoter: promoter, deletePressed: deletePressed),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
