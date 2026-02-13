import 'package:finanzbegleiter/features/dashboard/application/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardRecommendationsFilterBottomSheet extends StatefulWidget {
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
  State<DashboardRecommendationsFilterBottomSheet> createState() =>
      _DashboardRecommendationsFilterBottomSheetState();
}

class _DashboardRecommendationsFilterBottomSheetState
    extends State<DashboardRecommendationsFilterBottomSheet> {
  late TimePeriod _selectedTimePeriod;
  late int? _selectedStatusLevel;
  late String? _selectedPromoterId;
  late String? _selectedLandingPageId;

  @override
  void initState() {
    super.initState();
    _selectedTimePeriod = widget.selectedTimePeriod;
    _selectedStatusLevel = widget.selectedStatusLevel;
    _selectedPromoterId = widget.selectedPromoterId;
    _selectedLandingPageId = widget.selectedLandingPageId;
  }

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
              user: widget.user,
              state: state,
              selectedTimePeriod: _selectedTimePeriod,
              selectedStatusLevel: _selectedStatusLevel,
              selectedPromoterId: _selectedPromoterId,
              selectedLandingPageId: _selectedLandingPageId,
              onTimePeriodChanged: (TimePeriod newValue) {
                setState(() {
                  _selectedTimePeriod = newValue;
                });
                widget.onTimePeriodChanged(newValue);
              },
              onStatusLevelChanged: (int? newValue) {
                setState(() {
                  _selectedStatusLevel = newValue;
                });
                widget.onStatusLevelChanged(newValue);
              },
              onPromoterChanged: (String? newValue) {
                setState(() {
                  _selectedPromoterId = newValue;
                });
                widget.onPromoterChanged(newValue);
              },
              onLandingPageChanged: (String? newValue) {
                setState(() {
                  _selectedLandingPageId = newValue;
                });
                widget.onLandingPageChanged(newValue);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
