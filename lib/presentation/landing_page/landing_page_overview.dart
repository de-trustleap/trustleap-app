import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageOverview extends StatelessWidget {
  const LandingPageOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocBuilder<LandingPageCubit, LandingPageObserverState>(
      builder: (context, state) {
        if (state is LandingPageObserverSuccess) {
          return CardContainer(
            child: LayoutBuilder(builder: (context, constraints) {
          final themeData = Theme.of(context);
          return Column(
            children: [
              Text("Landing Pages Übersicht",
                  style: themeData.textTheme.headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              LandingPageOverviewGrid(landingpages: state.landingPages,)
            ],
          );
        }));
        } else if (state is LandingPageObserverFailure) {
          return ErrorView(
              title: localization.landingpage_overview_error_view_title,
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () => {
                    BlocProvider.of<LandingPageCubit>(context)
                        .observeAllLandingPages()
                  });
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
