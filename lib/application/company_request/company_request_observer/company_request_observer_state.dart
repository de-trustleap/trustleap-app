part of 'company_request_observer_cubit.dart';

sealed class CompanyRequestObserverState extends Equatable {
  const CompanyRequestObserverState();

  @override
  List<Object> get props => [];
}

final class CompanyRequestObserverInitial extends CompanyRequestObserverState {}

class CompanyRequestObserverLoading extends CompanyRequestObserverState {}

class CompanyRequestObserverFailure extends CompanyRequestObserverState {
  final DatabaseFailure failure;

  const CompanyRequestObserverFailure({required this.failure});
}

class CompanyRequestObserverSuccess extends CompanyRequestObserverState {
  final List<CompanyRequest> requests;

  const CompanyRequestObserverSuccess({required this.requests});
}

class CompanyRequestObserverGetUsersFailureState
    extends CompanyRequestObserverState {
  final DatabaseFailure failure;

  const CompanyRequestObserverGetUsersFailureState({
    required this.failure,
  });
}

class CompanyRequestObserverGetUsersSuccessState
    extends CompanyRequestObserverState {
  final List<CustomUser> users;

  const CompanyRequestObserverGetUsersSuccessState({
    required this.users,
  });
}
