import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  void changeTheme(ThemeStatus status) {
    print("WILL CHANGE!");
    emit(ThemeChanged(status: status));
  }
}
