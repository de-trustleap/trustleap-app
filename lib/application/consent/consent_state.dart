part of 'consent_cubit.dart';

sealed class ConsentState {}

final class ConsentInitial extends ConsentState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class ConsentRequiredState extends ConsentState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class ConsentLoadedState extends ConsentState with EquatableMixin {
  final ConsentPreference preference;

  ConsentLoadedState({required this.preference});

  @override
  List<Object> get props => [preference];
}

final class ConsentSavingState extends ConsentState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class ConsentSaveSuccessState extends ConsentState with EquatableMixin {
  final ConsentPreference preference;

  ConsentSaveSuccessState({required this.preference});

  @override
  List<Object> get props => [preference];
}

final class ConsentSaveFailureState extends ConsentState with EquatableMixin {
  final DatabaseFailure failure;

  ConsentSaveFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
