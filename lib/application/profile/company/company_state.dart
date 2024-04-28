// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_cubit.dart';

sealed class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

final class CompanyInitial extends CompanyState {}

class CompanyShowValidationState extends CompanyState {}

class CompanyUpdateContactInformationLoadingState extends CompanyState {}

class CompanyUpdateContactInformationFailureState extends CompanyState {
  final DatabaseFailure failure;

  const CompanyUpdateContactInformationFailureState({
    required this.failure,
  });
}

class CompanyUpdateContactInformationSuccessState extends CompanyState {}