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
