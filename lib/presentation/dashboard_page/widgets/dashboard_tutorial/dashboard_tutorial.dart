import 'package:finanzbegleiter/application/dashboard/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_tutorial/dashboard_tutorial_step_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardTutorial extends StatefulWidget {
  final CustomUser user;
  final VoidCallback onUserUpdate;
  const DashboardTutorial(
      {super.key, required this.user, required this.onUserUpdate});

  @override
  State<DashboardTutorial> createState() => _DashboardTutorialState();
}

class _DashboardTutorialState extends State<DashboardTutorial> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    Modular.get<DashboardTutorialCubit>().getStep(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    final cubit = Modular.get<DashboardTutorialCubit>();
    return BlocBuilder<DashboardTutorialCubit, DashboardTutorialState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is DashboardTutorialSuccess) {
          _currentStep = state.currentStep;
        }

        if (state is DashboardTutorialFailure) {
          return ErrorView(
              title: localization.dashboard_tutorial_error_title,
              message: localization.dashboard_tutorial_error_message,
              callback: () =>
                  Modular.get<DashboardTutorialCubit>().getStep(widget.user));
        } else {
          return CardContainer(
              maxWidth: 1000,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.dashboard_tutorial_title,
                      style: themeData.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DashboardTutorialStepList(
                      currentStep: _currentStep,
                      user: widget.user,
                      onUserUpdate: widget.onUserUpdate,
                    )
                  ]));
        }
      },
    );
  }
}
