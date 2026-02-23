import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_list_header.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_filter.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/personalized_recommendation_list.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/campaign_recommendation_overview/campaign_recommendation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerOverview extends StatefulWidget {
  final List<UserRecommendation> recommendations;
  final bool isPromoter;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  final Function(String, String, String) onCampaignDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation) onPriorityChanged;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;
  const RecommendationManagerOverview(
      {super.key,
      required this.recommendations,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onCampaignDeletePressed,
      required this.onFavoritePressed,
      required this.onPriorityChanged,
      required this.onUpdate});

  @override
  State<RecommendationManagerOverview> createState() =>
      _RecommendationManagerOverviewState();
}

class _RecommendationManagerOverviewState
    extends State<RecommendationManagerOverview> {
  late List<UserRecommendation> _filteredRecommendations;
  late List<UserRecommendation> _searchFilteredRecommendations;
  final TextEditingController _searchController = TextEditingController();
  RecommendationOverviewFilterStates _currentFilterStates =
      RecommendationOverviewFilterStates(isArchive: false);
  bool _filterIsExpanded = false;
  RecommendationSearchOption _selectedSearchOption = RecommendationSearchOption.promoterName;
  RecommendationType _selectedType = RecommendationType.personalized;

  @override
  void initState() {
    super.initState();

    _setInitialFilterData();
    _searchController.addListener(() {
      _performSearch();
    });
  }

  List<UserRecommendation> _getTypeFilteredRecommendations() {
    return widget.recommendations
        .where((r) => r.recommendation?.recommendationType == _selectedType)
        .toList();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    final typeFiltered = _getTypeFilteredRecommendations();
    setState(() {
      _searchFilteredRecommendations = typeFiltered.where((item) {
        final name = item.recommendation?.displayName?.toLowerCase() ?? "";

        if (_selectedType == RecommendationType.campaign) {
          return name.contains(query);
        }

        final promoter =
            item.recommendation?.promoterName?.toLowerCase() ?? "";
        final reason = item.recommendation?.reason?.toLowerCase() ?? "";

        switch (_selectedSearchOption) {
          case RecommendationSearchOption.name:
            return name.contains(query);
          case RecommendationSearchOption.promoterName:
            return promoter.contains(query);
          case RecommendationSearchOption.reason:
            return reason.contains(query);
        }
      }).toList();

      _filteredRecommendations = RecommendationFilter.applyFilters(
        items: _searchFilteredRecommendations,
        filterStates: _currentFilterStates,
        favoriteRecommendationIDs: Modular.get<RecommendationManagerTileCubit>().currentFavoriteRecommendationIDs,
      );
    });
  }

  @override
  void didUpdateWidget(covariant RecommendationManagerOverview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.recommendations != oldWidget.recommendations) {
      setState(() {
        _setInitialFilterData();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setInitialFilterData() {
    _searchFilteredRecommendations = _getTypeFilteredRecommendations();
    _filteredRecommendations = RecommendationFilter.applyFilters(
      items: _searchFilteredRecommendations,
      filterStates: _currentFilterStates,
      favoriteRecommendationIDs: Modular.get<RecommendationManagerTileCubit>().currentFavoriteRecommendationIDs,
    );
  }

  void onFilterPressed() {
    setState(() {
      _filterIsExpanded = !_filterIsExpanded;
    });
  }

  void onFilterChanged(RecommendationOverviewFilterStates filterStates) {
    setState(() {
      _currentFilterStates = filterStates;
      _filteredRecommendations = RecommendationFilter.applyFilters(
          items: _searchFilteredRecommendations, 
          filterStates: filterStates,
          favoriteRecommendationIDs: Modular.get<RecommendationManagerTileCubit>().currentFavoriteRecommendationIDs);
    });
  }

  void onSearchOptionChanged(RecommendationSearchOption option) {
    setState(() {
      _selectedSearchOption = option;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecommendationManagerTileCubit, RecommendationManagerTileState>(
      bloc: Modular.get<RecommendationManagerTileCubit>(),
      listener: (context, state) {
        if (state is RecommendationManagerTileFavoriteUpdatedState) {
          setState(() {
            _filteredRecommendations = RecommendationFilter.applyFilters(
              items: _searchFilteredRecommendations,
              filterStates: _currentFilterStates,
              favoriteRecommendationIDs: Modular.get<RecommendationManagerTileCubit>().currentFavoriteRecommendationIDs,
            );
          });
        }
      },
      child: CardContainer(
        maxWidth: 1200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecommendationManagerListHeader(
                searchController: _searchController,
                onFilterPressed: onFilterPressed,
                onSearchOptionChanged: onSearchOptionChanged,
                selectedType: _selectedType,
                onTypeChanged: (type) {
                  setState(() {
                    _selectedType = type;
                    _setInitialFilterData();
                    _performSearch();
                  });
                }),
            ExpandedSection(
                expand: _filterIsExpanded,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      RecommendationManagerExpandableFilter(
                          onFilterChanged: onFilterChanged, isArchive: false)
                    ])),
            const SizedBox(height: 20),
            if (_selectedType == RecommendationType.campaign)
              CampaignRecommendationList(
                recommendations: _filteredRecommendations,
                searchQuery: _searchController.text,
                onDeletePressed: widget.onCampaignDeletePressed,
                onFavoritePressed: widget.onFavoritePressed,
                onUpdate: widget.onUpdate,
              )
            else
              PersonalizedRecommendationList(
                recommendations: _filteredRecommendations,
                searchQuery: _searchController.text,
                isPromoter: widget.isPromoter,
                onAppointmentPressed: widget.onAppointmentPressed,
                onFinishedPressed: widget.onFinishedPressed,
                onFailedPressed: widget.onFailedPressed,
                onDeletePressed: widget.onDeletePressed,
                onFavoritePressed: widget.onFavoritePressed,
                onPriorityChanged: widget.onPriorityChanged,
                onUpdate: widget.onUpdate,
              ),
          ],
        ),
      ),
    );
  }
}
