abstract class AuthFailure {}

class ServerFailure extends AuthFailure {}

class EmailAlreadyInUseFailure extends AuthFailure {}

class InvalidEmailFailure extends AuthFailure {}

class WeakPasswordFailure extends AuthFailure {}

class UserDisabledFailure extends AuthFailure {}

class UserNotFoundFailure extends AuthFailure {}

class WrongPasswordFailure extends AuthFailure {}

class InvalidCredentialsFailure extends AuthFailure {}
