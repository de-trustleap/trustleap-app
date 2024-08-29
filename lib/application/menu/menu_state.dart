// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_cubit.dart';

sealed class MenuState {}

class MenuInitial extends MenuState {}

class MenuItemSelectedState extends MenuState {
  final MenuItems selectedMenuItem;

  MenuItemSelectedState({
    required this.selectedMenuItem,
  });
}

final class MenuIsCollapsedState extends MenuState {
  final bool collapsed;

  MenuIsCollapsedState({
    required this.collapsed,
  });
}
