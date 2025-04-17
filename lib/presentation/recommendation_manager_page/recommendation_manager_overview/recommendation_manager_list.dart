import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
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
      ...recommendations.map((recommendation) => RecommendationManagerListTile(
            recommendation: recommendation,
            isPromoter: isPromoter,
          ))
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
// TODO: LÄUFT AB IN -> ANZEIGEN (FERTIG)
// TODO: JE NACH ROLLE ENTWEDER PROMOTERNAME ODER EMPFEHLUNGSNAME ANZEIGEN (FERTIG)
// TODO: STATUS PROPERTY ANLEGEN
// TODO: AUSGEKLAPPTE VIEW IMPLEMENTIEREN
