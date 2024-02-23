part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileShowValidationState extends ProfileState {}

class ProfileFailureState extends ProfileState {
  final DatabaseFailure failure;

  ProfileFailureState({required this.failure});
}
