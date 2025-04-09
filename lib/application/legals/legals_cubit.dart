import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/repositories/legals_repository.dart';

part 'legals_state.dart';

class LegalsCubit extends Cubit<LegalsState> {
  final LegalsRepository legalsRepo;
  LegalsCubit(this.legalsRepo) : super(LegalsInitial());

  void getLegals(LegalsType type) async {
    emit(GetLegalsLoadingState());
    final failureOrSuccess = await legalsRepo.getLegals(type);
    failureOrSuccess.fold(
        (failure) => emit(GetLegalsFailureState(failure: failure)),
        (legals) => emit(GetLegalsSuccessState(text: legals)));
  }
}
