// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_overview_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_grid.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_list.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum PromotersOverviewViewState { grid, list }

class PromotersOverviewPage extends StatefulWidget {
  const PromotersOverviewPage({
    super.key,
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
  PromoterSearchOption _selectedSearchOption = PromoterSearchOption.fullName;

  @override
  void initState() {
    super.initState();
    final userObserverCubit = Modular.get<UserObserverCubit>();
    final currentUserState = userObserverCubit.state;
    if (currentUserState is UserObserverSuccess) {
      Modular.get<PromoterObserverCubit>()
          .observePromotersForUser(currentUserState.user);
    }
    _controller.addListener(_onScroll);
    _filterStates = PromoterOverviewFilterStates();
  }

  @override
  void dispose() {
    _controller.dispose();
    Modular.get<PromoterObserverCubit>().stopObserving();
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
    Modular.get<PromoterObserverCubit>().searchForPromoter(searchResults, 0);
  }

  void onSearchQueryChanged(String? query) {
    if (query != null) {
      final trimmedQuery = query.trim();
      setState(() {
        lastIndexLoaded = 0;
        visiblePromoters = [];
        searchResults = filter.onSearchQueryChanged(
            trimmedQuery, allPromoters, _selectedSearchOption);
        unfilteredData = searchResults;
        searchResults = filter.onFilterChanged(_filterStates, searchResults);
      });
    }
    Modular.get<PromoterObserverCubit>().searchForPromoter(searchResults, 0);
  }

  void clearSearch() {
    setState(() {
      visiblePromoters = [];
      searchResults = [];
      unfilteredData = [];
      _searchController.clear();
    });
    Modular.get<PromoterObserverCubit>().getPromoters(allPromoters, 0);
  }

  void resetPromoters(List<Promoter> promoters) {
    allPromoters = promoters;
    unfilteredData = allPromoters;
    visiblePromoters = [];
    searchResults = [];
    lastIndexLoaded = 0;
    _searchController.clear();
  }

  void onSearchOptionChanged(PromoterSearchOption option) {
    setState(() {
      _selectedSearchOption = option;
    });
    onSearchQueryChanged(_searchController.text);
  }

  void submitDeletion(String id, bool isRegistered) {
    CustomNavigator.of(context).pop();
    Modular.get<PromoterCubit>().deletePromoter(id, isRegistered);
  }

  void showDeleteAlert(String id, bool isRegistered,
      AppLocalizations localization, CustomNavigatorBase navigator) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localization.promoter_overview_delete_promoter_alert_title,
              message: localization
                  .promoter_overview_delete_promoter_alert_description,
              actionButtonTitle: localization
                  .promoter_overview_delete_promoter_alert_delete_button,
              cancelButtonTitle: localization
                  .promoter_overview_delete_promoter_alert_cancel_button,
              actionButtonAction: () => submitDeletion(id, isRegistered),
              cancelButtonAction: () => navigator.pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final promoterCubit = Modular.get<PromoterCubit>();
    final promoterObserverCubit = Modular.get<PromoterObserverCubit>();
    final userObserverCubit = Modular.get<UserObserverCubit>();

    return MultiBlocListener(
        listeners: [
          BlocListener<UserObserverCubit, UserObserverState>(
            bloc: userObserverCubit,
            listener: (context, state) {
              if (state is UserObserverSuccess) {
                promoterObserverCubit.observePromotersForUser(state.user);
              }
            },
          ),
        ],
        child: BlocConsumer<PromoterObserverCubit, PromoterObserverState>(
          bloc: promoterObserverCubit,
          listener: (context, state) {
            if (state is PromotersObserverSuccess) {
              resetPromoters(state.promoters);
              Modular.get<PromoterObserverCubit>()
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
                bloc: promoterCubit,
                listener: (context, promoterState) {
                  if (promoterState is PromoterDeleteSuccessState) {
                    CustomSnackBar.of(context).showCustomSnackBar(localization
                        .promoter_overview_delete_promoter_success_snackbar);
                  } else if (promoterState is PromoterDeleteFailureState) {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization
                            .promoter_overview_delete_promoter_failure_snackbar,
                        SnackBarType.failure);
                  }
                },
                builder: (context, promoterState) {
                  if (promoterState is PromoterLoadingState) {
                    return const LoadingIndicator();
                  }
                  if (state is PromotersObserverGetElementsSuccess) {
                    if (state.promoters.isEmpty && visiblePromoters.isEmpty) {
                      return EmptyPage(
                          icon: Icons.person_add,
                          title:
                              localization.promoter_overview_empty_page_title,
                          subTitle: localization
                              .promoter_overview_empty_page_subtitle,
                          buttonTitle: localization
                              .promoter_overview_empty_page_button_title,
                          onTap: () {
                            Modular.to.navigate(
                                "${RoutePaths.homePath}${RoutePaths.promotersPath}${RoutePaths.promotersRegisterPath}");
                          });
                    } else {
                      return headerWithChildren([
                        const SizedBox(height: 24),
                        if (_viewState == PromotersOverviewViewState.grid) ...[
                          PromoterOverviewGrid(
                            controller: _controller,
                            promoters: visiblePromoters,
                            deletePressed: (promoterId, isRegistered) =>
                                showDeleteAlert(promoterId, isRegistered,
                                    localization, navigator),
                          )
                        ] else ...[
                          PromoterOverviewList(
                              controller: _controller,
                              promoters: visiblePromoters)
                        ]
                      ], responsiveValue);
                    }
                  } else if (state is PromotersObserverSearchNotFound) {
                    return headerWithChildren([
                      const SizedBox(height: 24),
                      NoSearchResultsView(
                          title: localization
                              .promoter_overview_no_search_results_title,
                          description: localization
                              .promoter_overview_no_search_results_subtitle),
                      const SizedBox(height: 24)
                    ], responsiveValue);
                  } else if (state is PromotersObserverFailure) {
                    return ErrorView(
                        title: localization.promoter_overview_error_view_title,
                        message: DatabaseFailureMapper.mapFailureMessage(
                            state.failure, localization),
                        callback: () {
                          final userObserverCubit =
                              Modular.get<UserObserverCubit>();
                          final currentUserState = userObserverCubit.state;
                          if (currentUserState is UserObserverSuccess) {
                            Modular.get<PromoterObserverCubit>()
                                .observePromotersForUser(currentUserState.user);
                          }
                        });
                  } else {
                    return const LoadingIndicator();
                  }
                });
          },
        ));
  }

  Widget headerWithChildren(
      List<Widget> children, ResponsiveBreakpointsData responsiveValue) {
    children.insert(0, header());
    return Column(children: [
      CardContainer(
          maxWidth: 1200,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children)),
      SizedBox(height: responsiveValue.isMobile ? 40 : 80),
    ]);
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
        },
        onSearchOptionChanged: onSearchOptionChanged);
  }

  void _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (!_isLoading) {
        _isLoading = true;
        if (searchResults.isEmpty) {
          Modular.get<PromoterObserverCubit>()
              .getPromoters(allPromoters, lastIndexLoaded);
        } else {
          Modular.get<PromoterObserverCubit>()
              .searchForPromoter(searchResults, lastIndexLoaded);
        }
      }
    }
  }
}
