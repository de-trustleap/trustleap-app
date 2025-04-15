import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_list_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerList extends StatelessWidget {
  const RecommendationManagerList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: Row(children: [
          Flexible(flex: 3, child: _buildHeaderCell("Promoter", themeData)),
          Flexible(flex: 3, child: _buildHeaderCell("Status", themeData)),
          Flexible(
              flex: 2,
              child: _buildHeaderCell("Zuletzt aktualisiert", themeData)),
          const SizedBox(
            width: 70,
            child: Icon(Icons.expand_more, color: Colors.transparent),
          ),
        ]),
      ),
      const Divider(height: 1),
      const RecommendationManagerListTile(),
      const RecommendationManagerListTile(),
      const RecommendationManagerListTile()
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
// TODO: CUBIT VERBINDEN!
