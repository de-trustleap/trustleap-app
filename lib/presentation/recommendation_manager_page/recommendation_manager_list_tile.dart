import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTile extends StatelessWidget {
  const RecommendationManagerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CollapsibleTile(
        backgroundColor: themeData.colorScheme.surface,
        showDivider: false,
        titleWidget: Row(children: [
          Flexible(flex: 3, child: _buildCell("Hans Test", themeData)),
          Flexible(flex: 3, child: _buildCell("Link geklickt", themeData)),
          Flexible(flex: 2, child: _buildCell("23.03.2025", themeData)),
          const SizedBox(width: 8)
        ]),
        children: [const Text("TEST")]);
  }

  Widget _buildCell(String text, ThemeData themeData) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: themeData.textTheme.bodyMedium,
      ),
    );
  }
}
