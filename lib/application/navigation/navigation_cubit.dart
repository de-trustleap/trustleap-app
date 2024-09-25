import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  void navigate(String route) {
    if (Modular.to.path.contains(RoutePaths.landingPageBuilderPath)) {
      emit(NavigationCheckState(route: route));
    } else {
      Modular.to.navigate(route);
    }
  }
}
