import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuItems? _previousMenuItem;

  MenuCubit() : super(MenuInitial());

  void selectMenu(MenuItems selectedMenuItem) {
    if (_previousMenuItem != selectedMenuItem) {
      emit(MenuItemSelectedState(selectedMenuItem: selectedMenuItem));
      _previousMenuItem = selectedMenuItem;
    }
  }

  void collapseMenu(bool collapsed) {
    emit(MenuIsCollapsedState(collapsed: collapsed));
  }
}
