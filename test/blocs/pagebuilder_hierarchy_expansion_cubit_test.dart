import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hierarchy_expansion/pagebuilder_hierarchy_expansion_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderHierarchyExpansionCubit cubit;

  setUp(() {
    cubit = PagebuilderHierarchyExpansionCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group("PagebuilderHierarchyExpansionCubit initialization", () {
    test("initial state should have empty expandedSections", () {
      expect(cubit.state.expandedSections, isEmpty);
    });

    test("initial state should have empty expandedWidgets", () {
      expect(cubit.state.expandedWidgets, isEmpty);
    });
  });

  group("PagebuilderHierarchyExpansionCubit.toggleSection", () {
    test("should expand section when not expanded", () {
      // When
      cubit.toggleSection("section-1");

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
    });

    test("should collapse section when already expanded", () {
      // Given
      cubit.toggleSection("section-1");
      expect(cubit.state.expandedSections, contains("section-1"));

      // When
      cubit.toggleSection("section-1");

      // Then
      expect(cubit.state.expandedSections, isNot(contains("section-1")));
    });

    test("should emit state when toggling section", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => state.expandedSections.contains("section-1"),
        )),
      );

      // When
      cubit.toggleSection("section-1");
    });

    test("should not affect expandedWidgets", () {
      // Given
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.toggleSection("section-1");

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
    });

    test("should toggle multiple different sections independently", () {
      // When
      cubit.toggleSection("section-1");
      cubit.toggleSection("section-2");
      cubit.toggleSection("section-3");

      // Then
      expect(cubit.state.expandedSections.length, equals(3));
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, contains("section-3"));
    });
  });

  group("PagebuilderHierarchyExpansionCubit.toggleWidget", () {
    test("should expand widget when not expanded", () {
      // When
      cubit.toggleWidget("widget-1");

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
    });

    test("should collapse widget when already expanded", () {
      // Given
      cubit.toggleWidget("widget-1");
      expect(cubit.state.expandedWidgets, contains("widget-1"));

      // When
      cubit.toggleWidget("widget-1");

      // Then
      expect(cubit.state.expandedWidgets, isNot(contains("widget-1")));
    });

    test("should emit state when toggling widget", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => state.expandedWidgets.contains("widget-1"),
        )),
      );

      // When
      cubit.toggleWidget("widget-1");
    });

    test("should not affect expandedSections", () {
      // Given
      cubit.expandSections({"section-1"});

      // When
      cubit.toggleWidget("widget-1");

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedSections, contains("section-1"));
    });

    test("should toggle multiple different widgets independently", () {
      // When
      cubit.toggleWidget("widget-1");
      cubit.toggleWidget("widget-2");
      cubit.toggleWidget("widget-3");

      // Then
      expect(cubit.state.expandedWidgets.length, equals(3));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
      expect(cubit.state.expandedWidgets, contains("widget-3"));
    });
  });

  group("PagebuilderHierarchyExpansionCubit.expandSections", () {
    test("should expand single section", () {
      // When
      cubit.expandSections({"section-1"});

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
    });

    test("should expand multiple sections at once", () {
      // When
      cubit.expandSections({"section-1", "section-2", "section-3"});

      // Then
      expect(cubit.state.expandedSections.length, equals(3));
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, contains("section-3"));
    });

    test("should add to existing expanded sections", () {
      // Given
      cubit.expandSections({"section-1"});

      // When
      cubit.expandSections({"section-2", "section-3"});

      // Then
      expect(cubit.state.expandedSections.length, equals(3));
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, contains("section-3"));
    });

    test("should handle empty set", () {
      // Given
      cubit.expandSections({"section-1"});

      // When
      cubit.expandSections({});

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedSections.length, equals(1));
    });

    test("should emit state when expanding sections", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => state.expandedSections.contains("section-1"),
        )),
      );

      // When
      cubit.expandSections({"section-1"});
    });
  });

  group("PagebuilderHierarchyExpansionCubit.expandWidgets", () {
    test("should expand single widget", () {
      // When
      cubit.expandWidgets({"widget-1"});

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
    });

    test("should expand multiple widgets at once", () {
      // When
      cubit.expandWidgets({"widget-1", "widget-2", "widget-3"});

      // Then
      expect(cubit.state.expandedWidgets.length, equals(3));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
      expect(cubit.state.expandedWidgets, contains("widget-3"));
    });

    test("should add to existing expanded widgets", () {
      // Given
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.expandWidgets({"widget-2", "widget-3"});

      // Then
      expect(cubit.state.expandedWidgets.length, equals(3));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
      expect(cubit.state.expandedWidgets, contains("widget-3"));
    });

    test("should handle empty set", () {
      // Given
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.expandWidgets({});

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets.length, equals(1));
    });

    test("should emit state when expanding widgets", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => state.expandedWidgets.contains("widget-1"),
        )),
      );

      // When
      cubit.expandWidgets({"widget-1"});
    });
  });

  group("PagebuilderHierarchyExpansionCubit.collapseSections", () {
    test("should collapse single section", () {
      // Given
      cubit.expandSections({"section-1", "section-2"});

      // When
      cubit.collapseSections({"section-1"});

      // Then
      expect(cubit.state.expandedSections, isNot(contains("section-1")));
      expect(cubit.state.expandedSections, contains("section-2"));
    });

    test("should collapse multiple sections at once", () {
      // Given
      cubit.expandSections({"section-1", "section-2", "section-3"});

      // When
      cubit.collapseSections({"section-1", "section-2"});

      // Then
      expect(cubit.state.expandedSections.length, equals(1));
      expect(cubit.state.expandedSections, contains("section-3"));
    });

    test("should handle collapsing non-existent section", () {
      // Given
      cubit.expandSections({"section-1"});

      // When
      cubit.collapseSections({"section-2"});

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedSections.length, equals(1));
    });

    test("should handle empty set", () {
      // Given
      cubit.expandSections({"section-1"});

      // When
      cubit.collapseSections({});

      // Then
      expect(cubit.state.expandedSections, contains("section-1"));
    });

    test("should emit state when collapsing sections", () async {
      // Given
      cubit.expandSections({"section-1"});

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => !state.expandedSections.contains("section-1"),
        )),
      );

      // When
      cubit.collapseSections({"section-1"});
    });
  });

  group("PagebuilderHierarchyExpansionCubit.collapseWidgets", () {
    test("should collapse single widget", () {
      // Given
      cubit.expandWidgets({"widget-1", "widget-2"});

      // When
      cubit.collapseWidgets({"widget-1"});

      // Then
      expect(cubit.state.expandedWidgets, isNot(contains("widget-1")));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
    });

    test("should collapse multiple widgets at once", () {
      // Given
      cubit.expandWidgets({"widget-1", "widget-2", "widget-3"});

      // When
      cubit.collapseWidgets({"widget-1", "widget-2"});

      // Then
      expect(cubit.state.expandedWidgets.length, equals(1));
      expect(cubit.state.expandedWidgets, contains("widget-3"));
    });

    test("should handle collapsing non-existent widget", () {
      // Given
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.collapseWidgets({"widget-2"});

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets.length, equals(1));
    });

    test("should handle empty set", () {
      // Given
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.collapseWidgets({});

      // Then
      expect(cubit.state.expandedWidgets, contains("widget-1"));
    });

    test("should emit state when collapsing widgets", () async {
      // Given
      cubit.expandWidgets({"widget-1"});

      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) => !state.expandedWidgets.contains("widget-1"),
        )),
      );

      // When
      cubit.collapseWidgets({"widget-1"});
    });
  });

  group("PagebuilderHierarchyExpansionCubit.setExpansionState", () {
    test("should set expansion state with incremental update", () {
      // Given
      cubit.expandSections({"section-1", "section-2"});
      cubit.expandWidgets({"widget-1", "widget-2"});

      // When
      cubit.setExpansionState(
        sectionsToExpand: {"section-3"},
        widgetsToExpand: {"widget-3"},
        sectionsToCollapse: {"section-1"},
        widgetsToCollapse: {"widget-1"},
      );

      // Then
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, contains("section-3"));
      expect(cubit.state.expandedSections, isNot(contains("section-1")));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
      expect(cubit.state.expandedWidgets, contains("widget-3"));
      expect(cubit.state.expandedWidgets, isNot(contains("widget-1")));
    });

    test("should replace entire state when no collapse lists provided", () {
      // Given
      cubit.expandSections({"section-1", "section-2", "section-3"});
      cubit.expandWidgets({"widget-1", "widget-2", "widget-3"});

      // When
      cubit.setExpansionState(
        sectionsToExpand: {"section-4"},
        widgetsToExpand: {"widget-4"},
        sectionsToCollapse: {},
        widgetsToCollapse: {},
      );

      // Then
      expect(cubit.state.expandedSections.length, equals(1));
      expect(cubit.state.expandedSections, contains("section-4"));
      expect(cubit.state.expandedWidgets.length, equals(1));
      expect(cubit.state.expandedWidgets, contains("widget-4"));
    });

    test("should not emit when state doesn't change", () {
      // Given
      cubit.expandSections({"section-1"});
      cubit.expandWidgets({"widget-1"});

      // When - setting the same state
      cubit.setExpansionState(
        sectionsToExpand: {"section-1"},
        widgetsToExpand: {"widget-1"},
        sectionsToCollapse: {},
        widgetsToCollapse: {},
      );

      // Then - state should remain the same
      expect(cubit.state.expandedSections, contains("section-1"));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
    });

    test("should emit state when there are changes", () async {
      // Then
      expectLater(
        cubit.stream,
        emits(predicate<PagebuilderHierarchyExpansionState>(
          (state) =>
              state.expandedSections.contains("section-1") &&
              state.expandedWidgets.contains("widget-1"),
        )),
      );

      // When
      cubit.setExpansionState(
        sectionsToExpand: {"section-1"},
        widgetsToExpand: {"widget-1"},
        sectionsToCollapse: {},
        widgetsToCollapse: {},
      );
    });

    test("should handle empty expand and collapse sets", () {
      // Given
      cubit.expandSections({"section-1"});
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.setExpansionState(
        sectionsToExpand: {},
        widgetsToExpand: {},
        sectionsToCollapse: {},
        widgetsToCollapse: {},
      );

      // Then - should replace with empty state
      expect(cubit.state.expandedSections, isEmpty);
      expect(cubit.state.expandedWidgets, isEmpty);
    });

    test("should handle partial collapse with incremental update", () {
      // Given
      cubit.expandSections({"section-1", "section-2", "section-3"});
      cubit.expandWidgets({"widget-1", "widget-2"});

      // When
      cubit.setExpansionState(
        sectionsToExpand: {"section-4"},
        widgetsToExpand: {},
        sectionsToCollapse: {"section-1"},
        widgetsToCollapse: {},
      );

      // Then
      expect(cubit.state.expandedSections.length, equals(3));
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, contains("section-3"));
      expect(cubit.state.expandedSections, contains("section-4"));
      expect(cubit.state.expandedWidgets.length, equals(2));
    });
  });

  group("PagebuilderHierarchyExpansionCubit complex scenarios", () {
    test("should handle multiple operations in sequence", () {
      // When
      cubit.expandSections({"section-1"});
      cubit.toggleSection("section-2");
      cubit.expandWidgets({"widget-1", "widget-2"});
      cubit.toggleWidget("widget-1");
      cubit.collapseSections({"section-1"});

      // Then
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedSections, isNot(contains("section-1")));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
      expect(cubit.state.expandedWidgets, isNot(contains("widget-1")));
    });

    test("should maintain state independence between sections and widgets", () {
      // When
      cubit.expandSections({"section-1", "section-2"});
      cubit.expandWidgets({"widget-1", "widget-2"});
      cubit.collapseSections({"section-1"});

      // Then
      expect(cubit.state.expandedSections, contains("section-2"));
      expect(cubit.state.expandedWidgets.length, equals(2));
      expect(cubit.state.expandedWidgets, contains("widget-1"));
      expect(cubit.state.expandedWidgets, contains("widget-2"));
    });

    test("should handle expanding already expanded items", () {
      // Given
      cubit.expandSections({"section-1"});
      cubit.expandWidgets({"widget-1"});

      // When
      cubit.expandSections({"section-1"});
      cubit.expandWidgets({"widget-1"});

      // Then
      expect(cubit.state.expandedSections.length, equals(1));
      expect(cubit.state.expandedWidgets.length, equals(1));
    });

    test("should handle collapsing already collapsed items", () {
      // When
      cubit.collapseSections({"section-1"});
      cubit.collapseWidgets({"widget-1"});

      // Then
      expect(cubit.state.expandedSections, isEmpty);
      expect(cubit.state.expandedWidgets, isEmpty);
    });
  });

  group("PagebuilderHierarchyExpansionState", () {
    test("should create state with empty sets by default", () {
      const state = PagebuilderHierarchyExpansionState();

      expect(state.expandedSections, isEmpty);
      expect(state.expandedWidgets, isEmpty);
    });

    test("should create state with provided sets", () {
      final state = PagebuilderHierarchyExpansionState(
        expandedSections: {"section-1", "section-2"},
        expandedWidgets: {"widget-1"},
      );

      expect(state.expandedSections.length, equals(2));
      expect(state.expandedWidgets.length, equals(1));
    });

    test("copyWith should copy state with new sections", () {
      final originalState = PagebuilderHierarchyExpansionState(
        expandedSections: {"section-1"},
        expandedWidgets: {"widget-1"},
      );

      final newState = originalState.copyWith(
        expandedSections: {"section-2"},
      );

      expect(newState.expandedSections, contains("section-2"));
      expect(newState.expandedWidgets, contains("widget-1"));
    });

    test("copyWith should copy state with new widgets", () {
      final originalState = PagebuilderHierarchyExpansionState(
        expandedSections: {"section-1"},
        expandedWidgets: {"widget-1"},
      );

      final newState = originalState.copyWith(
        expandedWidgets: {"widget-2"},
      );

      expect(newState.expandedSections, contains("section-1"));
      expect(newState.expandedWidgets, contains("widget-2"));
    });

    test("copyWith should keep original values when not provided", () {
      final originalState = PagebuilderHierarchyExpansionState(
        expandedSections: {"section-1"},
        expandedWidgets: {"widget-1"},
      );

      final newState = originalState.copyWith();

      expect(newState.expandedSections, equals(originalState.expandedSections));
      expect(newState.expandedWidgets, equals(originalState.expandedWidgets));
    });
  });
}
