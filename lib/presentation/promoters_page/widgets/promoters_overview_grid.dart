// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview_list_tile.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview_searchbar.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoters_overview_empty_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum PromotersOverviewViewState { grid, list }

class PromotersOverviewGrid extends StatefulWidget {
  final TabController tabController;

  const PromotersOverviewGrid({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<PromotersOverviewGrid> createState() => _PromotersOverviewGridState();
}

class _PromotersOverviewGridState extends State<PromotersOverviewGrid> {
  PromotersOverviewViewState _viewState = PromotersOverviewViewState.grid;
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int lastIndexLoaded = 0;
  List<Promoter> allPromoters = [];
  List<Promoter> visiblePromoters = [];
  List<Promoter> searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSearchQueryChanged(String query) {
    setState(() {
      lastIndexLoaded = 0;
      visiblePromoters = [];
      searchResults = allPromoters.where((element) {
        if (element.firstName != null && element.lastName != null) {
          return element.firstName!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.firstName!.toLowerCase().contains(query.toLowerCase());
        } else {
          return false;
        }
      }).toList();
    });
    BlocProvider.of<PromoterObserverCubit>(context)
        .searchForPromoter(searchResults, 0);
  }

  void clearSearch() {
    setState(() {
      visiblePromoters = [];
      searchResults = [];
      _searchController.clear();
    });
    BlocProvider.of<PromoterObserverCubit>(context)
        .getPromoters(allPromoters, 0);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    return BlocConsumer<PromoterObserverCubit, PromoterObserverState>(
      listener: (context, state) {
        if (state is PromotersObserverSuccess) {
          allPromoters = state.promoters;
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
        } else if (state is PromotersObserverSearchSuccess) {
          if (state.promoters.isEmpty) {
            lastIndexLoaded = visiblePromoters.length;
          }
          setState(() {
            visiblePromoters = state.promoters;
            lastIndexLoaded = visiblePromoters.length;
            _isLoading = false;
          });
        }
      },
      builder: (context, state) {
        if (state is PromotersObserverSearchNotFound) {
          return const Center(child: Text("NOT FOUND!"));
        } else if (state is PromotersObserverGetElementsSuccess) {
          if (state.promoters.isEmpty && visiblePromoters.isEmpty) {
            return PromotersOverviewEmptyPage(registerPromoterTapped: () {
              widget.tabController.animateTo(1);
            });
          } else {
            return CardContainer(
                maxWidth: 800,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: responsiveValue.isDesktop ? 3 : 0,
                              child: Text("Meine Promoter",
                                  style: themeData.textTheme.headlineLarge!
                                      .copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                            ),
                            if (responsiveValue.isDesktop) ...[
                              const Spacer(),
                              Flexible(
                                  flex: 5,
                                  child: SearchBar(
                                    controller: _searchController,
                                    leading: const Icon(Icons.search),
                                    onChanged: onSearchQueryChanged,
                                    trailing: [
                                      IconButton(
                                          onPressed: () => clearSearch(),
                                          icon: const Icon(Icons.close))
                                    ],
                                    hintText: "Suche...",
                                  )),
                            ],
                            const Spacer(),
                            Flexible(
                              flex: responsiveValue.isDesktop ? 2 : 0,
                              child: PromoterOverviewViewStateButton(
                                  onSelected: (selectedValue) {
                                setState(() {
                                  _viewState = selectedValue;
                                });
                              }),
                            )
                          ]),
                      if (responsiveValue.smallerThan(DESKTOP)) ...[
                        const SizedBox(height: 12),
                        const PromoterOverviewSearchBar()
                      ],
                      const SizedBox(height: 24),
                      if (_viewState == PromotersOverviewViewState.grid) ...[
                        gridView(responsiveValue, visiblePromoters)
                      ] else ...[
                        listView(visiblePromoters)
                      ]
                    ]));
          }
        } else if (state is PromotersObserverFailure) {
          return ErrorView(
              title: "Ein Fehler beim Abruf der Daten ist aufgetreten.",
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () => {
                    BlocProvider.of<PromoterObserverCubit>(context)
                        .observeAllPromoters()
                  });
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }

  Widget listView(List<Promoter> promoters) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: ListView.builder(
          itemCount: promoters.length,
          shrinkWrap: true,
          controller: _controller,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 150),
              child: ScaleAnimation(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PromoterOverviewListTile(promoter: promoters[index]),
                ),
              ),
            );
          }),
    );
  }

  Widget gridView(
      ResponsiveBreakpointsData responsiveValue, List<Promoter> promoters) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: AnimationLimiter(
        child: GridView.count(
            crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
            crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
            mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
            shrinkWrap: true,
            controller: _controller,
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            childAspectRatio: calculateChildAspectRatio(responsiveValue),
            children: List.generate(promoters.length, (index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                  child: Center(
                      child: GridTile(
                          child: PromotersOverviewGridTile(
                              promoter: promoters[index]))),
                ),
              );
            })),
      ),
    );
  }

  double calculateChildAspectRatio(ResponsiveBreakpointsData responsiveValue) {
    if (responsiveValue.isDesktop) {
      return 0.85;
    } else if (responsiveValue.isTablet) {
      return 0.67;
    } else {
      return 0.8;
    }
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
