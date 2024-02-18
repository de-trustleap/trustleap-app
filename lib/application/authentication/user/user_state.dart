part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserSuccess extends UserState {}

final class UserFailure extends UserState {
  final DatabaseFailure failure;

  UserFailure({required this.failure});
}
