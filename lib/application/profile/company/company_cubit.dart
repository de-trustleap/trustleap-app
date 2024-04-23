// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepo;

  CompanyCubit(
    this.companyRepo,
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
}
