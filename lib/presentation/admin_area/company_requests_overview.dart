import 'package:finanzbegleiter/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_request_overview_list_tile.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CompanyRequestsOverview extends StatelessWidget {
  CompanyRequestsOverview({super.key});

  List<CompanyRequest> requests = [];

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return BlocConsumer<CompanyRequestObserverCubit,
        CompanyRequestObserverState>(listener: ((context, state) {
      if (state is CompanyRequestObserverSuccess) {
        requests = state.requests;
        BlocProvider.of<CompanyRequestObserverCubit>(context)
            .getAllUsersForCompanyRequests(state.requests);
      }
    }), builder: ((context, state) {
      return ListView(shrinkWrap: true, children: [
        CardContainer(child: LayoutBuilder(builder: ((context, constraints) {
          final maxWidth = constraints.maxWidth;
          if (state is CompanyRequestObserverGetUsersSuccessState) {
            print("REQUEST LENGTH: ${requests.length}");
            print("USERS LENGTH: ${state.users.length}");
            return Column(
              children: [
                Text("Anfragen für Unternehmensregistrierung",
                    style: themeData.textTheme.headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                ListView.builder(
                    itemCount: requests.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 150),
                          child: ScaleAnimation(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: CompanyRequestOverviewListTile(
                                companyRequest: requests[index],
                                user: state.users[index]),
                          )));
                    })
              ],
            );
          } else if (state is CompanyRequestObserverFailure) {
            return ErrorView(
                title: "Es ist ein Fehler aufgetreten",
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<CompanyRequestObserverCubit>(context)
                          .observeAllPendingCompanyRequests()
                    });
          } else if (state is CompanyRequestObserverGetUsersFailureState) {
            return ErrorView(
                title: "Es ist ein Fehler aufgetreten",
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<CompanyRequestObserverCubit>(context)
                          .observeAllPendingCompanyRequests()
                    });
          } else {
            print("THE STATE: $state");
            return const LoadingIndicator();
          }
        })))
      ]);
    }));
  }
}
