import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderConfigMenuCubit cubit;

  setUp(() {
    cubit = PagebuilderConfigMenuCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group("PagebuilderConfigMenuCubit initialization", () {
    test("initial state should be PageBuilderPageMenuOpenedState", () {
      expect(cubit.state, isA<PageBuilderPageMenuOpenedState>());
    });

    test("initial state should have a unique ID", () {
      final state = cubit.state as PageBuilderPageMenuOpenedState;
      expect(state.id, isNotNull);
    });
  });

  group("PagebuilderConfigMenuCubit.openConfigMenu", () {
    final mockWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget1"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Test Widget",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    test("should emit PageBuilderConfigMenuOpenedState with widget model",
        () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderConfigMenuOpenedState>(
          (state) => state.model.id.value == "widget1",
        )),
      );

      // When
      cubit.openConfigMenu(mockWidget);
    });

    test("should emit state with unique ID", () async {
      // When
      cubit.openConfigMenu(mockWidget);

      // Then
      final state = cubit.state as PageBuilderConfigMenuOpenedState;
      expect(state.id, isNotNull);
    });

    test("should emit state with provided widget model", () async {
      // When
      cubit.openConfigMenu(mockWidget);

      // Then
      final state = cubit.state as PageBuilderConfigMenuOpenedState;
      expect(state.model, equals(mockWidget));
      expect(state.model.id.value, "widget1");
    });

    test("should emit new state when called multiple times with same widget",
        () async {
      // Given
      cubit.openConfigMenu(mockWidget);
      final firstState = cubit.state as PageBuilderConfigMenuOpenedState;
      final firstId = firstState.id;

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderConfigMenuOpenedState>(
          (state) => state.id != firstId && state.model == mockWidget,
        )),
      );

      // When
      cubit.openConfigMenu(mockWidget);
    });

    test("should emit state with different widget when opened with new widget",
        () async {
      // Given
      final anotherWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget2"),
        elementType: PageBuilderWidgetType.text,
        properties: PageBuilderTextProperties(
          text: "Another Widget",
          fontSize: null,
          fontFamily: null,
          lineHeight: null,
          letterSpacing: null,
          color: null,
          alignment: null,
          textShadow: null,
          isBold: null,
          isItalic: null,
        ),
        hoverProperties: null,
        children: null,
        containerChild: null,
        widthPercentage: null,
        background: null,
        hoverBackground: null,
        padding: null,
        margin: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
      );

      cubit.openConfigMenu(mockWidget);

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderConfigMenuOpenedState>(
          (state) => state.model.id.value == "widget2",
        )),
      );

      // When
      cubit.openConfigMenu(anotherWidget);
    });
  });

  group("PagebuilderConfigMenuCubit.openSectionConfigMenu", () {
    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: 1200.0,
      backgroundConstrained: null,
      customCSS: null,
      widgets: [],
      visibleOn: null,
    );

    test("should emit PageBuilderSectionConfigMenuOpenedState with section model",
        () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderSectionConfigMenuOpenedState>(
          (state) => state.model.id.value == "section1",
        )),
      );

      // When
      cubit.openSectionConfigMenu(mockSection);
    });

    test("should emit state with unique ID", () async {
      // When
      cubit.openSectionConfigMenu(mockSection);

      // Then
      final state = cubit.state as PageBuilderSectionConfigMenuOpenedState;
      expect(state.id, isNotNull);
    });

    test("should emit state with provided section model", () async {
      // When
      cubit.openSectionConfigMenu(mockSection);

      // Then
      final state = cubit.state as PageBuilderSectionConfigMenuOpenedState;
      expect(state.model, equals(mockSection));
      expect(state.model.id.value, "section1");
      expect(state.model.name, "Test Section");
    });

    test("should emit new state when called multiple times with same section",
        () async {
      // Given
      cubit.openSectionConfigMenu(mockSection);
      final firstState =
          cubit.state as PageBuilderSectionConfigMenuOpenedState;
      final firstId = firstState.id;

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderSectionConfigMenuOpenedState>(
          (state) => state.id != firstId && state.model == mockSection,
        )),
      );

      // When
      cubit.openSectionConfigMenu(mockSection);
    });

    test("should emit state with different section when opened with new section",
        () async {
      // Given
      final anotherSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section2"),
        name: "Another Section",
        layout: PageBuilderSectionLayout.row,
        background: null,
        maxWidth: 1400.0,
        backgroundConstrained: null,
        customCSS: null,
        widgets: [],
        visibleOn: null,
      );

      cubit.openSectionConfigMenu(mockSection);

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderSectionConfigMenuOpenedState>(
          (state) => state.model.id.value == "section2",
        )),
      );

      // When
      cubit.openSectionConfigMenu(anotherSection);
    });
  });

  group("PagebuilderConfigMenuCubit.closeConfigMenu", () {
    final mockWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget1"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Test Widget",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    test("should emit PageBuilderPageMenuOpenedState when closing widget config menu",
        () async {
      // Given
      cubit.openConfigMenu(mockWidget);

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderPageMenuOpenedState>()),
      );

      // When
      cubit.closeConfigMenu();
    });

    test("should emit PageBuilderPageMenuOpenedState when closing section config menu",
        () async {
      // Given
      final mockSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        name: "Test Section",
        layout: PageBuilderSectionLayout.column,
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        widgets: [],
        visibleOn: null,
      );
      cubit.openSectionConfigMenu(mockSection);

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderPageMenuOpenedState>()),
      );

      // When
      cubit.closeConfigMenu();
    });

    test("should emit state with unique ID", () async {
      // Given
      cubit.openConfigMenu(mockWidget);

      // When
      cubit.closeConfigMenu();

      // Then
      final state = cubit.state as PageBuilderPageMenuOpenedState;
      expect(state.id, isNotNull);
    });

    test("should emit new state when called multiple times", () async {
      // Given
      cubit.closeConfigMenu();
      final firstState = cubit.state as PageBuilderPageMenuOpenedState;
      final firstId = firstState.id;

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PageBuilderPageMenuOpenedState>(
          (state) => state.id != firstId,
        )),
      );

      // When
      cubit.closeConfigMenu();
    });

    test("should work when called without opening any menu first", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderPageMenuOpenedState>()),
      );

      // When
      cubit.closeConfigMenu();
    });
  });

  group("PagebuilderConfigMenuCubit state transitions", () {
    final mockWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget1"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Test Widget",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
      widgets: [],
      visibleOn: null,
    );

    test("should transition from page menu to widget config menu", () async {
      // Given - initial state is PageBuilderPageMenuOpenedState
      expect(cubit.state, isA<PageBuilderPageMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderConfigMenuOpenedState>()),
      );

      // When
      cubit.openConfigMenu(mockWidget);
    });

    test("should transition from page menu to section config menu", () async {
      // Given - initial state is PageBuilderPageMenuOpenedState
      expect(cubit.state, isA<PageBuilderPageMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderSectionConfigMenuOpenedState>()),
      );

      // When
      cubit.openSectionConfigMenu(mockSection);
    });

    test("should transition from widget config to section config menu",
        () async {
      // Given
      cubit.openConfigMenu(mockWidget);
      expect(cubit.state, isA<PageBuilderConfigMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderSectionConfigMenuOpenedState>()),
      );

      // When
      cubit.openSectionConfigMenu(mockSection);
    });

    test("should transition from section config to widget config menu",
        () async {
      // Given
      cubit.openSectionConfigMenu(mockSection);
      expect(cubit.state, isA<PageBuilderSectionConfigMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderConfigMenuOpenedState>()),
      );

      // When
      cubit.openConfigMenu(mockWidget);
    });

    test(
        "should transition from widget config to page menu when closing",
        () async {
      // Given
      cubit.openConfigMenu(mockWidget);
      expect(cubit.state, isA<PageBuilderConfigMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderPageMenuOpenedState>()),
      );

      // When
      cubit.closeConfigMenu();
    });

    test("should transition from section config to page menu when closing",
        () async {
      // Given
      cubit.openSectionConfigMenu(mockSection);
      expect(cubit.state, isA<PageBuilderSectionConfigMenuOpenedState>());

      // Then
      expectLater(
        cubit.stream,
        emits(isA<PageBuilderPageMenuOpenedState>()),
      );

      // When
      cubit.closeConfigMenu();
    });
  });

  group("PagebuilderConfigMenuCubit state equality", () {
    test("two PageBuilderPageMenuOpenedState with same ID should be equal",
        () {
      final id = UniqueID.fromUniqueString("test-id");
      final state1 = PageBuilderPageMenuOpenedState(id: id);
      final state2 = PageBuilderPageMenuOpenedState(id: id);

      expect(state1, equals(state2));
    });

    test("two PageBuilderPageMenuOpenedState with different IDs should not be equal",
        () {
      final state1 = PageBuilderPageMenuOpenedState(id: UniqueID());
      final state2 = PageBuilderPageMenuOpenedState(id: UniqueID());

      expect(state1, isNot(equals(state2)));
    });

    test("two PageBuilderConfigMenuOpenedState with same ID and model should be equal",
        () {
      final id = UniqueID.fromUniqueString("test-id");
      final widget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget1"),
        elementType: PageBuilderWidgetType.text,
        properties: null,
        hoverProperties: null,
        children: null,
        containerChild: null,
        widthPercentage: null,
        background: null,
        hoverBackground: null,
        padding: null,
        margin: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
      );

      final state1 = PageBuilderConfigMenuOpenedState(id: id, model: widget);
      final state2 = PageBuilderConfigMenuOpenedState(id: id, model: widget);

      expect(state1, equals(state2));
    });

    test("two PageBuilderSectionConfigMenuOpenedState with same ID and model should be equal",
        () {
      final id = UniqueID.fromUniqueString("test-id");
      final section = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        name: "Test",
        layout: PageBuilderSectionLayout.column,
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        widgets: [],
        visibleOn: null,
      );

      final state1 =
          PageBuilderSectionConfigMenuOpenedState(id: id, model: section);
      final state2 =
          PageBuilderSectionConfigMenuOpenedState(id: id, model: section);

      expect(state1, equals(state2));
    });
  });
}
