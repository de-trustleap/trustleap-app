import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable {}

class ServerFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class EmailAlreadyInUseFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class InvalidEmailFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class UserDisabledFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class InvalidCredentialsFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class TooManyRequestsFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class UserMisMatchFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class InvalidVerificationCodeFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class InvalidVerificationIdFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class RequiresRecentLoginFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}

class MissingPasswordFailure extends AuthFailure {
  @override
  List<Object?> get props => [];
}
