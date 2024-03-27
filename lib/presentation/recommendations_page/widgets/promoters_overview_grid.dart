// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoter_overview_list_tile.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview_empty_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview_grid_tile.dart';
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
  PromotersOverviewViewState viewState = PromotersOverviewViewState.grid;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    return BlocBuilder<PromoterObserverCubit, PromoterObserverState>(
      builder: (context, state) {
        if (state is PromotersObserverSuccess) {
          if (state.promoters.isEmpty) {
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
                            Text("Meine Empfehlungsgeber",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                            const Spacer(),
                            PromoterOverviewViewStateButton(
                                onSelected: (selectedValue) {
                              setState(() {
                                viewState = selectedValue;
                              });
                            })
                          ]),
                      const SizedBox(height: 24),
                      if (viewState == PromotersOverviewViewState.grid) ...[
                        gridView(responsiveValue, state.promoters)
                      ] else ...[
                        listView(state.promoters)
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
    return ListView.builder(
        itemCount: promoters.length,
        shrinkWrap: true,
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
        });
  }

  Widget gridView(
      ResponsiveBreakpointsData responsiveValue, List<Promoter> promoters) {
    return AnimationLimiter(
      child: GridView.count(
          crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
          crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
          mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
          shrinkWrap: true,
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
}
