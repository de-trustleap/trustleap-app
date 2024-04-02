import 'package:equatable/equatable.dart';

abstract class DatabaseFailure extends Equatable {}

class BackendFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class PermissionDeniedFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class NotFoundFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class AlreadyExistsFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class DeadlineExceededFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class CancelledFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}

class UnavailableFailure extends DatabaseFailure {
  @override
  List<Object?> get props => [];
}
