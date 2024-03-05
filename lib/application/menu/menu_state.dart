// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_cubit.dart';

abstract class MenuState {
  final MenuItems selectedMenuItem;

  const MenuState({
    required this.selectedMenuItem,
  });
}

final class MenuInitial extends MenuState {
  const MenuInitial({required super.selectedMenuItem});
}
