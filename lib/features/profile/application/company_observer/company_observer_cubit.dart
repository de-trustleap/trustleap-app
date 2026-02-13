// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/features/profile/domain/company_repository.dart';

part 'company_observer_state.dart';

class CompanyObserverCubit extends Cubit<CompanyObserverState> {
  final CompanyRepository companyRepo;
  StreamSubscription<Either<DatabaseFailure, Company>>? _companyStreamSub;

  CompanyObserverCubit(
    this.companyRepo,
  ) : super(CompanyObserverInitial());

  void observeCompany(String companyID) async {
    emit(CompanyObserverLoading());
    await _companyStreamSub?.cancel();
    _companyStreamSub = companyRepo
        .observeCompany(companyID)
        .listen((failureOrSuccess) => companyObserverUpdated(failureOrSuccess));
  }

  void companyObserverUpdated(
      Either<DatabaseFailure, Company> failureOrCompany) async {
    emit(CompanyObserverLoading());
    failureOrCompany.fold(
        (failure) => emit(CompanyObserverFailure(failure: failure)),
        (company) => emit(CompanyObserverSuccess(company: company)));
  }

  @override
  Future<void> close() async {
    await _companyStreamSub?.cancel();
    return super.close();
  }
}
