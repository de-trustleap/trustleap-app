// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepo;
  final AuthRepository authRepo;

  CompanyCubit(
    this.companyRepo,
    this.authRepo
  ) : super(CompanyInitial());

  void updateCompany(Company? company) async {
    if (company == null) {
      emit(CompanyShowValidationState());
    } else {
      emit(CompanyUpdateContactInformationLoadingState());
      final failureOrSuccess = await companyRepo.updateCompany(company);
      failureOrSuccess.fold(
          (failure) => emit(
              CompanyUpdateContactInformationFailureState(failure: failure)),
          (_) => emit(CompanyUpdateContactInformationSuccessState()));
    }
  }

  void getCompany(String companyID) async {
    emit(GetCompanyLoadingState());
    final failureOrSuccess = await companyRepo.getCompany(companyID);
    failureOrSuccess.fold(
        (failure) => emit(GetCompanyFailureState(failure: failure)),
        (company) => emit(GetCompanySuccessState(company: company)));
  }

  void registerCompany(Company? company) async {
    if (company == null) {
      emit(CompanyShowValidationState());
    } else {
      emit(CompanyRegisterLoadingState());
      final failureOrSuccess = await companyRepo.registerCompany(company);
      failureOrSuccess.fold(
          (failure) => emit(CompanyRegisterFailureState(failure: failure)),
          (_) => emit(CompanyRegisterSuccessState()));
    }
  }

  void getCurrentUser() async {
    // ignore: await_only_futures
    final currentUser = await authRepo.getCurrentUser();
    emit(CompanyGetCurrentUserSuccessState(user: currentUser));
  }
}
