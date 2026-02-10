part of 'promoter_cubit.dart';

sealed class PromoterState {
  const PromoterState();
}

final class PromoterInitial extends PromoterState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterShowValidationState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterLandingPagesMissingState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterCompanyMissingState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRegisterLoadingState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRegisterFailureState extends PromoterState
    with EquatableMixin {
  final DatabaseFailure failure;

  const PromoterRegisterFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

final class PromoterAlreadyExistsFailureState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterRegisteredSuccessState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterLoadingState extends PromoterState with EquatableMixin {
  final String? promoterId;

  const PromoterLoadingState({this.promoterId});

  @override
  List<Object?> get props => [promoterId];
}


final class PromoterGetLandingPagesFailureState extends PromoterState
    with EquatableMixin {
  final DatabaseFailure failure;

  const PromoterGetLandingPagesFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class PromoterGetLandingPagesSuccessState extends PromoterState
    with EquatableMixin {
  final List<LandingPage> landingPages;

  const PromoterGetLandingPagesSuccessState({required this.landingPages});

  @override
  List<Object?> get props => [landingPages];
}

final class PromoterNoLandingPagesState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterDeleteSuccessState extends PromoterState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterDeleteFailureState extends PromoterState
    with EquatableMixin {
  final DatabaseFailure failure;

  const PromoterDeleteFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class PromoterEditSuccessState extends PromoterState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PromoterEditFailureState extends PromoterState with EquatableMixin {
  final DatabaseFailure failure;

  const PromoterEditFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class PromoterGetSuccessState extends PromoterState with EquatableMixin {
  final Promoter promoter;

  const PromoterGetSuccessState({required this.promoter});

  @override
  List<Object?> get props => [promoter];
}

final class PromoterGetFailureState extends PromoterState with EquatableMixin {
  final DatabaseFailure failure;

  const PromoterGetFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
