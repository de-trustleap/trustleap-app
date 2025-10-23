import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';

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
      expect(cubit.state, false);
    });

    test("initial activeContainerId should be null", () {
      expect(cubit.activeContainerId, null);
    });

    test("initial activeContainerKey should be null", () {
      expect(cubit.activeContainerKey, null);
    });

    test("setDragging(true) should emit true and set containerId and containerKey", () {
      final testContainerId = "test-container-id";
      final testContainerKey = GlobalKey();

      cubit.setDragging(true, containerId: testContainerId, containerKey: testContainerKey);

      expect(cubit.state, true);
      expect(cubit.activeContainerId, testContainerId);
      expect(cubit.activeContainerKey, testContainerKey);
    });

    test("setDragging(false) should emit false and clear containerId and containerKey", () {
      final testContainerId = "test-container-id";
      final testContainerKey = GlobalKey();

      // First set dragging to true
      cubit.setDragging(true, containerId: testContainerId, containerKey: testContainerKey);

      // Then set to false
      cubit.setDragging(false);

      expect(cubit.state, false);
      expect(cubit.activeContainerId, null);
      expect(cubit.activeContainerKey, null);
    });

    test("setDragging should only emit when state changes", () {
      expectLater(
        cubit.stream,
        emitsInOrder([true, false]),
      );

      cubit.setDragging(true, containerId: "test-id");
      cubit.setDragging(true, containerId: "test-id"); // Should not emit again
      cubit.setDragging(false);
      cubit.setDragging(false); // Should not emit again
    });

    test("setDragging(true) without containerId should still set state", () {
      cubit.setDragging(true);

      expect(cubit.state, true);
      expect(cubit.activeContainerId, null);
      expect(cubit.activeContainerKey, null);
    });

    test("setDragging(true) with only containerId should work", () {
      final testContainerId = "test-container-id";

      cubit.setDragging(true, containerId: testContainerId);

      expect(cubit.state, true);
      expect(cubit.activeContainerId, testContainerId);
      expect(cubit.activeContainerKey, null);
    });

    test("setDragging(true) with only containerKey should work", () {
      final testContainerKey = GlobalKey();

      cubit.setDragging(true, containerKey: testContainerKey);

      expect(cubit.state, true);
      expect(cubit.activeContainerId, null);
      expect(cubit.activeContainerKey, testContainerKey);
    });

    test("multiple setDragging(true) calls should update containerId and containerKey", () {
      final firstContainerId = "first-container";
      final firstContainerKey = GlobalKey();
      final secondContainerId = "second-container";
      final secondContainerKey = GlobalKey();

      cubit.setDragging(true, containerId: firstContainerId, containerKey: firstContainerKey);
      expect(cubit.activeContainerId, firstContainerId);
      expect(cubit.activeContainerKey, firstContainerKey);

      cubit.setDragging(true, containerId: secondContainerId, containerKey: secondContainerKey);
      expect(cubit.activeContainerId, secondContainerId);
      expect(cubit.activeContainerKey, secondContainerKey);
    });
  });
}
