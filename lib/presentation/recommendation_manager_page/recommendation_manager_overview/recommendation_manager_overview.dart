import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerOverview extends StatelessWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  const RecommendationManagerOverview(
      {super.key, required this.recommendations, required this.isPromoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CardContainer(
        maxWidth: 1200,
        child: Column(
          children: [
            SelectableText("Meine Empfehlungen",
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            RecommendationManagerList(
                recommendations: recommendations, isPromoter: isPromoter)
          ],
        ));
  }
}
