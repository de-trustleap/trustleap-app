part of 'navigation_cubit.dart';

sealed class NavigationState {}

final class NavigationInitial extends NavigationState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class NavigationCheckState extends NavigationState with EquatableMixin {
  final String route;

  NavigationCheckState({
    required this.route,
  });

  @override
  List<Object?> get props => [route];
}
