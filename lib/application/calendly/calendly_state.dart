part of 'calendly_cubit.dart';

sealed class CalendlyState {}

final class CalendlyInitial extends CalendlyState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyConnectingState extends CalendlyState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyConnectedState extends CalendlyState with EquatableMixin {
  final Map<String, dynamic> userInfo;
  final List<Map<String, dynamic>> eventTypes;

  CalendlyConnectedState({
    required this.userInfo,
    required this.eventTypes,
  });

  @override
  List<Object> get props => [userInfo, eventTypes];
}

class CalendlyConnectionFailureState extends CalendlyState with EquatableMixin {
  final Failure failure;

  CalendlyConnectionFailureState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}

class CalendlyDisconnectedState extends CalendlyState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyCheckingAuthState extends CalendlyState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyAuthenticatedState extends CalendlyState with EquatableMixin {
  final Map<String, dynamic> userInfo;

  CalendlyAuthenticatedState({
    required this.userInfo,
  });

  @override
  List<Object> get props => [userInfo];
}

class CalendlyNotAuthenticatedState extends CalendlyState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyWebhookSetupLoadingState extends CalendlyState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CalendlyWebhookSetupSuccessState extends CalendlyState
    with EquatableMixin {
  final Map<String, dynamic> webhookInfo;

  CalendlyWebhookSetupSuccessState({
    required this.webhookInfo,
  });

  @override
  List<Object> get props => [webhookInfo];
}

class CalendlyWebhookSetupFailureState extends CalendlyState
    with EquatableMixin {
  final Failure failure;

  CalendlyWebhookSetupFailureState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}


class CalendlyOAuthReadyState extends CalendlyState with EquatableMixin {
  final String authUrl;

  CalendlyOAuthReadyState({
    required this.authUrl,
  });

  @override
  List<Object> get props => [authUrl];
}
