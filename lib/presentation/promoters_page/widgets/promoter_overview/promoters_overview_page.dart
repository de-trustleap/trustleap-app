// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_overview_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_grid.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_list.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_no_search_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum PromotersOverviewViewState { grid, list }

class PromotersOverviewPage extends StatefulWidget {
  final TabController tabController;

  const PromotersOverviewPage({
    super.key,
    required this.tabController,
  });

  @override
  State<PromotersOverviewPage> createState() => _PromotersOverviewPageState();
}

class _PromotersOverviewPageState extends State<PromotersOverviewPage> {
  PromotersOverviewViewState _viewState = PromotersOverviewViewState.grid;
  PromoterOverviewFilter filter = PromoterOverviewFilter();
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late PromoterOverviewFilterStates _filterStates;
  int lastIndexLoaded = 0;
  List<Promoter> allPromoters = [];
  List<Promoter> visiblePromoters = [];
  List<Promoter> searchResults = [];
  // unfilteredData is used to save the search results without applied filter.
  // This is neeeded to make it possible to not apply new filters on an already filtered array.
  List<Promoter> unfilteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _filterStates = PromoterOverviewFilterStates();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onFilterChanged(PromoterOverviewFilterStates filterStates) {
    setState(() {
      _filterStates = filterStates;
      lastIndexLoaded = 0;
      visiblePromoters = [];
      if (searchResults.isEmpty) {
        searchResults = filter.onFilterChanged(filterStates, allPromoters);
      } else {
        searchResults = filter.onFilterChanged(filterStates, unfilteredData);
      }
    });
    BlocProvider.of<PromoterObserverCubit>(context)
        .searchForPromoter(searchResults, 0);
  }

  void onSearchQueryChanged(String? query) {
    if (query != null) {
      final trimmedQuery = query.trim();
      setState(() {
        lastIndexLoaded = 0;
        visiblePromoters = [];
        searchResults = filter.onSearchQueryChanged(trimmedQuery, allPromoters);
        unfilteredData = searchResults;
        searchResults = filter.onFilterChanged(_filterStates, searchResults);
      });
    }
    BlocProvider.of<PromoterObserverCubit>(context)
        .searchForPromoter(searchResults, 0);
  }

  void clearSearch() {
    setState(() {
      visiblePromoters = [];
      searchResults = [];
      unfilteredData = [];
      _searchController.clear();
    });
    BlocProvider.of<PromoterObserverCubit>(context)
        .getPromoters(allPromoters, 0);
  }

  void resetPromoters(List<Promoter> promoters) {
    allPromoters = promoters;
    unfilteredData = allPromoters;
    visiblePromoters = [];
    searchResults = [];
    lastIndexLoaded = 0;
    _searchController.clear();
  }

  void submitDeletion(String id) {
    CustomNavigator.pop();
    Modular.get<PromoterCubit>().deletePromoter(id);
  }

  void showDeleteAlert(String id) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Soll der ausgewählte Promoter wirklich gelöscht werden?",
              message:
                  "Das Löschen des Promoters kann nicht rückgängig gemacht werden.",
              actionButtonTitle: "Löschen",
              cancelButtonTitle: "Abbrechen",
              actionButtonAction: () => submitDeletion(id),
              cancelButtonAction: () => CustomNavigator.pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocConsumer<PromoterObserverCubit, PromoterObserverState>(
      listener: (context, state) {
        if (state is PromotersObserverSuccess) {
          resetPromoters(state.promoters);
          BlocProvider.of<PromoterObserverCubit>(context)
              .getPromoters(allPromoters, lastIndexLoaded);
        } else if (state is PromotersObserverGetElementsSuccess) {
          if (state.promoters.isEmpty) {
            lastIndexLoaded = visiblePromoters.length;
          } else {
            setState(() {
              visiblePromoters.addAll(state.promoters);
              lastIndexLoaded = visiblePromoters.length;
              _isLoading = false;
            });
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<PromoterCubit, PromoterState>(
            listener: (context, promoterState) {
          if (promoterState is PromoterDeleteSuccessState) {
            CustomSnackBar.of(context)
                .showCustomSnackBar("Promoter erfolgreich gelöscht!");
            BlocProvider.of<PromoterObserverCubit>(context)
                .observeAllPromoters();
          } else if (promoterState is PromoterDeleteFailureState) {
            CustomSnackBar.of(context).showCustomSnackBar(
                "Promoter löschen fehlgeschlagen!", SnackBarType.failure);
          }
        }, builder: (context, promoterState) {
          if (state is PromotersObserverGetElementsSuccess) {
            if (state.promoters.isEmpty && visiblePromoters.isEmpty) {
              return EmptyPage(
                  icon: Icons.person_add,
                  title: localization.promoter_overview_empty_page_title,
                  subTitle: localization.promoter_overview_empty_page_subtitle,
                  buttonTitle:
                      localization.promoter_overview_empty_page_button_title,
                  onTap: () {
                    widget.tabController.animateTo(1);
                  });
            } else {
              return headerWithChildren([
                const SizedBox(height: 24),
                if (_viewState == PromotersOverviewViewState.grid) ...[
                  PromoterOverviewGrid(
                    controller: _controller,
                    promoters: visiblePromoters,
                    deletePressed: (promoterId) => showDeleteAlert(promoterId),
                  )
                ] else ...[
                  PromoterOverviewList(
                      controller: _controller, promoters: visiblePromoters)
                ]
              ]);
            }
          } else if (state is PromotersObserverSearchNotFound) {
            return headerWithChildren([
              const SizedBox(height: 24),
              const PromoterOverviewNoSearchResultsView(),
              const SizedBox(height: 24)
            ]);
          } else if (state is PromotersObserverFailure) {
            return ErrorView(
                title: localization.promoter_overview_error_view_title,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<PromoterObserverCubit>(context)
                          .observeAllPromoters()
                    });
          } else if (promoterState is PromoterLoadingState) {
            return const LoadingIndicator();
          } else {
            return const LoadingIndicator();
          }
        });
      },
    );
  }

  Widget headerWithChildren(List<Widget> children) {
    children.insert(0, header());
    return CardContainer(
        maxWidth: 800,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children));
  }

  Widget header() {
    return PromoterOverviewHeader(
        searchController: _searchController,
        onSearchQueryChanged: onSearchQueryChanged,
        clearSearch: clearSearch,
        onFilterChanged: onFilterChanged,
        onViewStateButtonPressed: (viewState) {
          setState(() {
            _viewState = viewState;
          });
        });
  }

  void _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (!_isLoading) {
        _isLoading = true;
        if (searchResults.isEmpty) {
          BlocProvider.of<PromoterObserverCubit>(context)
              .getPromoters(allPromoters, lastIndexLoaded);
        } else {
          BlocProvider.of<PromoterObserverCubit>(context)
              .searchForPromoter(searchResults, lastIndexLoaded);
        }
      }
    }
  }
}
