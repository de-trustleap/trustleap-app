abstract class DatabaseFailure {}

class BackendFailure extends DatabaseFailure {}

class PermissionDeniedFailure extends DatabaseFailure {}

class NotFoundFailure extends DatabaseFailure {}

class AlreadyExistsFailure extends DatabaseFailure {}

class DeadlineExceededFailure extends DatabaseFailure {}

class CancelledFailure extends DatabaseFailure {}

class UnavailableFailure extends DatabaseFailure {}
