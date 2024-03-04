import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:meta/meta.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuInitial(selectedMenuItem: MenuItems.none)) {
    on<MenuEvent>((event, emit) {
      if (event is SelectedMenuItemChangedEvent) {
        emit(MenuInitial(selectedMenuItem: event.selectedMenuItem));
      }
    });
  }
}
