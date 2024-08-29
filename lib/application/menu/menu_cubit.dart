import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/constants.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial());

  void selectMenu(MenuItems selectedMenuItem) {
    emit(MenuItemSelectedState(selectedMenuItem: selectedMenuItem));
  }

  void collapseMenu(bool collapsed) {
    emit(MenuIsCollapsedState(collapsed: collapsed));
  }
}
