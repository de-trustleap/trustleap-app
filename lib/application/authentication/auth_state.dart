// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthState {
  final bool isSubmitting;
  final bool showValidationMessages;

  AuthState({
    required this.isSubmitting,
    required this.showValidationMessages,
  });

  AuthState copyWith({
    bool? isSubmitting,
    bool? showValidationMessages,
  }) {
    return AuthState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showValidationMessages:
          showValidationMessages ?? this.showValidationMessages,
    );
  }
}
