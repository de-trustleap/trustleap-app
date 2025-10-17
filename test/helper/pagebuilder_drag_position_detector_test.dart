import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_drag_position_detector.dart';

void main() {
  group("PagebuilderDragPositionDetector.detectPosition", () {
    const size = Size(100, 100);

    test("detects top edge as above (Row layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(50, 5),
        size: size,
        isLastItem: false,
        isInRow: true,
      );
      expect(position, equals(DropPosition.above));
    });

    test("detects bottom edge as below (Row layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(50, 95),
        size: size,
        isLastItem: false,
        isInRow: true,
      );
      expect(position, equals(DropPosition.below));
    });

    test("detects left edge as before (Row layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(5, 50),
        size: size,
        isLastItem: false,
        isInRow: true,
      );
      expect(position, equals(DropPosition.before));
    });

    test("detects right edge as after (Row layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(95, 50),
        size: size,
        isLastItem: false,
        isInRow: true,
      );
      expect(position, equals(DropPosition.after));
    });

    test("detects top edge as above (Column layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(50, 5),
        size: size,
        isLastItem: false,
        isInRow: false,
      );
      expect(position, equals(DropPosition.above));
    });

    test("detects left edge as before (Column layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(5, 50),
        size: size,
        isLastItem: false,
        isInRow: false,
      );
      expect(position, equals(DropPosition.before));
    });

    test("detects right edge as after (Column layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(95, 50),
        size: size,
        isLastItem: false,
        isInRow: false,
      );
      expect(position, equals(DropPosition.after));
    });

    test("detects bottom edge as below only if last item (Column layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(50, 95),
        size: size,
        isLastItem: true,
        isInRow: false,
      );
      expect(position, equals(DropPosition.below));
    });

    test("defaults to above if no edge is near (Column layout)", () {
      final position = PagebuilderDragPositionDetector.detectPosition(
        localPosition: const Offset(50, 50),
        size: size,
        isLastItem: false,
        isInRow: false,
      );
      expect(position, equals(DropPosition.above));
    });
  });

  group("PagebuilderDragPositionDetector.detectPositionFromRenderBox", () {
    testWidgets("returns null if RenderBox is null", (tester) async {
      final key = GlobalKey();
      final position =
          PagebuilderDragPositionDetector.detectPositionFromRenderBox(
        itemKey: key,
        globalOffset: Offset.zero,
        isLastItem: false,
        isInRow: false,
      );
      expect(position, isNull);
    });

    testWidgets("converts globalOffset and detects position correctly",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final globalCenter = renderBox.localToGlobal(const Offset(50, 5));

      final position =
          PagebuilderDragPositionDetector.detectPositionFromRenderBox(
        itemKey: key,
        globalOffset: globalCenter,
        isLastItem: false,
        isInRow: false,
      );

      expect(position, equals(DropPosition.above));
    });
  });

  group("PagebuilderDragPositionDetector.isInCenterArea", () {
    testWidgets("returns true when cursor is in center area", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at center (50, 50)
      final globalCenter = renderBox.localToGlobal(const Offset(50, 50));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalCenter,
      );

      expect(isInCenter, isTrue);
    });

    testWidgets("returns false when cursor is near left edge", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at left edge (10, 50) - within 15% threshold
      final globalLeft = renderBox.localToGlobal(const Offset(10, 50));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalLeft,
      );

      expect(isInCenter, isFalse);
    });

    testWidgets("returns false when cursor is near right edge", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at right edge (90, 50) - within 15% threshold from right
      final globalRight = renderBox.localToGlobal(const Offset(90, 50));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalRight,
      );

      expect(isInCenter, isFalse);
    });

    testWidgets("returns false when cursor is near top edge", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at top edge (50, 10) - within 15% threshold
      final globalTop = renderBox.localToGlobal(const Offset(50, 10));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalTop,
      );

      expect(isInCenter, isFalse);
    });

    testWidgets("returns false when cursor is near bottom edge", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at bottom edge (50, 90) - within 15% threshold from bottom
      final globalBottom = renderBox.localToGlobal(const Offset(50, 90));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalBottom,
      );

      expect(isInCenter, isFalse);
    });

    testWidgets("returns true when cursor is just inside threshold", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position just inside threshold (16, 16) - 15% of 100 is 15, so 16 is just inside
      final globalInsideThreshold = renderBox.localToGlobal(const Offset(16, 16));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalInsideThreshold,
      );

      expect(isInCenter, isTrue);
    });

    testWidgets("returns false when cursor is just outside threshold", (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position just outside threshold (14, 50) - 15% of 100 is 15, so 14 is outside
      final globalOutsideThreshold = renderBox.localToGlobal(const Offset(14, 50));

      final isInCenter = PagebuilderDragPositionDetector.isInCenterArea(
        renderBox: renderBox,
        globalOffset: globalOutsideThreshold,
      );

      expect(isInCenter, isFalse);
    });
  });

  group("PagebuilderDragPositionDetector.adjustPositionForContainer", () {
    testWidgets("returns 'inside' when target is container and cursor is in center",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final globalCenter = renderBox.localToGlobal(const Offset(50, 50));

      final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
        detectedPosition: DropPosition.above,
        targetIsContainer: true,
        itemKey: key,
        globalOffset: globalCenter,
      );

      expect(finalPosition, equals(DropPosition.inside));
    });

    testWidgets("returns original position when target is container but cursor is near edge",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      // Position at top edge
      final globalTop = renderBox.localToGlobal(const Offset(50, 10));

      final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
        detectedPosition: DropPosition.above,
        targetIsContainer: true,
        itemKey: key,
        globalOffset: globalTop,
      );

      expect(finalPosition, equals(DropPosition.above));
    });

    testWidgets("returns original position when target is NOT a container",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final globalCenter = renderBox.localToGlobal(const Offset(50, 50));

      final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
        detectedPosition: DropPosition.above,
        targetIsContainer: false,
        itemKey: key,
        globalOffset: globalCenter,
      );

      expect(finalPosition, equals(DropPosition.above));
    });

    testWidgets("returns original position when RenderBox is null",
        (tester) async {
      final key = GlobalKey();

      final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
        detectedPosition: DropPosition.below,
        targetIsContainer: true,
        itemKey: key,
        globalOffset: Offset.zero,
      );

      expect(finalPosition, equals(DropPosition.below));
    });

    testWidgets("handles all DropPosition types correctly for center area",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final globalCenter = renderBox.localToGlobal(const Offset(50, 50));

      // Test all possible detected positions
      final positions = [
        DropPosition.above,
        DropPosition.below,
        DropPosition.before,
        DropPosition.after,
      ];

      for (final detectedPosition in positions) {
        final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
          detectedPosition: detectedPosition,
          targetIsContainer: true,
          itemKey: key,
          globalOffset: globalCenter,
        );

        expect(finalPosition, equals(DropPosition.inside),
            reason: 'Expected "inside" for detected position $detectedPosition in center area');
      }
    });

    testWidgets("preserves 'inside' position if already detected as inside",
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: key,
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final globalCenter = renderBox.localToGlobal(const Offset(50, 50));

      final finalPosition = PagebuilderDragPositionDetector.adjustPositionForContainer(
        detectedPosition: DropPosition.inside,
        targetIsContainer: true,
        itemKey: key,
        globalOffset: globalCenter,
      );

      expect(finalPosition, equals(DropPosition.inside));
    });
  });
}
