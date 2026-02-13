import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_drag/pagebuilder_drag_cubit.dart';

void main() {
  group("PagebuilderDragCubit", () {
    late PagebuilderDragCubit cubit;

    setUp(() {
      cubit = PagebuilderDragCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test("initial state should be false", () {
      expect(cubit.state.isDragging, false);
    });

    test("initial activeContainerId should be null", () {
      expect(cubit.state.activeContainerId, null);
    });

    test("initial activeContainerKey should be null", () {
      expect(cubit.state.activeContainerKey, null);
    });

    test("setDragging(true) should emit true and set containerId and containerKey", () {
      final testContainerId = "test-container-id";
      final testContainerKey = GlobalKey();

      cubit.setDragging(true, containerId: testContainerId, containerKey: testContainerKey);

      expect(cubit.state.isDragging, true);
      expect(cubit.state.activeContainerId, testContainerId);
      expect(cubit.state.activeContainerKey, testContainerKey);
    });

    test("setDragging(false) should emit false and clear containerId and containerKey", () {
      final testContainerId = "test-container-id";
      final testContainerKey = GlobalKey();

      // First set dragging to true
      cubit.setDragging(true, containerId: testContainerId, containerKey: testContainerKey);

      // Then set to false
      cubit.setDragging(false);

      expect(cubit.state.isDragging, false);
      expect(cubit.state.activeContainerId, null);
      expect(cubit.state.activeContainerKey, null);
    });

    test("setDragging should only emit when state changes", () {
      expectLater(
        cubit.stream.map((state) => state.isDragging),
        emitsInOrder([true, false]),
      );

      cubit.setDragging(true, containerId: "test-id");
      cubit.setDragging(true, containerId: "test-id"); // Should not emit again
      cubit.setDragging(false);
      cubit.setDragging(false); // Should not emit again
    });

    test("setDragging(true) without containerId should still set state", () {
      cubit.setDragging(true);

      expect(cubit.state.isDragging, true);
      expect(cubit.state.activeContainerId, null);
      expect(cubit.state.activeContainerKey, null);
    });

    test("setDragging(true) with only containerId should work", () {
      final testContainerId = "test-container-id";

      cubit.setDragging(true, containerId: testContainerId);

      expect(cubit.state.isDragging, true);
      expect(cubit.state.activeContainerId, testContainerId);
      expect(cubit.state.activeContainerKey, null);
    });

    test("setDragging(true) with only containerKey should work", () {
      final testContainerKey = GlobalKey();

      cubit.setDragging(true, containerKey: testContainerKey);

      expect(cubit.state.isDragging, true);
      expect(cubit.state.activeContainerId, null);
      expect(cubit.state.activeContainerKey, testContainerKey);
    });

    test("multiple setDragging(true) calls should update containerId and containerKey", () {
      final firstContainerId = "first-container";
      final firstContainerKey = GlobalKey();
      final secondContainerId = "second-container";
      final secondContainerKey = GlobalKey();

      cubit.setDragging(true, containerId: firstContainerId, containerKey: firstContainerKey);
      expect(cubit.state.activeContainerId, firstContainerId);
      expect(cubit.state.activeContainerKey, firstContainerKey);

      cubit.setDragging(true, containerId: secondContainerId, containerKey: secondContainerKey);
      expect(cubit.state.activeContainerId, secondContainerId);
      expect(cubit.state.activeContainerKey, secondContainerKey);
    });

    test("initial libraryDragTargetContainerId should be null", () {
      expect(cubit.state.libraryDragTargetContainerId, null);
    });

    test("initial libraryDragTargetContainerKey should be null", () {
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });

    test("setLibraryDragTarget should set containerId and containerKey", () {
      final testContainerId = "test-library-target-id";
      final testContainerKey = GlobalKey();

      cubit.setLibraryDragTarget(containerId: testContainerId, containerKey: testContainerKey);

      expect(cubit.state.libraryDragTargetContainerId, testContainerId);
      expect(cubit.state.libraryDragTargetContainerKey, testContainerKey);
    });

    test("clearLibraryDragTarget should clear containerId and containerKey", () {
      final testContainerId = "test-library-target-id";
      final testContainerKey = GlobalKey();

      cubit.setLibraryDragTarget(containerId: testContainerId, containerKey: testContainerKey);
      cubit.clearLibraryDragTarget();

      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });

    test("setDragging(false) should clear library drag target", () {
      final testContainerId = "test-container-id";
      final testContainerKey = GlobalKey();
      final testLibraryTargetId = "test-library-target-id";
      final testLibraryTargetKey = GlobalKey();

      cubit.setDragging(true, containerId: testContainerId, containerKey: testContainerKey);
      cubit.setLibraryDragTarget(containerId: testLibraryTargetId, containerKey: testLibraryTargetKey);

      expect(cubit.state.libraryDragTargetContainerId, testLibraryTargetId);
      expect(cubit.state.libraryDragTargetContainerKey, testLibraryTargetKey);

      cubit.setDragging(false);

      expect(cubit.state.isDragging, false);
      expect(cubit.state.activeContainerId, null);
      expect(cubit.state.activeContainerKey, null);
      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });

    test("setLibraryDragTarget with only containerId should work", () {
      final testContainerId = "test-library-target-id";

      cubit.setLibraryDragTarget(containerId: testContainerId);

      expect(cubit.state.libraryDragTargetContainerId, testContainerId);
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });

    test("setLibraryDragTarget with only containerKey should work", () {
      final testContainerKey = GlobalKey();

      cubit.setLibraryDragTarget(containerKey: testContainerKey);

      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, testContainerKey);
    });

    test("setLibraryDragTarget should work without affecting drag state", () {
      expect(cubit.state.isDragging, false);

      cubit.setLibraryDragTarget(containerId: "test-id");

      expect(cubit.state.isDragging, false);
      expect(cubit.state.libraryDragTargetContainerId, "test-id");
    });

    test("clearLibraryDragTarget should work without affecting drag state", () {
      cubit.setLibraryDragTarget(containerId: "test-id");
      expect(cubit.state.isDragging, false);
      expect(cubit.state.libraryDragTargetContainerId, "test-id");

      cubit.clearLibraryDragTarget();

      expect(cubit.state.isDragging, false);
      expect(cubit.state.libraryDragTargetContainerId, null);
    });

    test("multiple setLibraryDragTarget calls should update containerId and containerKey", () {
      final firstContainerId = "first-target";
      final firstContainerKey = GlobalKey();
      final secondContainerId = "second-target";
      final secondContainerKey = GlobalKey();

      cubit.setLibraryDragTarget(containerId: firstContainerId, containerKey: firstContainerKey);
      expect(cubit.state.libraryDragTargetContainerId, firstContainerId);
      expect(cubit.state.libraryDragTargetContainerKey, firstContainerKey);

      cubit.setLibraryDragTarget(containerId: secondContainerId, containerKey: secondContainerKey);
      expect(cubit.state.libraryDragTargetContainerId, secondContainerId);
      expect(cubit.state.libraryDragTargetContainerKey, secondContainerKey);
    });

    test("setDragging(true) should not clear library drag target", () {
      final testLibraryTargetId = "test-library-target-id";
      final testLibraryTargetKey = GlobalKey();

      cubit.setLibraryDragTarget(containerId: testLibraryTargetId, containerKey: testLibraryTargetKey);
      cubit.setDragging(true, containerId: "test-container-id");

      expect(cubit.state.isDragging, true);
      expect(cubit.state.libraryDragTargetContainerId, testLibraryTargetId);
      expect(cubit.state.libraryDragTargetContainerKey, testLibraryTargetKey);
    });

    test("setDragging(true) without parameters should not clear library drag target", () {
      final testLibraryTargetId = "test-library-target-id";

      cubit.setLibraryDragTarget(containerId: testLibraryTargetId);
      cubit.setDragging(true);

      expect(cubit.state.isDragging, true);
      expect(cubit.state.libraryDragTargetContainerId, testLibraryTargetId);
    });

    test("setLibraryDragTarget can be called without setDragging", () {
      final testContainerId = "test-library-target-id";
      final testContainerKey = GlobalKey();

      cubit.setLibraryDragTarget(containerId: testContainerId, containerKey: testContainerKey);

      expect(cubit.state.isDragging, false);
      expect(cubit.state.libraryDragTargetContainerId, testContainerId);
      expect(cubit.state.libraryDragTargetContainerKey, testContainerKey);
    });

    test("clearLibraryDragTarget can be called when library drag target is not set", () {
      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, null);

      cubit.clearLibraryDragTarget();

      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });

    test("setDragging(false) when library drag target is not set should work", () {
      cubit.setDragging(true, containerId: "test-id");
      cubit.setDragging(false);

      expect(cubit.state.isDragging, false);
      expect(cubit.state.activeContainerId, null);
      expect(cubit.state.activeContainerKey, null);
      expect(cubit.state.libraryDragTargetContainerId, null);
      expect(cubit.state.libraryDragTargetContainerKey, null);
    });
  });
}
