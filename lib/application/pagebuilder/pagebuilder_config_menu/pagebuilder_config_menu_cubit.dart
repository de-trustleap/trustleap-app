import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

part 'pagebuilder_config_menu_state.dart';

class PagebuilderConfigMenuCubit extends Cubit<PagebuilderConfigMenuState> {
  PagebuilderConfigMenuCubit()
      : super(PageBuilderPageMenuOpenedState(id: UniqueID()));

  void openConfigMenu(PageBuilderWidget model) {
    final id = UniqueID();
    emit(PageBuilderConfigMenuOpenedState(id: id, model: model));
  }

  void openSectionConfigMenu(PageBuilderSection model) {
    final id = UniqueID();
    emit(PageBuilderSectionConfigMenuOpenedState(id: id, model: model));
  }

  void closeConfigMenu() {
    final id = UniqueID();
    emit(PageBuilderPageMenuOpenedState(id: id));
  }

  void toggleConfigMenu() {
    final id = UniqueID();

    if (state is PageBuilderConfigMenuClosedState) {
      emit(PageBuilderPageMenuOpenedState(id: id));
    } else {
      emit(PageBuilderConfigMenuClosedState(id: id));
    }
  }
}
