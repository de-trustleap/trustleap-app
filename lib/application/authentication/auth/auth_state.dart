// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthStateAuthenticated extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthStateAuthenticatedAsAdmin extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthStateUnAuthenticated extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthStateAuthenticationLoading extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthShowValidationState extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthPasswordResetSuccessState extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthPasswordResetLoadingState extends AuthState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthPasswordResetFailureState extends AuthState with EquatableMixin {
  final AuthFailure failure;

  AuthPasswordResetFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}
