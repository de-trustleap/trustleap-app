abstract class DatabaseFailure {}

class BackendFailure extends DatabaseFailure {}

class PermissionDenied extends DatabaseFailure {}
