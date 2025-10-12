import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderResponsiveBreakpointCubit cubit;

  setUp(() {
    cubit = PagebuilderResponsiveBreakpointCubit();
  });

  test("initial state should be desktop", () {
    expect(cubit.state, PagebuilderResponsiveBreakpoint.desktop);
  });

  group("PagebuilderResponsiveBreakpointCubit_SetBreakpoint", () {
    test("should emit mobile when setBreakpoint is called with mobile",
        () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.mobile];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.mobile);
    });

    test("should emit tablet when setBreakpoint is called with tablet",
        () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.tablet];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.tablet);
    });

    test("should emit desktop when setBreakpoint is called with desktop",
        () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.desktop];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.desktop);
    });
  });

  group("PagebuilderResponsiveBreakpointCubit_SetDesktop", () {
    test("should emit desktop when setDesktop is called", () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.desktop];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setDesktop();
    });
  });

  group("PagebuilderResponsiveBreakpointCubit_SetTablet", () {
    test("should emit tablet when setTablet is called", () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.tablet];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setTablet();
    });
  });

  group("PagebuilderResponsiveBreakpointCubit_SetMobile", () {
    test("should emit mobile when setMobile is called", () async {
      // Given
      final expectedResult = [PagebuilderResponsiveBreakpoint.mobile];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setMobile();
    });
  });

  group("PagebuilderResponsiveBreakpointCubit_MultipleTransitions", () {
    test("should handle multiple breakpoint changes correctly", () async {
      // Given
      final expectedResult = [
        PagebuilderResponsiveBreakpoint.mobile,
        PagebuilderResponsiveBreakpoint.tablet,
        PagebuilderResponsiveBreakpoint.desktop,
      ];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setMobile();
      cubit.setTablet();
      cubit.setDesktop();
    });

    test("should handle switching between all breakpoints using setBreakpoint",
        () async {
      // Given
      final expectedResult = [
        PagebuilderResponsiveBreakpoint.mobile,
        PagebuilderResponsiveBreakpoint.tablet,
        PagebuilderResponsiveBreakpoint.desktop,
        PagebuilderResponsiveBreakpoint.mobile,
      ];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.mobile);
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.tablet);
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.desktop);
      cubit.setBreakpoint(PagebuilderResponsiveBreakpoint.mobile);
    });
  });
}
