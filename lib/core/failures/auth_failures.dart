import 'package:dartz/dartz.dart';

abstract class AuthFailure {}

class ServerFailure extends AuthFailure {}

class EmailAlreadyInUseFailure extends AuthFailure {}

class InvalidEmailFailure extends AuthFailure {}

class WeakPasswordFailure extends AuthFailure {}

class UserDisabledFailure extends AuthFailure {}

class UserNotFoundFailure extends AuthFailure {}

class WrongPasswordFailure extends AuthFailure {}

class InvalidCredentialsFailure extends AuthFailure {}

class TooManyRequestsFailure extends AuthFailure {}

class UserMisMatchFailure extends AuthFailure {}

class InvalidVerificationCodeFailure extends AuthFailure {}

class InvalidVerificationIdFailure extends AuthFailure {}

class RequiresRecentLoginFailure extends AuthFailure {}

class MissingPasswordFailure extends AuthFailure {}
