import 'package:equatable/equatable.dart';

abstract class StorageFailure extends Equatable {}

class UnknownFailure extends StorageFailure {
  @override
  List<Object?> get props => [];
}

class ObjectNotFound extends StorageFailure {
  @override
  List<Object?> get props => [];
}

class NotAuthenticated extends StorageFailure {
  @override
  List<Object?> get props => [];
}

class UnAuthorized extends StorageFailure {
  @override
  List<Object?> get props => [];
}

class RetryLimitExceeded extends StorageFailure {
  @override
  List<Object?> get props => [];
}
