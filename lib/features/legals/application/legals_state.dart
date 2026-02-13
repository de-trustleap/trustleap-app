// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'legals_cubit.dart';

sealed class LegalsState {}

final class LegalsInitial extends LegalsState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class GetLegalsLoadingState extends LegalsState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class GetLegalsSuccessState extends LegalsState with EquatableMixin {
  final String? text;

  GetLegalsSuccessState({
    required this.text,
  });

  @override
  List<Object?> get props => [text];
}

class GetLegalsFailureState extends LegalsState with EquatableMixin {
  final DatabaseFailure failure;

  GetLegalsFailureState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
