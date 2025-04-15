import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerOverview extends StatelessWidget {
  const RecommendationManagerOverview({super.key});

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
            const RecommendationManagerList()
          ],
        ));
  }
}
