part of 'user_cubit.dart';

sealed class UserState {}

final class UserInitial extends UserState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class UserLoading extends UserState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class UserSuccess extends UserState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class UserFailure extends UserState with EquatableMixin {
  final DatabaseFailure failure;

  UserFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
