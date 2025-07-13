import 'package:finanzbegleiter/application/dashboard/overview/dashboard_overview_cubit.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  @override
  void initState() {
    super.initState();
    Modular.get<DashboardOverviewCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = Modular.get<DashboardOverviewCubit>();
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is DashboardOverviewGetUserFailureState) {
          return ErrorView(
              title: "User nicht gefunden",
              message:
                  "Der aktuelle Nutzer wurde nicht gefunden. Bitte versuche es später nochmal.",
              callback: () =>
                  {Modular.get<DashboardOverviewCubit>().getUser()});
        } else if (state is DashboardOverviewGetUserSuccessState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Hi ${state.user.firstName}!",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DashboardRecommendations(user: state.user)
            ],
          );
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
