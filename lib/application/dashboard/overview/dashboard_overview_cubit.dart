import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'dashboard_overview_state.dart';

class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  final UserRepository userRepo;
  final DashboardRepository dashboardRepo;
  DashboardOverviewCubit(this.userRepo, this.dashboardRepo)
      : super(DashboardOverviewInitial());

  void getUser() async {
    emit(DashboardOverviewGetUserLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold(
        (failure) =>
            emit(DashboardOverviewGetUserFailureState(failure: failure)),
        (user) => emit(DashboardOverviewGetUserSuccessState(user: user)));
  }
}
