// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_cubit.dart';

sealed class MenuState {}

class MenuInitial extends MenuState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class MenuItemSelectedState extends MenuState with EquatableMixin {
  final MenuItems selectedMenuItem;

  MenuItemSelectedState({
    required this.selectedMenuItem,
  });
  
  @override
  List<Object?> get props => [selectedMenuItem];
}

final class MenuIsCollapsedState extends MenuState with EquatableMixin {
  final bool collapsed;

  MenuIsCollapsedState({
    required this.collapsed,
  });
  
  @override
  List<Object?> get props => [collapsed];
}
