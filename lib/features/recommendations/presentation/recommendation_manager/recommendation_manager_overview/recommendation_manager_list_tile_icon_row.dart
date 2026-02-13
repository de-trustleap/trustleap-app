import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerListTileIconRow extends StatefulWidget {
  final UserRecommendation recommendation;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  const RecommendationManagerListTileIconRow(
      {super.key,
      required this.recommendation,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed});

  @override
  State<RecommendationManagerListTileIconRow> createState() =>
      _RecommendationManagerListTileIconRowState();
}

class _RecommendationManagerListTileIconRowState
    extends State<RecommendationManagerListTileIconRow> {
  bool buttonsDisabled = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();
    return BlocListener<RecommendationManagerTileCubit,
        RecommendationManagerTileState>(
      bloc: cubit,
      listenWhen: (previous, current) =>
          (current is RecommendationSetStatusLoadingState &&
              current.recommendation.id == widget.recommendation.id),
      listener: (context, state) {
        if (state is RecommendationSetStatusLoadingState &&
            state.recommendation.id == widget.recommendation.id) {
          setState(() {
            buttonsDisabled = true;
          });
        } else {
          setState(() {
            buttonsDisabled = false;
          });
        }
      },
      child: Row(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: localization
                      .recommendation_manager_tile_progress_appointment_button_tooltip,
                  child: ElevatedButton(
                      onPressed: widget.recommendation.recommendation
                                      ?.statusLevel ==
                                  StatusLevel.contactFormSent &&
                              !buttonsDisabled
                          ? () =>
                              widget.onAppointmentPressed(widget.recommendation)
                          : null,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: themeData.colorScheme.primary),
                      child: const Icon(Icons.calendar_month,
                          color: Colors.white)),
                ))),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: localization
                      .recommendation_manager_tile_progress_finish_button_tooltip,
                  child: ElevatedButton(
                      onPressed: widget.recommendation.recommendation
                                      ?.statusLevel ==
                                  StatusLevel.appointment &&
                              !buttonsDisabled
                          ? () =>
                              widget.onFinishedPressed(widget.recommendation)
                          : null,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: themeData.colorScheme.primary),
                      child: const Icon(Icons.check, color: Colors.white)),
                ))),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: localization
                      .recommendation_manager_tile_progress_failed_button_tooltip,
                  child: ElevatedButton(
                      onPressed: widget.recommendation.recommendation
                                      ?.statusLevel ==
                                  StatusLevel.appointment &&
                              !buttonsDisabled
                          ? () => widget.onFailedPressed(widget.recommendation)
                          : null,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: themeData.colorScheme.secondary),
                      child: const Icon(Icons.close, color: Colors.white)),
                ))),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: localization
                      .recommendation_manager_list_tile_delete_button_title,
                  child: ElevatedButton(
                      onPressed: buttonsDisabled
                          ? null
                          : () => widget.onDeletePressed(
                              widget.recommendation.recommendation?.id ?? "",
                              widget.recommendation.recommendation?.userID ??
                                  "",
                              widget.recommendation.id.value),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: themeData.colorScheme.secondary),
                      child: const Icon(Icons.delete, color: Colors.white)),
                )))
      ]),
    );
  }
}
