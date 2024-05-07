part of 'theme_cubit.dart';

sealed class ThemeState {
  const ThemeState();
}

final class ThemeInitial extends ThemeState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class ThemeChanged extends ThemeState with EquatableMixin {
  final ThemeStatus status;

  const ThemeChanged({required this.status});

  @override
  List<Object?> get props => [status];
}
