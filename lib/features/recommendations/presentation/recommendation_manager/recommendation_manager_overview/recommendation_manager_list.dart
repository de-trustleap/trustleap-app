import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_list_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerList extends StatelessWidget {
  final List<UserRecommendation> recommendations;
  final bool isPromoter;
  final List<String>? favoriteRecommendationIDs;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation) onPriorityChanged;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;
  const RecommendationManagerList(
      {super.key,
      required this.recommendations,
      required this.isPromoter,
      required this.favoriteRecommendationIDs,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onFavoritePressed,
      required this.onPriorityChanged,
      required this.onUpdate});

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
                flex: 1,
                child: _buildHeaderCell(
                    localization.recommendation_manager_list_header_priority,
                    themeData)),
            Flexible(
                flex: 3,
                child: _buildHeaderCell(
                    isPromoter
                        ? localization.recommendation_manager_list_header_receiver
                        : localization
                            .recommendation_manager_list_header_promoter,
                    themeData)),
            Flexible(
                flex: 3,
                child: _buildHeaderCell(
                    localization.recommendation_manager_list_header_status,
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
      if (recommendations.isEmpty) ...[
        const SizedBox(height: 40),
        NoSearchResultsView(
            title: localization.recommendation_manager_no_search_result_title,
            description: localization
                .recommendation_manager_no_search_result_description),
        const SizedBox(height: 40)
      ] else ...[
        ListView.builder(
            itemCount: recommendations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return RecommendationManagerListTile(
                key: ValueKey(recommendations[index].id.value),
                recommendation: recommendations[index],
                isPromoter: isPromoter,
                favoriteRecommendationIDs: favoriteRecommendationIDs,
                onAppointmentPressed: onAppointmentPressed,
                onFinishedPressed: onFinishedPressed,
                onFailedPressed: onFailedPressed,
                onDeletePressed: onDeletePressed,
                onFavoritePressed: onFavoritePressed,
                onPriorityChanged: onPriorityChanged,
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
