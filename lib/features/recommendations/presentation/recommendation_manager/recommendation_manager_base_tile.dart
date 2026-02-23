import 'dart:async';

import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_list_tile_content.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_list_tile_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_notes_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerBaseTile extends StatefulWidget {
  final UserRecommendation recommendation;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;
  final Widget Function(UserRecommendation) buildTitle;
  final List<Widget> Function(UserRecommendation, bool isLoading) buildContent;
  final List<Widget> Function(UserRecommendation)? buildBottomRowTrailing;

  const RecommendationManagerBaseTile({
    super.key,
    required this.recommendation,
    required this.onFavoritePressed,
    required this.onUpdate,
    required this.buildTitle,
    required this.buildContent,
    this.buildBottomRowTrailing,
  });

  @override
  State<RecommendationManagerBaseTile> createState() =>
      _RecommendationManagerBaseTileState();
}

class _RecommendationManagerBaseTileState
    extends State<RecommendationManagerBaseTile> {
  late UserRecommendation _recommendation;
  bool _addNote = false;
  Timer? _viewTimer;
  bool _shouldAnimateToSurface = false;

  @override
  void initState() {
    super.initState();
    _recommendation = widget.recommendation;
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    super.dispose();
  }

  void _startBackgroundFadeAnimation() {
    setState(() {
      _shouldAnimateToSurface = true;
    });
  }

  void _startViewTimer(String recommendationID) {
    _viewTimer?.cancel();
    _viewTimer = Timer(const Duration(seconds: 3), () {
      Modular.get<RecommendationManagerTileCubit>()
          .markAsViewed(recommendationID);
    });
  }

  void _markAsViewedAndCancelTimer(String recommendationID) {
    _viewTimer?.cancel();
    Modular.get<RecommendationManagerTileCubit>()
        .markAsViewed(recommendationID);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();

    return BlocConsumer<RecommendationManagerTileCubit,
        RecommendationManagerTileState>(
      bloc: cubit,
      listenWhen: (previous, current) =>
          (current is RecommendationSetStatusSuccessState &&
              current.recommendation.id == _recommendation.id) ||
          (current is RecommendationSetFinishedSuccessState &&
              current.recommendation.id == _recommendation.id) ||
          (current is RecommendationManagerTileFavoriteUpdatedState) ||
          (current is RecommendationManagerTileViewedState &&
              current.recommendationID == _recommendation.id.value),
      listener: (context, state) {
        if (state is RecommendationSetStatusSuccessState) {
          setState(() {
            _recommendation = state.recommendation;
            if (state.settedNotes != null && state.settedNotes!) {
              _addNote = false;
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
        } else if (state is RecommendationManagerTileFavoriteUpdatedState) {
          setState(() {
            context.mounted;
          });
        } else if (state is RecommendationManagerTileViewedState) {
          final hadUnseenChanges = _recommendation
              .hasUnseenChanges(cubit.currentUser?.id.value ?? "");

          if (hadUnseenChanges) {
            _startBackgroundFadeAnimation();
          }

          setState(() {
            final updatedViewedByUsers =
                List<LastViewed>.of(_recommendation.viewedByUsers);
            updatedViewedByUsers
                .removeWhere((view) => view.userID == state.lastViewed.userID);
            updatedViewedByUsers.add(state.lastViewed);

            _recommendation =
                _recommendation.copyWith(viewedByUsers: updatedViewedByUsers);
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is RecommendationSetStatusLoadingState &&
            state.recommendation.id.value == _recommendation.id.value;

        return Container(
          color: themeData.colorScheme.surface,
          child: CollapsibleTile(
            backgroundColor: Colors.transparent,
            showDivider: false,
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                _startViewTimer(_recommendation.id.value);
              } else {
                _markAsViewedAndCancelTimer(_recommendation.id.value);
              }
            },
            titleWidget: widget.buildTitle(_recommendation),
            backgroundOverlay: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: themeData.colorScheme.primary.withValues(
                    alpha:
                        RecommendationManagerListTileHelper.getOverlayOpacity(
                            _recommendation,
                            cubit.currentUser?.id.value ?? "",
                            _shouldAnimateToSurface)),
              ),
            ),
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _recommendation.hasUnseenChanges(
                            cubit.currentUser?.id.value ?? "") &&
                        !_shouldAnimateToSurface
                    ? FutureBuilder<String?>(
                        future: RecommendationManagerListTileHelper
                            .buildLastEditMessage(
                                _recommendation,
                                cubit.currentUser?.id.value ?? "",
                                localization),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Column(
                              children: [
                                Text(
                                  snapshot.data!,
                                  style: themeData.textTheme.bodySmall
                                      ?.copyWith(
                                          color: themeData.colorScheme.primary,
                                          fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              RecommendationManagerListTileContent(
                recommendation: _recommendation,
              ),
              const SizedBox(height: 16),
              ...widget.buildContent(_recommendation, isLoading),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClickableLink(
                      title: localization
                          .recommendation_manager_show_landingpage_button,
                      onTap: () {
                        final baseURL = Environment().getLandingpageBaseURL();
                        navigator.openURLInNewTab(
                            "$baseURL?p=${_recommendation.recommendation?.promoterName ?? ""}&id=${_recommendation.recoID}");
                      }),
                  if (isLoading) ...[
                    const LoadingIndicator(size: 20)
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.buildBottomRowTrailing != null)
                        ...widget.buildBottomRowTrailing!(_recommendation),
                      if (_recommendation.notes == null ||
                          (_recommendation.notes != null &&
                              _recommendation.notes!.isEmpty)) ...[
                        const SizedBox(width: 16),
                        IconButton(
                            tooltip: localization
                                .recommendation_manager_add_note_button_tooltip,
                            onPressed: () {
                              setState(() {
                                _addNote = true;
                              });
                            },
                            color: themeData.colorScheme.secondary,
                            iconSize: 24,
                            icon: const Icon(Icons.note_add))
                      ]
                    ],
                  ),
                ],
              ),
              if (_addNote ||
                  (_recommendation.notes != null &&
                      _recommendation.notes!.isNotEmpty)) ...[
                const SizedBox(height: 16),
                RecommendationManagerNotesTextfield(
                    recommendation: _recommendation,
                    isEditing: _addNote ? true : false,
                    onSave: (notes) =>
                        Modular.get<RecommendationManagerTileCubit>()
                            .setNotes(
                                _recommendation.copyWith(notes: notes))),
              ],
              if (state is RecommendationSetStatusFailureState &&
                  state.recommendation.id.value ==
                      _recommendation.id.value) ...[
                FormErrorView(
                    message: DatabaseFailureMapper.mapFailureMessage(
                        state.failure, localization)),
              ],
            ],
          ),
        );
      },
    );
  }
}
