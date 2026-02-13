import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';
import 'package:finanzbegleiter/features/legals/domain/legals_repository.dart';

part 'admin_legals_state.dart';

class AdminLegalsCubit extends Cubit<AdminLegalsState> {
  final LegalsRepository legalsRepo;
  AdminLegalsCubit(this.legalsRepo) : super(AdminLegalsInitial());

  void getLegals() async {
    emit(AdminGetLegalsLoadingState());
    final failureOrSuccess = await legalsRepo.getAllLegals();
    failureOrSuccess.fold(
        (failure) => emit(AdminGetLegalsFailureState(failure: failure)),
        (legals) => emit(AdminGetLegalsSuccessState(legals: legals)));
  }

  void saveLegals(Legals? legals) async {
    if (legals == null) {
      emit(AdminLegalsShowValidationState());
    } else {
      emit(AdminSaveLegalsLoadingState());
      final failureOrSuccess = await legalsRepo.saveLegals(legals);
      failureOrSuccess.fold(
          (failure) => emit(AdminSaveLegalsFailureState(failure: failure)),
          (_) => emit(AdminSaveLegalsSuccessState()));
    }
  }
}
