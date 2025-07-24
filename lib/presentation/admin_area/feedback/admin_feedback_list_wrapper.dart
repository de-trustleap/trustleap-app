import 'package:finanzbegleiter/application/feedback/admin_feedback/admin_feedback_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/feedback/admin_feedback_list.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminFeedbackListWrapper extends StatefulWidget {
  const AdminFeedbackListWrapper({super.key});

  @override
  State<AdminFeedbackListWrapper> createState() =>
      _AdminFeedbackListWrapperState();
}

class _AdminFeedbackListWrapperState extends State<AdminFeedbackListWrapper> {
  @override
  void initState() {
    super.initState();
    Modular.get<AdminFeedbackCubit>().getFeedbackItems();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<AdminFeedbackCubit>();

    return BlocBuilder<AdminFeedbackCubit, AdminFeedbackState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is AdminFeedbackNoFeedbackFoundState) {
          return EmptyPage(
              icon: Icons.person_add,
              title: "Kein Feedback gefunden",
              subTitle:
                  "Es scheint noch kein Nutzer Feedback hinterlassen zu haben.",
              buttonTitle: "Aktualisieren",
              onTap: () => cubit.getFeedbackItems());
        } else if (state is AdminFeedbackGetFeedbackFailureState) {
          return ErrorView(
              title: "Es ist ein Fehler aufgetreten",
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () => cubit.getFeedbackItems());
        } else if (state is AdminFeedbackGetFeedbackSuccessState) {
          return AdminFeedbackList(feedbackItems: state.feedbacks);
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
