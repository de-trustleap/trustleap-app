import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListHeader extends StatelessWidget {
  final TextEditingController searchController;
  final Function onFilterPressed;
  const RecommendationManagerListHeader(
      {super.key,
      required this.searchController,
      required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          localization.recommendation_manager_title,
          style: themeData.textTheme.headlineLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: SearchBar(
          controller: searchController,
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
                onPressed: () {
                  searchController.clear();
                },
                tooltip:
                    localization.recommendation_manager_search_close_tooltip,
                icon: const Icon(Icons.close))
          ],
          hintText: localization.recommendation_manager_search_placeholder,
        )),
        const SizedBox(width: 16),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
              onPressed: () => onFilterPressed(),
              tooltip: localization.recommendation_manager_filter_tooltip,
              icon: Icon(Icons.filter_list,
                  color: themeData.colorScheme.secondary, size: 32)),
        ),
      ],
    );
  }
}
