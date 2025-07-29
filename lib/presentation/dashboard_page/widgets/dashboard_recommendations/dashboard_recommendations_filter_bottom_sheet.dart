import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardRecommendationsFilterBottomSheet extends StatelessWidget {
  final CustomUser user;
  final TimePeriod selectedTimePeriod;
  final int? selectedStatusLevel;
  final String? selectedPromoterId;
  final String? selectedLandingPageId;
  final Function(TimePeriod) onTimePeriodChanged;
  final Function(int?) onStatusLevelChanged;
  final Function(String?) onPromoterChanged;
  final Function(String?) onLandingPageChanged;

  const DashboardRecommendationsFilterBottomSheet({
    super.key,
    required this.user,
    required this.selectedTimePeriod,
    required this.selectedStatusLevel,
    required this.selectedPromoterId,
    required this.selectedLandingPageId,
    required this.onTimePeriodChanged,
    required this.onStatusLevelChanged,
    required this.onPromoterChanged,
    required this.onLandingPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = Modular.get<DashboardRecommendationsCubit>();
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return BlocBuilder<DashboardRecommendationsCubit,
        DashboardRecommendationsState>(
      bloc: cubit,
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.dashboard_recommendations_filter_title,
                  style: themeData.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DashboardRecommendationsFilter(
              user: user,
              state: state,
              selectedTimePeriod: selectedTimePeriod,
              selectedStatusLevel: selectedStatusLevel,
              selectedPromoterId: selectedPromoterId,
              selectedLandingPageId: selectedLandingPageId,
              onTimePeriodChanged: onTimePeriodChanged,
              onStatusLevelChanged: onStatusLevelChanged,
              onPromoterChanged: onPromoterChanged,
              onLandingPageChanged: onLandingPageChanged,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
