// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockCalendlyRepository mockCalendlyRepo;

  setUp(() {
    mockCalendlyRepo = MockCalendlyRepository();
  });

  group("CalendlyRepository_GetAuthorizationUrl", () {
    const testAuthUrl = "https://auth.calendly.com/oauth/authorize?client_id=test";
    
    test("should return authorization URL when call is successful", () async {
      // Given
      final expectedResult = right(testAuthUrl);
      when(mockCalendlyRepo.getAuthorizationUrl())
          .thenAnswer((_) async => right(testAuthUrl));
      // When
      final result = await mockCalendlyRepo.getAuthorizationUrl();
      // Then
      verify(mockCalendlyRepo.getAuthorizationUrl());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.getAuthorizationUrl())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.getAuthorizationUrl();
      // Then
      verify(mockCalendlyRepo.getAuthorizationUrl());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_GetUserInfo", () {
    final testUserInfo = {
      "uri": "https://api.calendly.com/users/test",
      "name": "Test User",
      "email": "test@example.com"
    };
    
    test("should return user info when call is successful", () async {
      // Given
      final expectedResult = right(testUserInfo);
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => right(testUserInfo));
      // When
      final result = await mockCalendlyRepo.getUserInfo();
      // Then
      verify(mockCalendlyRepo.getUserInfo());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when user not found", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => left(NotFoundFailure()));
      // When
      final result = await mockCalendlyRepo.getUserInfo();
      // Then
      verify(mockCalendlyRepo.getUserInfo());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.getUserInfo();
      // Then
      verify(mockCalendlyRepo.getUserInfo());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_GetUserEventTypes", () {
    final testEventTypes = [
      {
        "uri": "https://api.calendly.com/event_types/test1",
        "name": "30 Minute Meeting",
        "scheduling_url": "https://calendly.com/test/30min"
      },
      {
        "uri": "https://api.calendly.com/event_types/test2",
        "name": "60 Minute Meeting", 
        "scheduling_url": "https://calendly.com/test/60min"
      }
    ];
    
    test("should return event types when call is successful", () async {
      // Given
      final expectedResult = right(testEventTypes);
      when(mockCalendlyRepo.getUserEventTypes())
          .thenAnswer((_) async => right(testEventTypes));
      // When
      final result = await mockCalendlyRepo.getUserEventTypes();
      // Then
      verify(mockCalendlyRepo.getUserEventTypes());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return empty list when no event types found", () async {
      // Given
      when(mockCalendlyRepo.getUserEventTypes())
          .thenAnswer((_) async => right(<Map<String, dynamic>>[]));
      // When
      final result = await mockCalendlyRepo.getUserEventTypes();
      // Then
      verify(mockCalendlyRepo.getUserEventTypes());
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), []);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.getUserEventTypes())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.getUserEventTypes();
      // Then
      verify(mockCalendlyRepo.getUserEventTypes());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_IsAuthenticated", () {
    test("should return true when user is authenticated", () async {
      // Given
      final expectedResult = right(true);
      when(mockCalendlyRepo.isAuthenticated())
          .thenAnswer((_) async => right(true));
      // When
      final result = await mockCalendlyRepo.isAuthenticated();
      // Then
      verify(mockCalendlyRepo.isAuthenticated());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return false when user is not authenticated", () async {
      // Given
      final expectedResult = right(false);
      when(mockCalendlyRepo.isAuthenticated())
          .thenAnswer((_) async => right(false));
      // When
      final result = await mockCalendlyRepo.isAuthenticated();
      // Then
      verify(mockCalendlyRepo.isAuthenticated());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.isAuthenticated())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.isAuthenticated();
      // Then
      verify(mockCalendlyRepo.isAuthenticated());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_ClearAuthentication", () {
    test("should return unit when authentication cleared successfully", () async {
      // Given
      final expectedResult = right(unit);
      when(mockCalendlyRepo.clearAuthentication())
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockCalendlyRepo.clearAuthentication();
      // Then
      verify(mockCalendlyRepo.clearAuthentication());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.clearAuthentication())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.clearAuthentication();
      // Then
      verify(mockCalendlyRepo.clearAuthentication());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_RefreshToken", () {
    test("should return unit when token refreshed successfully", () async {
      // Given
      final expectedResult = right(unit);
      when(mockCalendlyRepo.refreshToken())
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockCalendlyRepo.refreshToken();
      // Then
      verify(mockCalendlyRepo.refreshToken());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should return failure when refresh has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockCalendlyRepo.refreshToken())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockCalendlyRepo.refreshToken();
      // Then
      verify(mockCalendlyRepo.refreshToken());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });

  group("CalendlyRepository_ObserveAuthenticationStatus", () {
    test("should emit true when user becomes authenticated", () async {
      // Given
      final expectedResult = Stream.value(right(true));
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      // When
      final result = mockCalendlyRepo.observeAuthenticationStatus();
      // Then
      verify(mockCalendlyRepo.observeAuthenticationStatus());
      await expectLater(result, emits(right(true)));
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should emit false when user becomes unauthenticated", () async {
      // Given
      final expectedResult = Stream.value(right(false));
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(false)));
      // When
      final result = mockCalendlyRepo.observeAuthenticationStatus();
      // Then
      verify(mockCalendlyRepo.observeAuthenticationStatus());
      await expectLater(result, emits(right(false)));
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should emit failure when observation fails", () async {
      // Given
      final expectedResult = Stream.value(left(BackendFailure()));
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(left(BackendFailure())));
      // When
      final result = mockCalendlyRepo.observeAuthenticationStatus();
      // Then
      verify(mockCalendlyRepo.observeAuthenticationStatus());
      await expectLater(result, emits(left(BackendFailure())));
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test("should emit multiple status changes", () async {
      // Given
      final statusChanges = <Either<DatabaseFailure, bool>>[
        right(false),
        right(true),
        right(false)
      ];
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.fromIterable(statusChanges));
      // When  
      final result = mockCalendlyRepo.observeAuthenticationStatus();
      // Then
      verify(mockCalendlyRepo.observeAuthenticationStatus());
      await expectLater(result, emitsInOrder(statusChanges));
      verifyNoMoreInteractions(mockCalendlyRepo);
    });
  });
}