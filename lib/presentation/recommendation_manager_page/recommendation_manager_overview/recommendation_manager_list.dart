import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerList extends StatelessWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  const RecommendationManagerList(
      {super.key, required this.recommendations, required this.isPromoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: Row(children: [
          Flexible(
              flex: 3,
              child: _buildHeaderCell(
                  isPromoter ? "Empfehlungsname" : "Promoter", themeData)),
          Flexible(flex: 3, child: _buildHeaderCell("Status", themeData)),
          Flexible(flex: 2, child: _buildHeaderCell("Läuft ab in", themeData)),
          const SizedBox(
            width: 70,
            child: Icon(Icons.expand_more, color: Colors.transparent),
          ),
        ]),
      ),
      const Divider(height: 1),
      if (recommendations.isEmpty) ...[
        const SizedBox(height: 40),
        const NoSearchResultsView(
            title: "Keine Suchergebnisse",
            description:
                "Unter deinem Suchbegriff wurden keine Empfehlungen gefunden."),
        const SizedBox(height: 40)
      ] else ...[
        ListView.builder(
            itemCount: recommendations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return RecommendationManagerListTile(
                recommendation: recommendations[index],
                isPromoter: isPromoter,
              );
            })
      ]
    ]);
  }

  Widget _buildHeaderCell(String text, ThemeData themeData) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: themeData.textTheme.bodyMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
