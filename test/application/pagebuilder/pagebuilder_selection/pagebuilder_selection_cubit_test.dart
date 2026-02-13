import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderSelectionCubit cubit;

  setUp(() {
    cubit = PagebuilderSelectionCubit();
  });

  test("initial state should be null", () {
    expect(cubit.state, null);
  });

  group("PagebuilderSelectionCubit_SelectWidget", () {
    test("should emit widget id when selectWidget is called with a widget id",
        () async {
      // Given
      const widgetId = "widget-123";
      final expectedResult = [widgetId];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.selectWidget(widgetId);
    });

    test("should emit null when selectWidget is called with null", () async {
      // Given
      const String? widgetId = null;
      final expectedResult = [widgetId];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.selectWidget(widgetId);
    });

    test("should emit different widget id when called multiple times",
        () async {
      // Given
      const firstWidgetId = "widget-123";
      const secondWidgetId = "widget-456";
      final expectedResult = [firstWidgetId, secondWidgetId];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.selectWidget(firstWidgetId);
      cubit.selectWidget(secondWidgetId);
    });

    test("should handle selection and deselection", () async {
      // Given
      const widgetId = "widget-123";
      final expectedResult = [widgetId, null];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.selectWidget(widgetId);
      cubit.selectWidget(null);
    });

    test("should handle multiple selections and deselections", () async {
      // Given
      const firstWidgetId = "widget-123";
      const secondWidgetId = "widget-456";
      const thirdWidgetId = "widget-789";
      final expectedResult = [
        firstWidgetId,
        null,
        secondWidgetId,
        null,
        thirdWidgetId,
      ];
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.selectWidget(firstWidgetId);
      cubit.selectWidget(null);
      cubit.selectWidget(secondWidgetId);
      cubit.selectWidget(null);
      cubit.selectWidget(thirdWidgetId);
    });
  });
}
