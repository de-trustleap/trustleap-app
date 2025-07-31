import 'package:finanzbegleiter/application/dashboard/promoter_ranking/promoter_ranking_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardPromoterRanking extends StatefulWidget {
  final CustomUser user;
  const DashboardPromoterRanking({super.key, required this.user});

  @override
  State<DashboardPromoterRanking> createState() =>
      _DashboardPromoterRankingState();
}

class _DashboardPromoterRankingState extends State<DashboardPromoterRanking> {
  TimePeriod _selectedTimePeriod = TimePeriod.month;

  @override
  void initState() {
    super.initState();

    Modular.get<PromoterRankingCubit>()
        .getTop3Promoters(widget.user.registeredPromoterIDs ?? [], timePeriod: _selectedTimePeriod);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = Modular.get<PromoterRankingCubit>();

    return BlocBuilder<PromoterRankingCubit, PromoterRankingState>(
      bloc: cubit,
      builder: (context, state) {
        return CardContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Promoter Rangliste",
                    style: themeData.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "Zeitraum:",
                        style: themeData.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      UnderlinedDropdown<TimePeriod>(
                        value: _selectedTimePeriod,
                        items: [TimePeriod.month, TimePeriod.quarter, TimePeriod.year]
                            .map((period) {
                          return DropdownMenuItem<TimePeriod>(
                            value: period,
                            child: Text(period.value),
                          );
                        }).toList(),
                        onChanged: (TimePeriod? newPeriod) {
                          if (newPeriod != null) {
                            setState(() {
                              _selectedTimePeriod = newPeriod;
                            });
                            // Reload data with new time period
                            Modular.get<PromoterRankingCubit>()
                                .getTop3Promoters(widget.user.registeredPromoterIDs ?? [], timePeriod: _selectedTimePeriod);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state is PromoterRankingGetTop3FailureState) ...[
                ErrorView(
                  title: "Fehler beim Laden",
                  message:
                      "Die Promoter-Rangliste konnte nicht geladen werden.",
                  callback: () => Modular.get<PromoterRankingCubit>()
                      .getTop3Promoters(
                          widget.user.registeredPromoterIDs ?? [], timePeriod: _selectedTimePeriod),
                )
              ] else if (state is PromoterRankingGetTop3NoPromotersState) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Keine Promoter gefunden.",
                    style: themeData.textTheme.bodyLarge?.copyWith(
                      color: themeData.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              ] else if (state is PromoterRankingGetTop3SuccessState) ...[
                _buildPromoterList(state.promoters, themeData)
              ] else ...[
                const LoadingIndicator()
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoterList(List<dynamic> promoters, ThemeData themeData) {
    if (promoters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Keine Promoter-Daten verfügbar.",
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: promoters.map((promoter) {
        return _buildPromoterRow(promoter, themeData);
      }).toList(),
    );
  }

  Widget _buildPromoterRow(dynamic promoter, ThemeData themeData) {
    String getMedalEmoji(int rank) {
      switch (rank) {
        case 1:
          return "🥇";
        case 2:
          return "🥈";
        case 3:
          return "🥉";
        default:
          return "$rank.";
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              getMedalEmoji(promoter.rank),
              style: themeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              promoter.promoterName,
              style: themeData.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "${promoter.completedRecommendationsCount}",
              style: themeData.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeData.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
