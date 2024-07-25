import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'company_request_state.dart';

class CompanyRequestCubit extends Cubit<CompanyRequestState> {
  final CompanyRepository companyRepo;
  final UserRepository userRepo;

  CompanyRequestCubit(this.companyRepo, this.userRepo)
      : super(CompanyRequestInitial());

  void getPendingCompanyRequest(String id) async {
    emit(CompanyRequestLoadingState());
    final failureOrSuccess = await companyRepo.getPendingCompanyRequest(id);
    failureOrSuccess.fold(
        (failure) => emit(PendingCompanyRequestFailureState(failure: failure)),
        (request) => emit(PendingCompanyRequestSuccessState(request: request)));
  }

  void processCompanyRequest(String id, String userID, bool accepted) async {
    emit(CompanyRequestLoadingState());
    final failureOrSuccess =
        await companyRepo.processCompanyRequest(id, userID, accepted);
    failureOrSuccess.fold(
        (failure) => emit(ProcessCompanyRequestFailureState(failure: failure)),
        (_) => emit(ProcessCompanyRequestSuccessState()));
  }
}
