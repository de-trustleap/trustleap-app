abstract class DatabaseFailure {}

class BackendFailure extends DatabaseFailure {}

class PermissionDeniedFailure extends DatabaseFailure {}

class NotFoundFailure extends DatabaseFailure {}
