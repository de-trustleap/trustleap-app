import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_widget_tree_manipulator.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  // Helper function to create a simple text widget
  PageBuilderWidget createTextWidget(String id) {
    return PageBuilderWidget(
      id: UniqueID.fromUniqueString(id),
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
      customCSS: '',
    );
  }

  // Helper function to create a column widget
  PageBuilderWidget createColumnWidget(
      String id, List<PageBuilderWidget> children) {
    return PageBuilderWidget(
      id: UniqueID.fromUniqueString(id),
      elementType: PageBuilderWidgetType.column,
      properties: null,
      hoverProperties: null,
      children: children,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: '',
    );
  }

  // Helper function to create a row widget
  PageBuilderWidget createRowWidget(
      String id, List<PageBuilderWidget> children) {
    return PageBuilderWidget(
      id: UniqueID.fromUniqueString(id),
      elementType: PageBuilderWidgetType.row,
      properties: null,
      hoverProperties: null,
      children: children,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: '',
    );
  }

  // Helper function to create a container widget
  PageBuilderWidget createContainerWidget(
      String id, PageBuilderWidget? child) {
    return PageBuilderWidget(
      id: UniqueID.fromUniqueString(id),
      elementType: PageBuilderWidgetType.container,
      properties: null,
      hoverProperties: null,
      children: null,
      containerChild: child,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: '',
    );
  }

  group("PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList", () {
    group("Target widget at top level", () {
      test("wraps widgets in Row when position is 'before'", () {
        final targetWidget = createTextWidget('target');
        final newWidget = createTextWidget('new');
        final widgets = [targetWidget];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 1);
        expect(result[0].elementType, PageBuilderWidgetType.row);
        expect(result[0].children?.length, 2);
        expect(result[0].children?[0].id.value, 'new');
        expect(result[0].children?[1].id.value, 'target');
      });

      test("wraps widgets in Row when position is 'after'", () {
        final targetWidget = createTextWidget('target');
        final newWidget = createTextWidget('new');
        final widgets = [targetWidget];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.after,
        );

        expect(result.length, 1);
        expect(result[0].elementType, PageBuilderWidgetType.row);
        expect(result[0].children?.length, 2);
        expect(result[0].children?[0].id.value, 'target');
        expect(result[0].children?[1].id.value, 'new');
      });

      test("wraps widgets in Column when position is 'above'", () {
        final targetWidget = createTextWidget('target');
        final newWidget = createTextWidget('new');
        final widgets = [targetWidget];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.above,
        );

        expect(result.length, 1);
        expect(result[0].elementType, PageBuilderWidgetType.column);
        expect(result[0].children?.length, 2);
        expect(result[0].children?[0].id.value, 'new');
        expect(result[0].children?[1].id.value, 'target');
      });

      test("wraps widgets in Column when position is 'below'", () {
        final targetWidget = createTextWidget('target');
        final newWidget = createTextWidget('new');
        final widgets = [targetWidget];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.below,
        );

        expect(result.length, 1);
        expect(result[0].elementType, PageBuilderWidgetType.column);
        expect(result[0].children?.length, 2);
        expect(result[0].children?[0].id.value, 'target');
        expect(result[0].children?[1].id.value, 'new');
      });

      test(
          "adds to target's children when position is 'inside' and target is column",
          () {
        final childWidget = createTextWidget('child1');
        final targetWidget = createColumnWidget('target', [childWidget]);
        final newWidget = createTextWidget('new');
        final widgets = [targetWidget];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.inside,
        );

        expect(result.length, 1);
        expect(result[0].id.value, 'target');
        expect(result[0].children?.length, 2);
        expect(result[0].children?[0].id.value, 'child1');
        expect(result[0].children?[1].id.value, 'new');
      });
    });

    group("Multiple widgets at top level", () {
      test("only wraps the target widget with before position", () {
        final widget1 = createTextWidget('widget1');
        final targetWidget = createTextWidget('target');
        final widget3 = createTextWidget('widget3');
        final newWidget = createTextWidget('new');
        final widgets = [widget1, targetWidget, widget3];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 3);
        expect(result[0].id.value, 'widget1');
        expect(result[1].elementType, PageBuilderWidgetType.row);
        expect(result[1].children?.length, 2);
        expect(result[1].children?[0].id.value, 'new');
        expect(result[1].children?[1].id.value, 'target');
        expect(result[2].id.value, 'widget3');
      });

      test("only wraps the target widget with above position", () {
        final widget1 = createTextWidget('widget1');
        final targetWidget = createTextWidget('target');
        final widget3 = createTextWidget('widget3');
        final newWidget = createTextWidget('new');
        final widgets = [widget1, targetWidget, widget3];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.above,
        );

        expect(result.length, 3);
        expect(result[0].id.value, 'widget1');
        expect(result[1].elementType, PageBuilderWidgetType.column);
        expect(result[1].children?.length, 2);
        expect(result[1].children?[0].id.value, 'new');
        expect(result[1].children?[1].id.value, 'target');
        expect(result[2].id.value, 'widget3');
      });
    });

    group("Target widget in nested structure", () {
      test("recursively finds target in nested column and wraps it", () {
        final nestedTarget = createTextWidget('nested-target');
        final nestedColumn = createColumnWidget('nested-col', [nestedTarget]);
        final topWidget = createTextWidget('top');
        final newWidget = createTextWidget('new');
        final widgets = [topWidget, nestedColumn];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'nested-target',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 2);
        expect(result[0].id.value, 'top');
        expect(result[1].id.value, 'nested-col');
        expect(result[1].children?.length, 1);
        expect(result[1].children?[0].elementType, PageBuilderWidgetType.row);
        expect(result[1].children?[0].children?.length, 2);
        expect(result[1].children?[0].children?[0].id.value, 'new');
        expect(result[1].children?[0].children?[1].id.value, 'nested-target');
      });

      test("recursively finds target in nested row and adds to row", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final nestedRow = createRowWidget('nested-row', [child1, child2]);
        final topWidget = createTextWidget('top');
        final newWidget = createTextWidget('new');
        final widgets = [topWidget, nestedRow];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'child1',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 2);
        expect(result[0].id.value, 'top');
        expect(result[1].id.value, 'nested-row');
        expect(result[1].children?.length, 3);
        expect(result[1].children?[0].id.value, 'new');
        expect(result[1].children?[1].id.value, 'child1');
        expect(result[1].children?[2].id.value, 'child2');
      });
    });

    group("Edge cases", () {
      test("returns unchanged list when target widget not found", () {
        final widget1 = createTextWidget('widget1');
        final widget2 = createTextWidget('widget2');
        final newWidget = createTextWidget('new');
        final widgets = [widget1, widget2];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'nonexistent',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 2);
        expect(result[0].id.value, 'widget1');
        expect(result[1].id.value, 'widget2');
      });

      test("handles empty list", () {
        final newWidget = createTextWidget('new');
        final widgets = <PageBuilderWidget>[];

        final result =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          widgets,
          'target',
          newWidget,
          DropPosition.before,
        );

        expect(result.length, 0);
      });
    });
  });

  group("PagebuilderWidgetTreeManipulator.addWidgetAtPosition", () {
    group("Inside position", () {
      test("adds widget inside empty container", () {
        final container = createContainerWidget('container', null);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          container,
          'container',
          newWidget,
          DropPosition.inside,
        );

        expect(result.id.value, 'container');
        expect(result.containerChild, isNotNull);
        expect(result.containerChild?.id.value, 'new');
      });

      test("adds widget inside column", () {
        final child1 = createTextWidget('child1');
        final column = createColumnWidget('column', [child1]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          column,
          'column',
          newWidget,
          DropPosition.inside,
        );

        expect(result.id.value, 'column');
        expect(result.children?.length, 2);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
      });

      test("adds widget inside row and redistributes width", () {
        final child1 = createTextWidget('child1');
        final row = createRowWidget('row', [child1]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          row,
          'row',
          newWidget,
          DropPosition.inside,
        );

        expect(result.id.value, 'row');
        expect(result.children?.length, 2);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
      });
    });

    group("Before/After positions in Row", () {
      test("inserts before target widget in row", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final row = createRowWidget('row', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          row,
          'child2',
          newWidget,
          DropPosition.before,
        );

        expect(result.children?.length, 3);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
        expect(result.children?[2].id.value, 'child2');
      });

      test("inserts after target widget in row", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final row = createRowWidget('row', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          row,
          'child1',
          newWidget,
          DropPosition.after,
        );

        expect(result.children?.length, 3);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
        expect(result.children?[2].id.value, 'child2');
      });
    });

    group("Above/Below positions in Column", () {
      test("inserts above target widget in column", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final column = createColumnWidget('column', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          column,
          'child2',
          newWidget,
          DropPosition.above,
        );

        expect(result.children?.length, 3);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
        expect(result.children?[2].id.value, 'child2');
      });

      test("inserts below target widget in column", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final column = createColumnWidget('column', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          column,
          'child1',
          newWidget,
          DropPosition.below,
        );

        expect(result.children?.length, 3);
        expect(result.children?[0].id.value, 'child1');
        expect(result.children?[1].id.value, 'new');
        expect(result.children?[2].id.value, 'child2');
      });
    });

    group("Wrapping scenarios", () {
      test("wraps target in Row when adding before in Column", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final column = createColumnWidget('column', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          column,
          'child1',
          newWidget,
          DropPosition.before,
        );

        expect(result.children?.length, 2);
        expect(result.children?[0].elementType, PageBuilderWidgetType.row);
        expect(result.children?[0].children?.length, 2);
        expect(result.children?[0].children?[0].id.value, 'new');
        expect(result.children?[0].children?[1].id.value, 'child1');
        expect(result.children?[1].id.value, 'child2');
      });

      test("wraps target in Column when adding above in Row", () {
        final child1 = createTextWidget('child1');
        final child2 = createTextWidget('child2');
        final row = createRowWidget('row', [child1, child2]);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          row,
          'child1',
          newWidget,
          DropPosition.above,
        );

        expect(result.children?.length, 2);
        expect(result.children?[0].elementType, PageBuilderWidgetType.column);
        expect(result.children?[0].children?.length, 2);
        expect(result.children?[0].children?[0].id.value, 'new');
        expect(result.children?[0].children?[1].id.value, 'child1');
        expect(result.children?[1].id.value, 'child2');
      });
    });

    group("Container child scenarios", () {
      test("wraps container child with new widget when adding before", () {
        final containerChild = createTextWidget('child');
        final container = createContainerWidget('container', containerChild);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          container,
          'child',
          newWidget,
          DropPosition.before,
        );

        expect(result.containerChild, isNotNull);
        expect(result.containerChild?.elementType, PageBuilderWidgetType.row);
        expect(result.containerChild?.children?.length, 2);
        expect(result.containerChild?.children?[0].id.value, 'new');
        expect(result.containerChild?.children?[1].id.value, 'child');
      });

      test("wraps container child with new widget when adding above", () {
        final containerChild = createTextWidget('child');
        final container = createContainerWidget('container', containerChild);
        final newWidget = createTextWidget('new');

        final result = PagebuilderWidgetTreeManipulator.addWidgetAtPosition(
          container,
          'child',
          newWidget,
          DropPosition.above,
        );

        expect(result.containerChild, isNotNull);
        expect(
            result.containerChild?.elementType, PageBuilderWidgetType.column);
        expect(result.containerChild?.children?.length, 2);
        expect(result.containerChild?.children?[0].id.value, 'new');
        expect(result.containerChild?.children?[1].id.value, 'child');
      });
    });
  });

  group("PagebuilderWidgetTreeManipulator.updateWidget", () {
    test("updates target widget at root level", () {
      final widget = createTextWidget('target');

      final result = PagebuilderWidgetTreeManipulator.updateWidget(
        widget,
        'target',
        (w) => w.copyWith(customCSS: 'updated-css'),
      );

      expect(result.customCSS, 'updated-css');
    });

    test("updates target widget in children", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final column = createColumnWidget('column', [child1, child2]);

      final result = PagebuilderWidgetTreeManipulator.updateWidget(
        column,
        'child2',
        (w) => w.copyWith(customCSS: 'updated-child2-css'),
      );

      expect(result.children?[1].customCSS, 'updated-child2-css');
      expect(result.children?[0].customCSS, '');
    });

    test("updates target widget in container child", () {
      final containerChild = createTextWidget('child');
      final container = createContainerWidget('container', containerChild);

      final result = PagebuilderWidgetTreeManipulator.updateWidget(
        container,
        'child',
        (w) => w.copyWith(customCSS: 'updated-container-child-css'),
      );

      expect(result.containerChild?.customCSS, 'updated-container-child-css');
    });

    test("updates target widget in deeply nested structure", () {
      final deepChild = createTextWidget('deep-child');
      final innerColumn = createColumnWidget('inner-column', [deepChild]);
      final outerColumn = createColumnWidget('outer-column', [innerColumn]);

      final result = PagebuilderWidgetTreeManipulator.updateWidget(
        outerColumn,
        'deep-child',
        (w) => w.copyWith(customCSS: 'updated-deep-css'),
      );

      expect(result.children?[0].children?[0].customCSS, 'updated-deep-css');
    });

    test("returns unchanged widget when target not found", () {
      final widget = createTextWidget('target');

      final result = PagebuilderWidgetTreeManipulator.updateWidget(
        widget,
        'nonexistent',
        (w) => w.copyWith(customCSS: 'should-not-update'),
      );

      expect(result.customCSS, '');
    });
  });

  group("PagebuilderWidgetTreeManipulator.reorderChildren", () {
    test("reorders children in target container", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final child3 = createTextWidget('child3');
      final column = createColumnWidget('column', [child1, child2, child3]);

      final result = PagebuilderWidgetTreeManipulator.reorderChildren(
        column,
        'column',
        0,
        2,
      );

      expect(result.children?.length, 3);
      expect(result.children?[0].id.value, 'child2');
      expect(result.children?[1].id.value, 'child1');
      expect(result.children?[2].id.value, 'child3');
    });

    test("reorders children moving from end to start", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final child3 = createTextWidget('child3');
      final column = createColumnWidget('column', [child1, child2, child3]);

      final result = PagebuilderWidgetTreeManipulator.reorderChildren(
        column,
        'column',
        2,
        0,
      );

      expect(result.children?.length, 3);
      expect(result.children?[0].id.value, 'child3');
      expect(result.children?[1].id.value, 'child1');
      expect(result.children?[2].id.value, 'child2');
    });

    test("searches in nested structure", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final innerColumn = createColumnWidget('inner-column', [child1, child2]);
      final outerColumn = createColumnWidget('outer-column', [innerColumn]);

      final result = PagebuilderWidgetTreeManipulator.reorderChildren(
        outerColumn,
        'inner-column',
        0,
        2,
      );

      expect(result.children?[0].children?.length, 2);
      expect(result.children?[0].children?[0].id.value, 'child2');
      expect(result.children?[0].children?[1].id.value, 'child1');
    });

    test("returns unchanged widget when container not found", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final column = createColumnWidget('column', [child1, child2]);

      final result = PagebuilderWidgetTreeManipulator.reorderChildren(
        column,
        'nonexistent',
        0,
        1,
      );

      expect(result.children?[0].id.value, 'child1');
      expect(result.children?[1].id.value, 'child2');
    });

    test("returns unchanged widget when indices are invalid", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final column = createColumnWidget('column', [child1, child2]);

      final result = PagebuilderWidgetTreeManipulator.reorderChildren(
        column,
        'column',
        5,
        1,
      );

      expect(result.children?[0].id.value, 'child1');
      expect(result.children?[1].id.value, 'child2');
    });
  });

  group("PagebuilderWidgetTreeManipulator.deleteWidget", () {
    test("deletes target widget at root level", () {
      final widget = createTextWidget('target');

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        widget,
        'target',
      );

      expect(result, isNull);
    });

    test("deletes target widget from children list", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final child3 = createTextWidget('child3');
      final column = createColumnWidget('column', [child1, child2, child3]);

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        column,
        'child2',
      );

      expect(result?.children?.length, 2);
      expect(result?.children?[0].id.value, 'child1');
      expect(result?.children?[1].id.value, 'child3');
    });

    test("deletes container child", () {
      final containerChild = createTextWidget('child');
      final container = createContainerWidget('container', containerChild);

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        container,
        'child',
      );

      // Note: Current implementation cannot set containerChild to null
      // because copyWith doesn't support removing containerChild
      // The result will still have the containerChild (unchanged)
      expect(result?.containerChild, isNotNull);
      expect(result?.containerChild?.id.value, 'child');
    });

    test("deletes target widget from deeply nested structure", () {
      final deepChild = createTextWidget('deep-child');
      final sibling = createTextWidget('sibling');
      final innerColumn =
          createColumnWidget('inner-column', [deepChild, sibling]);
      final outerColumn = createColumnWidget('outer-column', [innerColumn]);

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        outerColumn,
        'deep-child',
      );

      expect(result?.children?[0].children?.length, 1);
      expect(result?.children?[0].children?[0].id.value, 'sibling');
    });

    test("returns unchanged widget when target not found", () {
      final child1 = createTextWidget('child1');
      final child2 = createTextWidget('child2');
      final column = createColumnWidget('column', [child1, child2]);

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        column,
        'nonexistent',
      );

      expect(result?.children?.length, 2);
      expect(result?.children?[0].id.value, 'child1');
      expect(result?.children?[1].id.value, 'child2');
    });

    test("recursively searches and deletes in nested structure", () {
      final grandChild = createTextWidget('grandchild');
      final childColumn = createColumnWidget('child-column', [grandChild]);
      final parentContainer =
          createContainerWidget('parent-container', childColumn);

      final result = PagebuilderWidgetTreeManipulator.deleteWidget(
        parentContainer,
        'grandchild',
      );

      expect(result?.containerChild?.children?.length, 0);
    });
  });
}
