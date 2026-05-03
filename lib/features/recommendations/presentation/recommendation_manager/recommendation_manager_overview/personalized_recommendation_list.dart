import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/helpers/animated_list_differ.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/personalized_recommendation_list_tile.dart';
import 'package:flutter/material.dart';

class PersonalizedRecommendationList extends StatefulWidget {
  final List<UserRecommendation> recommendations;
  final String searchQuery;
  final bool isPromoter;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(UserRecommendation) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation) onPriorityChanged;
  const PersonalizedRecommendationList(
      {super.key,
      required this.recommendations,
      required this.searchQuery,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onFavoritePressed,
      required this.onPriorityChanged});

  @override
  State<PersonalizedRecommendationList> createState() =>
      _PersonalizedRecommendationListState();
}

class _PersonalizedRecommendationListState
    extends State<PersonalizedRecommendationList> {
  late final AnimatedListDiffer<UserRecommendation> _differ;

  @override
  void initState() {
    super.initState();
    _differ = AnimatedListDiffer(
      initialList: widget.recommendations,
      isSame: (a, b) => a.id == b.id,
    );
  }

  @override
  void didUpdateWidget(PersonalizedRecommendationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _differ.update(
      newList: widget.recommendations,
      buildRemovedItem: _buildTile,
    );
  }

  Widget _buildTile(UserRecommendation rec, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: PersonalizedRecommendationListTile(
          key: ValueKey(rec.id.value),
          recommendation: rec,
          isPromoter: widget.isPromoter,
          onAppointmentPressed: widget.onAppointmentPressed,
          onFinishedPressed: widget.onFinishedPressed,
          onFailedPressed: widget.onFailedPressed,
          onDeletePressed: widget.onDeletePressed,
          onFavoritePressed: widget.onFavoritePressed,
          onPriorityChanged: widget.onPriorityChanged,
        ),
      ),
    );
  }

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
                    widget.isPromoter
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
      if (widget.recommendations.isEmpty && widget.searchQuery.isNotEmpty) ...[
        const SizedBox(height: 40),
        NoSearchResultsView(
            title: localization.recommendation_manager_no_search_result_title,
            description: localization
                .recommendation_manager_no_search_result_description),
        const SizedBox(height: 40)
      ] else if (widget.recommendations.isEmpty) ...[
        const SizedBox(height: 40),
        EmptyPage(
            icon: Icons.person_add,
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
        AnimatedList(
          key: _differ.listKey,
          initialItemCount: _differ.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index, animation) =>
              _buildTile(_differ.items[index], animation),
        )
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
