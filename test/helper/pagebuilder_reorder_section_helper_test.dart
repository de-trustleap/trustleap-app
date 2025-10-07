import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_reorder_section_helper.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  group('PagebuilderReorderSectionHelper', () {
    late List<PageBuilderSection> sections;

    setUp(() {
      sections = [
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section1"),
          name: "Section 1",
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section2"),
          name: "Section 2",
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section3"),
          name: "Section 3",
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          widgets: [],
          visibleOn: null,
        ),
        PageBuilderSection(
          id: UniqueID.fromUniqueString("section4"),
          name: "Section 4",
          layout: PageBuilderSectionLayout.column,
          background: null,
          maxWidth: null,
          backgroundConstrained: null,
          widgets: [],
          visibleOn: null,
        ),
      ];
    });

    test('should move item from index 0 to index 2', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 0, 2);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 3"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 2 to index 0', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 2, 0);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 3"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 1 to index 3', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 1, 3);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 3"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move item from index 3 to index 1', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 3, 1);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 4"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 3"));
    });

    test('should handle moving to same position', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 1, 1);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 1"));
      expect(result[1].name, equals("Section 2"));
      expect(result[2].name, equals("Section 3"));
      expect(result[3].name, equals("Section 4"));
    });

    test('should move last item to first position', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 3, 0);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 4"));
      expect(result[1].name, equals("Section 1"));
      expect(result[2].name, equals("Section 2"));
      expect(result[3].name, equals("Section 3"));
    });

    test('should move first item to last position', () {
      final result =
          PagebuilderReorderSectionHelper.reorderSections(sections, 0, 4);

      expect(result.length, equals(4));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 3"));
      expect(result[2].name, equals("Section 4"));
      expect(result[3].name, equals("Section 1"));
    });

    test('should not modify original list', () {
      final originalFirst = sections[0].name;
      final originalSecond = sections[1].name;

      PagebuilderReorderSectionHelper.reorderSections(sections, 0, 2);

      expect(sections[0].name, equals(originalFirst));
      expect(sections[1].name, equals(originalSecond));
    });

    test('should handle list with two items', () {
      final twoSections = [sections[0], sections[1]];
      final result = PagebuilderReorderSectionHelper.reorderSections(
          twoSections, 0, 2);

      expect(result.length, equals(2));
      expect(result[0].name, equals("Section 2"));
      expect(result[1].name, equals("Section 1"));
    });

    test('should handle list with single item', () {
      final singleSection = [sections[0]];
      final result = PagebuilderReorderSectionHelper.reorderSections(
          singleSection, 0, 0);

      expect(result.length, equals(1));
      expect(result[0].name, equals("Section 1"));
    });
  });
}
