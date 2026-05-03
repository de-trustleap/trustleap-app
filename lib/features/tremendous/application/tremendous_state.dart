part of 'tremendous_cubit.dart';

sealed class TremendousState {}

final class TremendousInitial extends TremendousState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class TremendousConnectingState extends TremendousState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class TremendousOAuthReadyState extends TremendousState with EquatableMixin {
  final String authUrl;

  TremendousOAuthReadyState({required this.authUrl});

  @override
  List<Object> get props => [authUrl];
}

class TremendousConnectedState extends TremendousState with EquatableMixin {
  final TremendousOrganization? organization;

  TremendousConnectedState({this.organization});

  @override
  List<Object> get props => [if (organization != null) organization!];
}

class TremendousNotConnectedState extends TremendousState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class TremendousConnectionFailureState extends TremendousState
    with EquatableMixin {
  final DatabaseFailure failure;

  TremendousConnectionFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class TremendousDisconnectedState extends TremendousState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class TremendousCatalogLoadingState extends TremendousState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class TremendousCatalogSuccessState extends TremendousState with EquatableMixin {
  final List<TremendousProduct> products;
  final List<TremendousFundingSource> fundingSources;

  TremendousCatalogSuccessState({
    required this.products,
    required this.fundingSources,
  });

  @override
  List<Object> get props => [products, fundingSources];
}

class TremendousCatalogFailureState extends TremendousState with EquatableMixin {
  final DatabaseFailure failure;

  TremendousCatalogFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
