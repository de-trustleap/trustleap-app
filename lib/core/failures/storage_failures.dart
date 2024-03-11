abstract class StorageFailure {}

class UnknownFailure extends StorageFailure {}

class ObjectNotFound extends StorageFailure {}

class NotAuthenticated extends StorageFailure {}

class UnAuthorized extends StorageFailure {}

class RetryLimitExceeded extends StorageFailure {}
