part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateUnAuthenticated extends AuthState {}

class AuthStateLoading extends AuthState {}
