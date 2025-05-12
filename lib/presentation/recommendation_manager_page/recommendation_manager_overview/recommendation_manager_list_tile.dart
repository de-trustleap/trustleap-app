import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_helper.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list_tile_icon_row.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_status_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerListTile extends StatefulWidget {
  final UserRecommendation recommendation;
  final bool isPromoter;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation, bool) onUpdate;
  const RecommendationManagerListTile(
      {super.key,
      required this.recommendation,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onUpdate});

  @override
  State<RecommendationManagerListTile> createState() =>
      _RecommendationManagerListTileState();
}

class _RecommendationManagerListTileState
    extends State<RecommendationManagerListTile> {
  late UserRecommendation _recommendation;

  @override
  void initState() {
    super.initState();
    _recommendation = widget.recommendation;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
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
          });
          widget.onUpdate(state.recommendation, false);
        } else if (state is RecommendationSetFinishedSuccessState) {
          widget.onUpdate(state.recommendation, true);
        }
      },
      builder: (context, state) {
        return CollapsibleTile(
            backgroundColor: themeData.colorScheme.surface,
            showDivider: false,
            titleWidget: Row(children: [
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
                  level: _recommendation.recommendation?.statusLevel ?? 0,
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
                      title: "Landingpage anzeigen",
                      onTap: () {
                        final baseURL = Environment().getLandingpageBaseURL();
                        CustomNavigator.openURLInNewTab(
                            "$baseURL?id=${_recommendation.id}");
                      }),
                  if (state is RecommendationSetStatusLoadingState &&
                      state.recommendation.id.value ==
                          _recommendation.id.value) ...[
                    const LoadingIndicator(size: 20)
                  ]
                ],
              ),
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
}

// TODO: SAVE RECOMMENDATION IN BACKEND VERLAGERN! (FERTIG)
// TODO: SAVE RECOMMENDATION ERWEITERN. ES MÜSSEN USERSRECOMMENDATION DOCUMENTS ANGELEGT WERDEN FÜR USER UND PARENTUSER (FERTIG)
// TODO: SAVE RECOMMENDATIONS FRONTEND CALL (FERTIG)
// TODO: TESTS FÜR SAVE RECOMMENDATIONS (FERTIG)
// TODO: ALERT BUTTONS DISABLEN (FERTIG)
// TODO: ONRECOMMENDATIONDELETE ERWEITERN. HIER MÜSSEN AUCH ALLE USERSRECOMMENDATIONS GELÖSCHT WERDEN (FERTIG)
// TODO: ONRECOMMENDATIONDELETE TESTS ERWEITERN (FERTIG)
// TODO: FRONTEND NUR USERSRECOMMENDATION ANZEIGEN (FERTIG)
// TODO: UPDATERECO FUNKTIONIERT NICHT MEHR RICHTIG. DIE GANZE TABELLE SCHEINT NEU ZU LADEN. HIER SOLL NUR DIE ZELLE NEU LADEN. (FERTIG)
// TODO: LÖSCHEN SO ERWEITERN, DASS USERSRECOMMENDATION.RECOMMENDATION GELÖSCHT WIRD (FERTIG)
// TODO: ARCHIVE RECOMMENDATIONS EBENFALLS UMSTELLEN (FERTIG)
// TODO: RecommendationManagerListTileIconRow LISTENER FUNKTIONIERT NICHT MEHR RICHTIG. DELETE BUTTON WIRD NIE DISABLED
// TODO: ALLES DURCHTESTEN
// TODO: TESTS ANPASSEN
// TODO: FAVORITE BUTTON EINFÜGEN
