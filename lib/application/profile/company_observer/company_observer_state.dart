part of 'company_observer_cubit.dart';

sealed class CompanyObserverState extends Equatable {
  const CompanyObserverState();

  @override
  List<Object> get props => [];
}

final class CompanyObserverInitial extends CompanyObserverState {}

final class CompanyObserverLoading extends CompanyObserverState {}

final class CompanyObserverFailure extends CompanyObserverState {
  final DatabaseFailure failure;

  const CompanyObserverFailure({required this.failure});
}

final class CompanyObserverSuccess extends CompanyObserverState {
  final Company company;

  const CompanyObserverSuccess({required this.company});
}