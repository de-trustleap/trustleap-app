import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/core/helpers/animated_list_differ.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget dummyBuilder(String item, Animation<double> animation) =>
      const SizedBox();

  group('AnimatedListDiffer', () {
    test('initializes with given list', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      expect(differ.items, ['a', 'b', 'c']);
    });

    test('update with same list makes no changes', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'b', 'c'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'b', 'c']);
    });

    test('update removes item no longer in new list', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'c'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'c']);
    });

    test('update inserts new item', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'b', 'c'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'b', 'c']);
    });

    test('update handles multiple removals', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c', 'd'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['b'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['b']);
    });

    test('update handles multiple insertions', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['b'],
        isSame: (a, b) => a == b,
      );
      differ.update(
          newList: ['a', 'b', 'c', 'd'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'b', 'c', 'd']);
    });

    test('update handles simultaneous removals and insertions', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'd', 'c'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'd', 'c']);
    });

    test('update clears all items when new list is empty', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: [], buildRemovedItem: dummyBuilder);
      expect(differ.items, isEmpty);
    });

    test('update populates from empty list', () {
      final differ = AnimatedListDiffer<String>(
        initialList: [],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'b', 'c'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['a', 'b', 'c']);
    });

    test('multiple sequential updates keep items in sync', () {
      final differ = AnimatedListDiffer<String>(
        initialList: ['a', 'b', 'c'],
        isSame: (a, b) => a == b,
      );
      differ.update(newList: ['a', 'c'], buildRemovedItem: dummyBuilder);
      differ.update(
          newList: ['a', 'c', 'd'], buildRemovedItem: dummyBuilder);
      differ.update(newList: ['d'], buildRemovedItem: dummyBuilder);
      expect(differ.items, ['d']);
    });
  });
}
