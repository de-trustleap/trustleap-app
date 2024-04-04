// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PromoterOverviewList extends StatelessWidget {
  final ScrollController controller;
  final List<Promoter> promoters;

  const PromoterOverviewList({
    Key? key,
    required this.controller,
    required this.promoters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: ListView.builder(
          itemCount: promoters.length,
          shrinkWrap: true,
          controller: controller,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 150),
              child: ScaleAnimation(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PromoterOverviewListTile(promoter: promoters[index]),
                ),
              ),
            );
          }),
    );
  }
}
