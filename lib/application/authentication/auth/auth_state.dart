part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateUnAuthenticated extends AuthState {}
