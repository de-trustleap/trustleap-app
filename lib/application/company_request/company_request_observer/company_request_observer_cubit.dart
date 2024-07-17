import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';

part 'company_request_observer_state.dart';

class CompanyRequestObserverCubit extends Cubit<CompanyRequestObserverState> {
  final CompanyRepository companyRepo;
  StreamSubscription<Either<DatabaseFailure, List<CompanyRequest>>>?
      _companyRequestsStreamSub;

  CompanyRequestObserverCubit(this.companyRepo)
      : super(CompanyRequestObserverInitial());

  void observeAllPendingCompanyRequests() async {
    emit(CompanyRequestObserverLoading());
    await _companyRequestsStreamSub?.cancel();
    _companyRequestsStreamSub = companyRepo.observeCompanyRequests().listen(
        (failureOrSuccess) => companyRequestsObserverUpdated(failureOrSuccess));
  }

  void companyRequestsObserverUpdated(
      Either<DatabaseFailure, List<CompanyRequest>> failureOrSuccess) async {
    emit(CompanyRequestObserverLoading());
    failureOrSuccess.fold(
        (failure) => emit(CompanyRequestObserverFailure(failure: failure)),
        (requests) => emit(CompanyRequestObserverSuccess(requests: requests)));
  }

  void getAllUsersForCompanyRequests(List<CompanyRequest> requests) async {
    emit(CompanyRequestObserverLoading());
    final ids = requests.map((e) => e.userID?.value ?? "").toList();
    final failureOrSuccess =
        await companyRepo.getAllUsersForPendingCompanyRequests(ids);
    failureOrSuccess.fold(
        (failure) =>
            emit(CompanyRequestObserverGetUsersFailureState(failure: failure)),
        (users) =>
            emit(CompanyRequestObserverGetUsersSuccessState(users: users)));
  }

  @override
  Future<void> close() async {
    await _companyRequestsStreamSub?.cancel();
    return super.close();
  }
}
