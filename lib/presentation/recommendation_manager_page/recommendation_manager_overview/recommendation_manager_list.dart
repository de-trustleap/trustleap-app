import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list_tile.dart';
import 'package:flutter/material.dart';

class RecommendationManagerList extends StatelessWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  final Function(String) onAppointmentPressed;
  final Function(String) onFinishedPressed;
  final Function(String) onFailedPressed;
  final Function(String, String) onDeletePressed;
  const RecommendationManagerList(
      {super.key,
      required this.recommendations,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: Row(children: [
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
          const SizedBox(
            width: 70,
            child: Icon(Icons.expand_more, color: Colors.transparent),
          ),
        ]),
      ),
      const Divider(height: 1),
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
                recommendation: recommendations[index],
                isPromoter: isPromoter,
                onAppointmentPressed: onAppointmentPressed,
                onFinishedPressed: onFinishedPressed,
                onFailedPressed: onFailedPressed,
                onDeletePressed: onDeletePressed,
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
