// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_bloc.dart';

@immutable
sealed class MenuEvent {}

class SelectedMenuItemChangedEvent extends MenuEvent {
  final MenuItems selectedMenuItem;

  SelectedMenuItemChangedEvent({
    required this.selectedMenuItem,
  });
}
