import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_zoom/pagebuilder_zoom_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderZoomCubit cubit;

  setUp(() {
    cubit = PagebuilderZoomCubit();
  });

  test("initial state should be hundred", () {
    expect(cubit.state, PagebuilderZoomLevel.hundred);
  });

  group("PagebuilderZoomCubit_SetZoomLevel", () {
    test("should emit twentyFive when setZoomLevel is called with twentyFive",
        () async {
      // Given
      final expectedResult = [PagebuilderZoomLevel.twentyFive];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.twentyFive);
    });

    test("should emit fifty when setZoomLevel is called with fifty",
        () async {
      // Given
      final expectedResult = [PagebuilderZoomLevel.fifty];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.fifty);
    });

    test("should emit seventyFive when setZoomLevel is called with seventyFive",
        () async {
      // Given
      final expectedResult = [PagebuilderZoomLevel.seventyFive];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.seventyFive);
    });

    test("should emit hundred when setZoomLevel is called with hundred",
        () async {
      // Given
      final expectedResult = [PagebuilderZoomLevel.hundred];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.hundred);
    });
  });

  group("PagebuilderZoomCubit_MultipleTransitions", () {
    test("should handle multiple zoom level changes correctly", () async {
      // Given
      final expectedResult = [
        PagebuilderZoomLevel.twentyFive,
        PagebuilderZoomLevel.fifty,
        PagebuilderZoomLevel.seventyFive,
        PagebuilderZoomLevel.hundred,
      ];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.twentyFive);
      cubit.setZoomLevel(PagebuilderZoomLevel.fifty);
      cubit.setZoomLevel(PagebuilderZoomLevel.seventyFive);
      cubit.setZoomLevel(PagebuilderZoomLevel.hundred);
    });

    test("should handle zooming in and out", () async {
      // Given
      final expectedResult = [
        PagebuilderZoomLevel.fifty,
        PagebuilderZoomLevel.twentyFive,
        PagebuilderZoomLevel.seventyFive,
        PagebuilderZoomLevel.hundred,
        PagebuilderZoomLevel.fifty,
      ];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.setZoomLevel(PagebuilderZoomLevel.fifty);
      cubit.setZoomLevel(PagebuilderZoomLevel.twentyFive);
      cubit.setZoomLevel(PagebuilderZoomLevel.seventyFive);
      cubit.setZoomLevel(PagebuilderZoomLevel.hundred);
      cubit.setZoomLevel(PagebuilderZoomLevel.fifty);
    });
  });

  group("PagebuilderZoomLevel_Enum", () {
    test("twentyFive should have correct scale and label", () {
      expect(PagebuilderZoomLevel.twentyFive.scale, 0.25);
      expect(PagebuilderZoomLevel.twentyFive.label, "25%");
    });

    test("fifty should have correct scale and label", () {
      expect(PagebuilderZoomLevel.fifty.scale, 0.5);
      expect(PagebuilderZoomLevel.fifty.label, "50%");
    });

    test("seventyFive should have correct scale and label", () {
      expect(PagebuilderZoomLevel.seventyFive.scale, 0.75);
      expect(PagebuilderZoomLevel.seventyFive.label, "75%");
    });

    test("hundred should have correct scale and label", () {
      expect(PagebuilderZoomLevel.hundred.scale, 1.0);
      expect(PagebuilderZoomLevel.hundred.label, "100%");
    });
  });
}
