// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class CreateUserEvent extends UserEvent {
  final CustomUser user;

  CreateUserEvent({
    required this.user,
  });
}
