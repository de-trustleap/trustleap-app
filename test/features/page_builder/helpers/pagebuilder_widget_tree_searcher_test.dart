import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_widget_tree_searcher.dart';

PageBuilderWidget _widget(String id, PageBuilderWidgetType type,
    {List<PageBuilderWidget>? children, PageBuilderWidget? containerChild}) {
  return PageBuilderWidget(
    id: UniqueID.fromUniqueString(id),
    elementType: type,
    properties: null,
    hoverProperties: null,
    children: children ?? [],
    containerChild: containerChild,
    widthPercentage: null,
    background: null,
    hoverBackground: null,
    padding: null,
    margin: null,
    maxWidth: null,
    alignment: null,
    customCSS: null,
  );
}

PageBuilderPage _page(List<List<PageBuilderWidget>> widgetsPerSection) {
  final sections = widgetsPerSection.asMap().entries.map((entry) {
    return PageBuilderSection(
      id: UniqueID.fromUniqueString('section${entry.key}'),
      name: 'Section ${entry.key}',
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
      fullHeight: null,
      widgets: entry.value,
      visibleOn: null,
    );
  }).toList();
  return PageBuilderPage(
    id: UniqueID.fromUniqueString('page1'),
    sections: sections,
    backgroundColor: null,
    globalStyles: null,
  );
}

void main() {
  group('PagebuilderWidgetTreeSearcher_findWidgetById', () {
    test('returns null if widget not found', () {
      final page = _page([
        [_widget('w1', PageBuilderWidgetType.text)],
      ]);
      final result = PagebuilderWidgetTreeSearcher.findWidgetById(
          page.sections![0].widgets![0],
          UniqueID.fromUniqueString('nonexistent').value);
      expect(result, isNull);
    });

    test('returns widget if id matches root', () {
      final w = _widget('w1', PageBuilderWidgetType.text);
      final result =
          PagebuilderWidgetTreeSearcher.findWidgetById(w, 'w1');
      expect(result?.id.value, equals('w1'));
    });

    test('finds widget in children', () {
      final child = _widget('child', PageBuilderWidgetType.text);
      final parent = _widget('parent', PageBuilderWidgetType.column,
          children: [child]);
      final result =
          PagebuilderWidgetTreeSearcher.findWidgetById(parent, 'child');
      expect(result?.id.value, equals('child'));
    });

    test('finds widget in containerChild', () {
      final inner = _widget('inner', PageBuilderWidgetType.footer);
      final outer = _widget('outer', PageBuilderWidgetType.container,
          containerChild: inner);
      final result =
          PagebuilderWidgetTreeSearcher.findWidgetById(outer, 'inner');
      expect(result?.id.value, equals('inner'));
    });
  });

  group('PagebuilderWidgetTreeSearcher_countWidgetsByType', () {
    test('returns 0 when no widgets of type exist', () {
      final page = _page([
        [_widget('w1', PageBuilderWidgetType.text)],
      ]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.footer),
        equals(0),
      );
    });

    test('returns 1 when exactly one widget of type exists', () {
      final page = _page([
        [
          _widget('w1', PageBuilderWidgetType.text),
          _widget('w2', PageBuilderWidgetType.footer),
        ],
      ]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.footer),
        equals(1),
      );
    });

    test('returns 2 when same type appears in two sections', () {
      final page = _page([
        [_widget('w1', PageBuilderWidgetType.calendly)],
        [_widget('w2', PageBuilderWidgetType.calendly)],
      ]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.calendly),
        equals(2),
      );
    });

    test('counts nested widget in children', () {
      final inner = _widget('inner', PageBuilderWidgetType.contactForm);
      final outer =
          _widget('outer', PageBuilderWidgetType.column, children: [inner]);
      final page = _page([[outer]]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.contactForm),
        equals(1),
      );
    });

    test('counts nested widget in containerChild', () {
      final inner = _widget('inner', PageBuilderWidgetType.footer);
      final outer = _widget('outer', PageBuilderWidgetType.container,
          containerChild: inner);
      final page = _page([[outer]]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.footer),
        equals(1),
      );
    });

    test('counts widgets at multiple nesting levels', () {
      final deep = _widget('deep', PageBuilderWidgetType.calendly);
      final mid =
          _widget('mid', PageBuilderWidgetType.column, children: [deep]);
      final top = _widget('top', PageBuilderWidgetType.calendly);
      final page = _page([[top, mid]]);
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.calendly),
        equals(2),
      );
    });

    test('returns 0 when sections is null', () {
      final page = PageBuilderPage(
        id: UniqueID.fromUniqueString('page1'),
        sections: null,
        backgroundColor: null,
        globalStyles: null,
      );
      expect(
        PagebuilderWidgetTreeSearcher.countWidgetsByType(
            page, PageBuilderWidgetType.footer),
        equals(0),
      );
    });
  });
}
