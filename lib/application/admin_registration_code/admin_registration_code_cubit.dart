import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/repositories/admin_registration_code_repository.dart';

part 'admin_registration_code_state.dart';

class AdminRegistrationCodeCubit extends Cubit<AdminRegistrationCodeState> {
  final AdminRegistrationCodeRepository adminRegistrationCodeRepo;
  AdminRegistrationCodeCubit(this.adminRegistrationCodeRepo)
      : super(AdminRegistrationCodeInitial());

  void sendAdminRegistrationCode(
      String email, String code, String firstName) async {
    if (email == "" || code == "" || firstName == "") {
      emit(AdminRegistrationCodeSendSuccessfulShowValidationState());
    } else {
      emit(AdminRegistrationCodeSendLoading());
      final failureOrSuccess =
          await adminRegistrationCodeRepo.sendRegistrationCodeFromAdmin(
              email: email, code: code, firstName: firstName);
      failureOrSuccess.fold(
          (failure) => emit(AdminRegistrationCodeSendFailure(failure: failure)),
          (_) => emit(AdminRegistrationCodeSendSuccessful()));
    }
  }
}
