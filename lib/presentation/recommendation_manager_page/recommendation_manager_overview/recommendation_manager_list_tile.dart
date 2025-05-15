import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_helper.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_favorite_button.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list_tile_icon_row.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_notes_textfield.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_status_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerListTile extends StatefulWidget {
  final UserRecommendation recommendation;
  final bool isPromoter;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation) onPriorityChanged;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;
  const RecommendationManagerListTile(
      {super.key,
      required this.recommendation,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onFavoritePressed,
      required this.onPriorityChanged,
      required this.onUpdate});

  @override
  State<RecommendationManagerListTile> createState() =>
      _RecommendationManagerListTileState();
}

class _RecommendationManagerListTileState
    extends State<RecommendationManagerListTile> {
  late UserRecommendation _recommendation;
  bool addNote = false;

  @override
  void initState() {
    super.initState();
    _recommendation = widget.recommendation;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final helper = RecommendationManagerHelper(localization: localization);
    final cubit = Modular.get<RecommendationManagerTileCubit>();
    return BlocConsumer<RecommendationManagerTileCubit,
        RecommendationManagerTileState>(
      bloc: cubit,
      listenWhen: (previous, current) =>
          (current is RecommendationSetStatusSuccessState &&
              current.recommendation.id == _recommendation.id) ||
          (current is RecommendationSetFinishedSuccessState &&
              current.recommendation.id == _recommendation.id),
      listener: (context, state) {
        if (state is RecommendationSetStatusSuccessState) {
          setState(() {
            _recommendation = state.recommendation;
            if (state.settedNotes != null && state.settedNotes!) {
              addNote = false;
            }
          });
          widget.onUpdate(
              state.recommendation,
              false,
              state.settedFavorite ?? false,
              state.settedPriority ?? false,
              state.settedNotes ?? false);
        } else if (state is RecommendationSetFinishedSuccessState) {
          widget.onUpdate(state.recommendation, true, false, false, false);
        }
      },
      builder: (context, state) {
        return CollapsibleTile(
            backgroundColor: themeData.colorScheme.surface,
            showDivider: false,
            titleWidget: Row(children: [
              Flexible(
                  flex: 1,
                  child:
                      _buildPriorityCell(_recommendation.priority, themeData)),
              Flexible(
                  flex: 3,
                  child: _buildCell(
                      widget.isPromoter
                          ? _recommendation.recommendation?.name ?? ""
                          : _recommendation.recommendation?.promoterName ?? "",
                      themeData)),
              Flexible(
                  flex: 3,
                  child: _buildCell(
                      helper.getStringFromStatusLevel(
                              _recommendation.recommendation?.statusLevel) ??
                          "",
                      themeData)),
              Flexible(
                  flex: 2,
                  child: _buildCell(
                      helper.getExpiresInDaysCount(
                          _recommendation.recommendation?.expiresAt ??
                              DateTime.now()),
                      themeData)),
              Flexible(
                  flex: 1,
                  child: RecommendationManagerFavoriteButton(
                      isFavorite: _recommendation.isFavorite ?? false,
                      onPressed: () => widget
                              .onFavoritePressed(widget.recommendation.copyWith(
                            isFavorite: _recommendation.isFavorite != null
                                ? !_recommendation.isFavorite!
                                : false,
                          )))),
              const SizedBox(width: 8)
            ]),
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(localization.recommendation_manager_list_tile_receiver,
                      style: themeData.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(_recommendation.recommendation?.name ?? "",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold))
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(localization.recommendation_manager_list_tile_reason,
                      style: themeData.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(_recommendation.recommendation?.reason ?? "",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold))
                ])
              ]),
              const SizedBox(height: 16),
              RecommendationManagerStatusProgressIndicator(
                  level: _recommendation.recommendation?.statusLevel ??
                      StatusLevel.recommendationSend,
                  statusTimestamps:
                      _recommendation.recommendation?.statusTimestamps ?? {}),
              const SizedBox(height: 16),
              RecommendationManagerListTileIconRow(
                  key: ValueKey(
                      "${_recommendation.id}-${_recommendation.recommendation?.statusLevel}"),
                  recommendation: _recommendation,
                  onAppointmentPressed: widget.onAppointmentPressed,
                  onFinishedPressed: widget.onFinishedPressed,
                  onFailedPressed: widget.onFailedPressed,
                  onDeletePressed: widget.onDeletePressed),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClickableLink(
                      title: localization
                          .recommendation_manager_show_landingpage_button,
                      onTap: () {
                        final baseURL = Environment().getLandingpageBaseURL();
                        CustomNavigator.openURLInNewTab(
                            "$baseURL?id=${_recommendation.recoID}");
                      }),
                  if (state is RecommendationSetStatusLoadingState &&
                      state.recommendation.id.value ==
                          _recommendation.id.value) ...[
                    const LoadingIndicator(size: 20)
                  ],
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    _getPriorityIcon(_recommendation.priority, themeData),
                    PopupMenuButton<RecommendationPriority>(
                        tooltip: localization
                            .recommendation_manager_select_priority_tooltip,
                        itemBuilder: (context) => [
                              _getPopupMenuItem(RecommendationPriority.high,
                                  themeData, localization, responsiveValue),
                              _getPopupMenuItem(RecommendationPriority.medium,
                                  themeData, localization, responsiveValue),
                              _getPopupMenuItem(RecommendationPriority.low,
                                  themeData, localization, responsiveValue)
                            ],
                        onSelected: (value) => widget.onPriorityChanged(
                            _recommendation.copyWith(priority: value))),
                    if (_recommendation.notes == null ||
                        (_recommendation.notes != null &&
                            _recommendation.notes!.isEmpty)) ...[
                      const SizedBox(width: 16),
                      IconButton(
                          tooltip: localization
                              .recommendation_manager_add_note_button_tooltip,
                          onPressed: () {
                            setState(() {
                              addNote = true;
                            });
                          },
                          color: themeData.colorScheme.secondary,
                          iconSize: 24,
                          icon: const Icon(Icons.note_add))
                    ]
                  ])
                ],
              ),
              if (addNote ||
                  (_recommendation.notes != null &&
                      _recommendation.notes!.isNotEmpty)) ...[
                const SizedBox(height: 16),
                RecommendationManagerNotesTextfield(
                    recommendation: _recommendation,
                    isEditing: addNote ? true : false,
                    onSave: (notes) =>
                        Modular.get<RecommendationManagerTileCubit>().setNotes(
                            _recommendation.copyWith(
                                notes: notes, notesLastEdited: DateTime.now())))
              ],
              if (state is RecommendationSetStatusFailureState &&
                  state.recommendation.id.value ==
                      _recommendation.id.value) ...[
                FormErrorView(
                    message: DatabaseFailureMapper.mapFailureMessage(
                        state.failure, localization))
              ]
            ]);
      },
    );
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

  Widget _buildPriorityCell(
      RecommendationPriority? priority, ThemeData themeData) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: _getPriorityIcon(priority, themeData));
  }

  Widget _getPriorityIcon(
      RecommendationPriority? priority, ThemeData themeData) {
    switch (priority) {
      case RecommendationPriority.low:
        return Icon(Icons.arrow_downward,
            size: 24, color: themeData.colorScheme.primary);
      case RecommendationPriority.high:
        return Icon(Icons.arrow_upward,
            size: 24, color: themeData.colorScheme.error);
      default:
        return const Icon(Icons.remove, size: 24, color: Colors.lightBlue);
    }
  }

  PopupMenuItem<RecommendationPriority> _getPopupMenuItem(
      RecommendationPriority priority,
      ThemeData themeData,
      AppLocalizations localization,
      ResponsiveBreakpointsData responsiveValue) {
    return PopupMenuItem(
        value: priority,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          _getPriorityIcon(priority, themeData),
          const SizedBox(width: 8),
          Text(priority.getLocalizedLabel(localization),
              style: responsiveValue.isMobile
                  ? themeData.textTheme.bodySmall
                  : themeData.textTheme.bodyMedium)
        ]));
  }
}
