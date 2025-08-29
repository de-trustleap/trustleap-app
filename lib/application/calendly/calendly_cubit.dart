import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/failure.dart';
import 'package:finanzbegleiter/domain/repositories/calendly_repository.dart';

part 'calendly_state.dart';

class CalendlyCubit extends Cubit<CalendlyState> {
  final CalendlyRepository calendlyRepository;
  StreamSubscription<dynamic>? _authStatusSubscription;

  CalendlyCubit(this.calendlyRepository) : super(CalendlyInitial());

  /// Start OAuth connection flow
  Future<void> connectToCalendly() async {
    emit(CalendlyConnectingState());

    final authUrlResult = await calendlyRepository.getAuthorizationUrl();

    authUrlResult.fold(
      (failure) => emit(CalendlyConnectionFailureState(failure: failure)),
      (authUrl) {
        emit(CalendlyOAuthReadyState(authUrl: authUrl));
      },
    );
  }

  /// Fetch user information from Calendly and automatically load event types
  Future<void> _fetchUserInfo() async {
    final userInfoResult = await calendlyRepository.getUserInfo();

    await userInfoResult.fold(
      (failure) async {
        if (failure is NotFoundFailure) {
          // Token might be expired, try to refresh
          final refreshResult = await calendlyRepository.refreshToken();
          refreshResult.fold(
            (refreshFailure) =>
                emit(CalendlyConnectionFailureState(failure: refreshFailure)),
            (_) => _fetchUserInfo(), // Retry after refresh
          );
        } else {
          emit(CalendlyConnectionFailureState(failure: failure));
        }
      },
      (userInfo) async {
        emit(CalendlyAuthenticatedState(userInfo: userInfo));
        final eventTypesResult = await calendlyRepository.getUserEventTypes();

        eventTypesResult.fold(
          (failure) => emit(CalendlyConnectionFailureState(failure: failure)),
          (eventTypes) => emit(CalendlyConnectedState(
            userInfo: userInfo,
            eventTypes: eventTypes,
          )),
        );
      },
    );
  }

  Future<void> disconnect() async {
    final result = await calendlyRepository.clearAuthentication();

    result.fold(
      (failure) => emit(CalendlyConnectionFailureState(failure: failure)),
      (_) => emit(CalendlyDisconnectedState()),
    );
  }

  Future<void> _refreshToken() async {
    emit(CalendlyConnectingState());

    final result = await calendlyRepository.refreshToken();

    result.fold(
      (failure) => emit(CalendlyConnectionFailureState(failure: failure)),
      (_) => _fetchUserInfo(),
    );
  }

  void startObservingAuthStatus() {
    _authStatusSubscription?.cancel();
    _authStatusSubscription = null;

    _authStatusSubscription =
        calendlyRepository.observeAuthenticationStatus().listen(
      (result) {
        result.fold(
          (failure) {
            if (failure is NotFoundFailure) {
              emit(CalendlyNotAuthenticatedState());
            } else {
              emit(CalendlyConnectionFailureState(failure: failure));
            }
          },
          (isAuthenticated) {
            if (isAuthenticated) {
              _fetchUserInfo();
            } else {
              _checkAndRefreshToken();
            }
          },
        );
      },
      onError: (error) {
        emit(CalendlyConnectionFailureState(failure: BackendFailure()));
      },
    );
  }

  Future<void> _checkAndRefreshToken() async {
    final authResult = await calendlyRepository.isAuthenticated();
    authResult.fold(
      (failure) => emit(CalendlyConnectionFailureState(failure: failure)),
      (isAuth) {
        if (!isAuth) {
          _refreshToken();
        } else {
          emit(CalendlyNotAuthenticatedState());
        }
      },
    );
  }

  void stopObservingAuthStatus() {
    _authStatusSubscription?.cancel();
    _authStatusSubscription = null;
  }

  void reset() {
    emit(CalendlyInitial());
  }

  @override
  Future<void> close() {
    stopObservingAuthStatus();
    return super.close();
  }
}
