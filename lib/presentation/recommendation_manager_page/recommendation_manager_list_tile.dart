import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTile extends StatelessWidget {
  const RecommendationManagerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CollapsibleTile(
      backgroundColor: themeData.colorScheme.surface,
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: "Empfehlung von ",
                  style: themeData.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "Hans Test",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  text: "Letztes Update: ",
                  style: themeData.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "23.03.2025",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8)
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: "Status: ",
              style: themeData.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: "Link geklickt",
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      children: [const Text("Test")],
    );
  }
}
