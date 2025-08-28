import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

abstract class CalendlyRepository {
  /// Start OAuth flow and return the authorization URL
  Future<Either<DatabaseFailure, String>> getAuthorizationUrl();

  /// Get user information from Calendly API
  Future<Either<DatabaseFailure, Map<String, dynamic>>> getUserInfo();

  /// Get user's event types from Calendly
  Future<Either<DatabaseFailure, List<Map<String, dynamic>>>>
      getUserEventTypes();

  /// Check if user is currently authenticated
  Future<Either<DatabaseFailure, bool>> isAuthenticated();

  /// Clear stored authentication data
  Future<Either<DatabaseFailure, Unit>> clearAuthentication();

  /// Observe authentication status changes in real-time
  Stream<Either<DatabaseFailure, bool>> observeAuthenticationStatus();
}
