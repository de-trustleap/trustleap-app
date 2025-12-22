import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_reorder_helper.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  group('PagebuilderReorderHelper_reorderSections', () {
    late List<PageBuilderSection> sections;

    setUp(() {
      sections = [
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section1"),
          name: "Section 1",
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section2"),
          name: "Section 2",
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section3"),
          name: "Section 3",
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section4"),
          name: "Section 4",
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          customCSS: null,
          fullHeight: null,
          widgets: [],
          visibleOn: null,
        ),
      ];
    });

    test('should move item from index 0 to index 2', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 0, 2);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 3"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 2 to index 0', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 2, 0);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 3"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 1 to index 3', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 1, 3);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 3"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 3 to index 1', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 3, 1);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 4"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 3"));
    });

    test('should handle moving to same position', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 1, 1);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 2"));
      expect(result[2].name, equals("Section 3"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move last item to first position', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 3, 0);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 4"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 3"));
    });

    test('should move first item to last position', () {
      final result =
          PagebuilderReorderHelper.reorderSections(sections, 0, 4);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 3"));
      expect(result[2].name, equals("Section 4"));
      expect(result[3].name, equals("Section 1"));
    });

    test('should not modify original list', () {
      final originalFirst = sections[0].name;
      final originalSecond = sections[1].name;

      PagebuilderReorderHelper.reorderSections(sections, 0, 2);

      expect(sections[0].name, equals(originalFirst));
      expect(sections[1].name, equals(originalSecond));
    });

    test('should handle list with two items', () {
      final twoSections = [sections[0], sections[1]];
      final result = PagebuilderReorderHelper.reorderSections(
          twoSections, 0, 2);

      expect(result.length, equals(2));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 1"));
    });

    test('should handle list with single item', () {
      final singleSection = [sections[0]];
      final result = PagebuilderReorderHelper.reorderSections(
          singleSection, 0, 0);

      expect(result.length, equals(1));
      expect(result[0].name, equals("Section 1"));
    });
  });

  group('PagebuilderReorderHelper_reorderWidgets', () {
    late List<PageBuilderWidget> widgets;

    setUp(() {
      widgets = [
        PageBuilderWidget(
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
        ),
        PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget2"),
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
        ),
        PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget3"),
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
        ),
        PageBuilderWidget(
          id: UniqueID.fromUniqueString("widget4"),
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
        ),
      ];
    });

    test('should move widget from index 0 to index 2', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 0, 2);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget2"));
      expect(result[1].id.value, equals("widget1"));
      expect(result[2].id.value, equals("widget3"));
      expect(result[3].id.value, equals("widget4"));
    });

    test('should move widget from index 2 to index 0', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 2, 0);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget3"));
      expect(result[1].id.value, equals("widget1"));
      expect(result[2].id.value, equals("widget2"));
      expect(result[3].id.value, equals("widget4"));
    });

    test('should move widget from index 1 to index 3', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 1, 3);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget1"));
      expect(result[1].id.value, equals("widget3"));
      expect(result[2].id.value, equals("widget2"));
      expect(result[3].id.value, equals("widget4"));
    });

    test('should move widget from index 3 to index 1', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 3, 1);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget1"));
      expect(result[1].id.value, equals("widget4"));
      expect(result[2].id.value, equals("widget2"));
      expect(result[3].id.value, equals("widget3"));
    });

    test('should handle moving widget to same position', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 1, 1);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget1"));
      expect(result[1].id.value, equals("widget2"));
      expect(result[2].id.value, equals("widget3"));
      expect(result[3].id.value, equals("widget4"));
    });

    test('should move last widget to first position', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 3, 0);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget4"));
      expect(result[1].id.value, equals("widget1"));
      expect(result[2].id.value, equals("widget2"));
      expect(result[3].id.value, equals("widget3"));
    });

    test('should move first widget to last position', () {
      final result =
          PagebuilderReorderHelper.reorderWidgets(widgets, 0, 4);

      expect(result.length, equals(4));
      expect(result[0].id.value, equals("widget2"));
      expect(result[1].id.value, equals("widget3"));
      expect(result[2].id.value, equals("widget4"));
      expect(result[3].id.value, equals("widget1"));
    });

    test('should not modify original widget list', () {
      final originalFirst = widgets[0].id.value;
      final originalSecond = widgets[1].id.value;

      PagebuilderReorderHelper.reorderWidgets(widgets, 0, 2);

      expect(widgets[0].id.value, equals(originalFirst));
      expect(widgets[1].id.value, equals(originalSecond));
    });

    test('should handle widget list with two items', () {
      final twoWidgets = [widgets[0], widgets[1]];
      final result = PagebuilderReorderHelper.reorderWidgets(
          twoWidgets, 0, 2);

      expect(result.length, equals(2));
      expect(result[0].id.value, equals("widget2"));
      expect(result[1].id.value, equals("widget1"));
    });

    test('should handle widget list with single item', () {
      final singleWidget = [widgets[0]];
      final result = PagebuilderReorderHelper.reorderWidgets(
          singleWidget, 0, 0);

      expect(result.length, equals(1));
      expect(result[0].id.value, equals("widget1"));
    });
  });
}
