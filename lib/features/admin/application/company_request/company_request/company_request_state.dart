// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_request_cubit.dart';

sealed class CompanyRequestState extends Equatable {
  const CompanyRequestState();

  @override
  List<Object> get props => [];
}

final class CompanyRequestInitial extends CompanyRequestState {}

class CompanyRequestLoadingState extends CompanyRequestState {}

class PendingCompanyRequestFailureState extends CompanyRequestState {
  final DatabaseFailure failure;

  const PendingCompanyRequestFailureState({
    required this.failure,
  });
}

class PendingCompanyRequestSuccessState extends CompanyRequestState {
  final CompanyRequest request;

  const PendingCompanyRequestSuccessState({
    required this.request,
  });
}

class ProcessCompanyRequestFailureState extends CompanyRequestState {
  final DatabaseFailure failure;

  const ProcessCompanyRequestFailureState({
    required this.failure,
  });
}

class ProcessCompanyRequestSuccessState extends CompanyRequestState {}
