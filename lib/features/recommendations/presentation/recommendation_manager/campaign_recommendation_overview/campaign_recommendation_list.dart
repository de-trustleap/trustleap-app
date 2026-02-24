import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/campaign_recommendation_overview/campaign_recommendation_list_tile.dart';
import 'package:flutter/material.dart';

class CampaignRecommendationList extends StatelessWidget {
  final List<UserRecommendation> recommendations;
  final String searchQuery;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;

  const CampaignRecommendationList({
    super.key,
    required this.recommendations,
    required this.searchQuery,
    required this.onDeletePressed,
    required this.onFavoritePressed,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Column(children: [
      if (!responsiveValue.isMobile) ...[
        SizedBox(
          width: double.infinity,
          child: Row(children: [
            Flexible(
                flex: 3,
                child: _buildHeaderCell(
                    localization.campaign_manager_list_header_campaign_name,
                    themeData)),
            Flexible(
                flex: 2,
                child: _buildHeaderCell(
                    localization.campaign_manager_list_header_conversion_rate,
                    themeData)),
            Flexible(
                flex: 2,
                child: _buildHeaderCell(
                    localization
                        .recommendation_manager_list_header_expiration_date,
                    themeData)),
            const Flexible(flex: 1, child: SizedBox(width: 24)),
            const SizedBox(
              width: 70,
              child: Icon(Icons.expand_more, color: Colors.transparent),
            ),
          ]),
        ),
        const Divider(height: 1),
      ],
      if (recommendations.isEmpty && searchQuery.isNotEmpty) ...[
        const SizedBox(height: 40),
        NoSearchResultsView(
            title: localization.recommendation_manager_no_search_result_title,
            description: localization
                .recommendation_manager_no_search_result_description),
        const SizedBox(height: 40)
      ] else if (recommendations.isEmpty) ...[
        const SizedBox(height: 40),
        EmptyPage(
            icon: Icons.campaign,
            title: localization.recommendation_manager_no_data_title,
            subTitle: localization.recommendation_manager_no_data_description,
            buttonTitle:
                localization.recommendation_manager_no_data_button_title,
            onTap: () {
              CustomNavigator.of(context).navigate(
                  RoutePaths.homePath + RoutePaths.recommendationsPath);
            }),
        const SizedBox(height: 40)
      ] else ...[
        ListView.builder(
            itemCount: recommendations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CampaignRecommendationListTile(
                key: ValueKey(recommendations[index].id.value),
                recommendation: recommendations[index],
                onDeletePressed: onDeletePressed,
                onFavoritePressed: onFavoritePressed,
                onUpdate: onUpdate,
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
