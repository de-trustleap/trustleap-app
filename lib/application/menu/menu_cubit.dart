import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuItems? selectedItem;
  bool isCollapsed = false;

  MenuCubit() : super(MenuInitial());

  void selectMenu(MenuItems selectedMenuItem) {
    if (selectedItem != selectedMenuItem) {
      selectedItem = selectedMenuItem;
      emit(MenuItemSelectedState(selectedMenuItem: selectedMenuItem));
    }
  }

  void collapseMenu(bool collapsed) {
    isCollapsed = collapsed;
    emit(MenuIsCollapsedState(collapsed: collapsed));
    if (selectedItem != null) {
      emit(MenuItemSelectedState(selectedMenuItem: selectedItem!));
    }
  }
}
