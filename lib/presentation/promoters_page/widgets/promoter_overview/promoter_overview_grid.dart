// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/animated_tile_grid.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';

class PromoterOverviewGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Promoter> promoters;
  final Function(String, bool) deletePressed;

  const PromoterOverviewGrid({
    super.key,
    required this.controller,
    required this.promoters,
    required this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTileGrid(
      itemCount: promoters.length,
      gridName: 'promoter-grid',
      scrollController: controller,
      itemBuilder: (index, tileWidth, tileHeight) {
        return PromotersOverviewGridTile(
          promoter: promoters[index],
          deletePressed: deletePressed,
        );
      },
    );
  }
}
