import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/dashboard/domain/tutorial_repository.dart';

part 'dashboard_tutorial_state.dart';

class DashboardTutorialCubit extends Cubit<DashboardTutorialState> {
  final TutorialRepository tutorialRepo;
  DashboardTutorialCubit(this.tutorialRepo) : super(DashboardTutorialInitial());

  void getStep(CustomUser user) async {
    final failureOrSuccess = await tutorialRepo.getCurrentStep(user);
    failureOrSuccess
        .fold((failure) => emit(DashboardTutorialFailure(failure: failure)),
            (currentStep) {
      emit(DashboardTutorialSuccess(currentStep: currentStep));
    });
  }

  void setStep(CustomUser user, int? step) async {
    await tutorialRepo.setStep(user, step);
  }
}
