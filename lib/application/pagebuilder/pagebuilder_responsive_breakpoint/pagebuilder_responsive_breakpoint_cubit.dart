import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/constants.dart';

class PagebuilderResponsiveBreakpointCubit
    extends Cubit<PagebuilderResponsiveBreakpoint> {
  PagebuilderResponsiveBreakpointCubit()
      : super(PagebuilderResponsiveBreakpoint.desktop);

  void setBreakpoint(PagebuilderResponsiveBreakpoint breakpoint) {
    emit(breakpoint);
  }

  void setDesktop() => emit(PagebuilderResponsiveBreakpoint.desktop);
  void setTablet() => emit(PagebuilderResponsiveBreakpoint.tablet);
  void setMobile() => emit(PagebuilderResponsiveBreakpoint.mobile);
}
