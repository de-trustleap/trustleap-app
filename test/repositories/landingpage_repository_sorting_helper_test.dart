import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/infrastructure/repositories/landing_page_repository_sorting_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LandingPageRepositoryImplementation_sortLandingPages", () {
    final sorter = LandingPageRepositorySortingHelper();
    test("isDefaultPage should be first", () {
      // Given
      final pages = [
        LandingPage(
            id: UniqueID.fromUniqueString("2"),
            createdAt: DateTime(2024, 02, 10)),
        LandingPage(id: UniqueID.fromUniqueString("1"), isDefaultPage: true),
        LandingPage(
            id: UniqueID.fromUniqueString("3"),
            createdAt: DateTime(2024, 02, 11)),
      ];

      // When
      final sorted = sorter.sortLandingPages(pages);

      // Then
      expect(sorted.first.isDefaultPage, true);
    });

    test("isActive = true should come before isActive = false", () {
      // Given
      final pages = [
        LandingPage(id: UniqueID.fromUniqueString("1"), isActive: false),
        LandingPage(id: UniqueID.fromUniqueString("2"), isActive: true),
        LandingPage(id: UniqueID.fromUniqueString("3"), isActive: false),
      ];

      // When
      final sorted = sorter.sortLandingPages(pages);

      // Then
      expect(sorted[0].isActive, true);
      expect(sorted[1].isActive, false);
    });

    test("lastUpdatedAt should be used if available, otherwise createdAt", () {
      // Given
      final pages = [
        LandingPage(
          id: UniqueID.fromUniqueString("1"),
          createdAt: DateTime(2024, 02, 01),
          lastUpdatedAt: DateTime(2024, 02, 05),
        ),
        LandingPage(
          id: UniqueID.fromUniqueString("2"),
          createdAt: DateTime(2024, 02, 10),
        ),
      ];

      // When
      final sorted = sorter.sortLandingPages(pages);

      // Then
      expect(sorted.first.id.value, "2");
    });

    test("all properties should be sorted", () {
      // Given
      final pages = [
        LandingPage(
            id: UniqueID.fromUniqueString("1"),
            createdAt: DateTime(2024, 02, 01),
            lastUpdatedAt: DateTime(2024, 02, 05),
            isActive: true),
        LandingPage(
          id: UniqueID.fromUniqueString("2"),
          createdAt: DateTime(2024, 02, 10),
        ),
        LandingPage(
            id: UniqueID.fromUniqueString("3"),
            createdAt: DateTime(2024, 02, 11),
            isActive: true),
        LandingPage(
            id: UniqueID.fromUniqueString("4"),
            isDefaultPage: true,
            createdAt: DateTime(2024, 02, 10),
            isActive: true),
      ];

      final expectedResult = [
        LandingPage(
            id: UniqueID.fromUniqueString("4"),
            isDefaultPage: true,
            createdAt: DateTime(2024, 02, 10),
            isActive: true),
        LandingPage(
            id: UniqueID.fromUniqueString("3"),
            createdAt: DateTime(2024, 02, 11),
            isActive: true),
        LandingPage(
            id: UniqueID.fromUniqueString("1"),
            createdAt: DateTime(2024, 02, 01),
            lastUpdatedAt: DateTime(2024, 02, 05),
            isActive: true),
        LandingPage(
          id: UniqueID.fromUniqueString("2"),
          createdAt: DateTime(2024, 02, 10),
        ),
      ];

      // When
      final sorted = sorter.sortLandingPages(pages);

      // Then
      expect(sorted, expectedResult);
    });
  });
}
