// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/admin/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/features/admin/domain/company_request.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/admin/presentation/company_requests/company_request_overview_list_tile.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CompanyRequestDetailsModel {
  final CompanyRequest request;
  final CustomUser user;

  CompanyRequestDetailsModel({
    required this.request,
    required this.user,
  });
}

class CompanyRequestsOverview extends StatefulWidget {
  const CompanyRequestsOverview({super.key});

  @override
  State<CompanyRequestsOverview> createState() =>
      _CompanyRequestsOverviewState();
}

class _CompanyRequestsOverviewState extends State<CompanyRequestsOverview> {
  List<CompanyRequest> requests = [];

  List<CompanyRequestDetailsModel> models = [];

  List<CompanyRequestDetailsModel> createModels(
      List<CompanyRequest> requests, List<CustomUser> users) {
    List<CompanyRequestDetailsModel> models = [];
    for (var request in requests) {
      final id = request.userID;
      if (id == null || id.value.isEmpty) {
        continue;
      } else {
        CustomUser user = users.firstWhere((user) => user.id == id);
        models.add(CompanyRequestDetailsModel(request: request, user: user));
      }
    }
    return models;
  }

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
      } else if (state is CompanyRequestObserverGetUsersSuccessState) {
        setState(() {
          models = createModels(requests, state.users);
        });
      }
    }), builder: ((context, state) {
      return ListView(shrinkWrap: true, children: [
        CardContainer(child: LayoutBuilder(builder: ((context, constraints) {
          if (state is CompanyRequestObserverGetUsersSuccessState) {
            if (state.users.isEmpty) {
              return EmptyPage(
                  icon: Icons.free_breakfast,
                  title:
                      localization.admin_company_request_overview_empty_title,
                  subTitle:
                      localization.admin_company_request_overview_empty_body,
                  buttonTitle: "",
                  isButtonHidden: true,
                  onTap: null);
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                      localization.admin_company_request_overview_title,
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  ListView.builder(
                      itemCount: models.length,
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
                                  model: models[index]),
                            )));
                      })
                ],
              );
            }
          } else if (state is CompanyRequestObserverFailure) {
            return ErrorView(
                title: localization.admin_company_request_overview_error,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<CompanyRequestObserverCubit>(context)
                          .observeAllPendingCompanyRequests()
                    });
          } else if (state is CompanyRequestObserverGetUsersFailureState) {
            return ErrorView(
                title: localization.admin_company_request_overview_error,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      BlocProvider.of<CompanyRequestObserverCubit>(context)
                          .observeAllPendingCompanyRequests()
                    });
          } else {
            return const LoadingIndicator();
          }
        })))
      ]);
    }));
  }
}
