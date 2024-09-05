// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuItemSelectedState extends MenuState {
  final MenuItems selectedMenuItem;

  const MenuItemSelectedState({
    required this.selectedMenuItem,
  });
}

final class MenuIsCollapsedState extends MenuState {
  final bool collapsed;

  const MenuIsCollapsedState({
    required this.collapsed,
  });
}
