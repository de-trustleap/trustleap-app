import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

part 'pagebuilder_config_menu_state.dart';

class PagebuilderConfigMenuCubit extends Cubit<PagebuilderConfigMenuState> {
  PagebuilderConfigMenuCubit() : super(PagebuilderConfigMenuInitial());

  void openConfigMenu(PageBuilderWidget model) {
    emit(PageBuilderConfigMenuOpenedState(model: model));
  }
}
