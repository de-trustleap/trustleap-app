// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/calendly/application/calendly_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late CalendlyCubit calendlyCubit;
  late MockCalendlyRepository mockCalendlyRepo;

  setUp(() {
    mockCalendlyRepo = MockCalendlyRepository();
    calendlyCubit = CalendlyCubit(mockCalendlyRepo);
  });

  test("init state should be CalendlyInitial", () {
    expect(calendlyCubit.state, CalendlyInitial());
  });

  group("CalendlyCubit_ConnectToCalendly", () {
    const testAuthUrl = "https://auth.calendly.com/oauth/authorize?client_id=test";
    
    test("should call calendly repo when function is called", () async {
      // Given
      when(mockCalendlyRepo.getAuthorizationUrl())
          .thenAnswer((_) async => right(testAuthUrl));
      // When
      calendlyCubit.connectToCalendly();
      await untilCalled(mockCalendlyRepo.getAuthorizationUrl());
      // Then
      verify(mockCalendlyRepo.getAuthorizationUrl());
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test(
        "should emit CalendlyConnectingState and then CalendlyOAuthReadyState when connection is successful",
        () async {
      // Given
      final expectedResult = [
        CalendlyConnectingState(),
        CalendlyOAuthReadyState(authUrl: testAuthUrl)
      ];
      when(mockCalendlyRepo.getAuthorizationUrl())
          .thenAnswer((_) async => right(testAuthUrl));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.connectToCalendly();
    });

    test(
        "should emit CalendlyConnectingState and then CalendlyConnectionFailureState when connection fails",
        () async {
      // Given
      final expectedResult = [
        CalendlyConnectingState(),
        CalendlyConnectionFailureState(failure: BackendFailure())
      ];
      when(mockCalendlyRepo.getAuthorizationUrl())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.connectToCalendly();
    });
  });

  group("CalendlyCubit_Disconnect", () {
    test("should call calendly repo when function is called", () async {
      // Given
      when(mockCalendlyRepo.clearAuthentication())
          .thenAnswer((_) async => right(unit));
      // When
      calendlyCubit.disconnect();
      await untilCalled(mockCalendlyRepo.clearAuthentication());
      // Then
      verify(mockCalendlyRepo.clearAuthentication());
      verifyNoMoreInteractions(mockCalendlyRepo);
    });

    test(
        "should emit CalendlyDisconnectedState when disconnect is successful",
        () async {
      // Given
      final expectedResult = [CalendlyDisconnectedState()];
      when(mockCalendlyRepo.clearAuthentication())
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.disconnect();
    });

    test(
        "should emit CalendlyConnectionFailureState when disconnect fails",
        () async {
      // Given
      final expectedResult = [
        CalendlyConnectionFailureState(failure: BackendFailure())
      ];
      when(mockCalendlyRepo.clearAuthentication())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.disconnect();
    });
  });


  group("CalendlyCubit_StartObservingAuthStatus", () {
    test("should call calendly repo when function is called", () async {
      // Given
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => right({"uri": "test", "name": "test", "email": "test@test.com"}));
      when(mockCalendlyRepo.getUserEventTypes())
          .thenAnswer((_) async => right([]));
      // When
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
      // Then
      verify(mockCalendlyRepo.observeAuthenticationStatus());
    });

    test("should handle stream error and emit CalendlyConnectionFailureState", () async {
      // Given
      final expectedResult = [
        CalendlyConnectionFailureState(failure: BackendFailure())
      ];
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.error("test error"));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.startObservingAuthStatus();
    });
  });

  group("CalendlyCubit_FetchUserInfo", () {
    final testUserInfo = {
      "uri": "https://api.calendly.com/users/test",
      "name": "Test User",
      "email": "test@example.com"
    };
    final testEventTypes = [
      {
        "uri": "https://api.calendly.com/event_types/test1",
        "name": "30 Minute Meeting",
        "scheduling_url": "https://calendly.com/test/30min"
      }
    ];

    test(
        "should emit CalendlyAuthenticatedState and CalendlyConnectedState when user info and event types are fetched successfully",
        () async {
      // Given
      final expectedResult = [
        CalendlyAuthenticatedState(userInfo: testUserInfo),
        CalendlyConnectedState(userInfo: testUserInfo, eventTypes: testEventTypes)
      ];
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => right(testUserInfo));
      when(mockCalendlyRepo.getUserEventTypes())
          .thenAnswer((_) async => right(testEventTypes));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
    });

    test(
        "should emit CalendlyConnectionFailureState when user info fetch fails",
        () async {
      // Given
      final expectedResult = [
        CalendlyConnectionFailureState(failure: BackendFailure())
      ];
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
    });

    test(
        "should attempt token refresh when getUserInfo returns NotFoundFailure",
        () async {
      // Given
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => left(NotFoundFailure()));
      when(mockCalendlyRepo.refreshToken())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
      // Wait a bit for the internal calls to complete
      await Future.delayed(Duration(milliseconds: 10));
      // Then
      verify(mockCalendlyRepo.refreshToken());
    });
  });

  group("CalendlyCubit_CheckAndRefreshToken", () {
    test(
        "should emit CalendlyNotAuthenticatedState when token is valid but user is not authenticated",
        () async {
      // Given  
      final expectedResult = [CalendlyNotAuthenticatedState()];
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(false)));
      when(mockCalendlyRepo.isAuthenticated())
          .thenAnswer((_) async => right(true));
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
    });

    test(
        "should attempt refresh when token is expired",
        () async {
      // Given
      when(mockCalendlyRepo.observeAuthenticationStatus())
          .thenAnswer((_) => Stream.value(right(false)));
      when(mockCalendlyRepo.isAuthenticated())
          .thenAnswer((_) async => right(false));
      when(mockCalendlyRepo.refreshToken())
          .thenAnswer((_) async => right(unit));
      when(mockCalendlyRepo.getUserInfo())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      calendlyCubit.startObservingAuthStatus();
      await untilCalled(mockCalendlyRepo.observeAuthenticationStatus());
      // Wait a bit for the internal calls to complete
      await Future.delayed(Duration(milliseconds: 10));
      // Then
      verify(mockCalendlyRepo.refreshToken());
    });
  });

  group("CalendlyCubit_Reset", () {
    test("should emit CalendlyInitial when reset is called", () async {
      // Given
      final expectedResult = [CalendlyInitial()];
      // Then
      expectLater(calendlyCubit.stream, emitsInOrder(expectedResult));
      calendlyCubit.reset();
    });
  });
}