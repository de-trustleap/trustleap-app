import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/constants.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(const MenuInitial(selectedMenuItem: MenuItems.none));

  void selectMenu(MenuItems selectedMenuItem) {
    emit(MenuInitial(selectedMenuItem: selectedMenuItem));
  }
}
