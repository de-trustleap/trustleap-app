import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  group("PagebuilderPage_CopyWith", () {
    test(
        "set sections and color with copyWith should set sections and color for resulting object",
        () {
      // Given
      final page = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [
            PageBuilderSection(
                id: UniqueID.fromUniqueString("2"),
                name: "Test Section",
                widgets: [],
                background: null,
                maxWidth: 300,
                backgroundConstrained: null,
            customCSS: null,
            fullHeight: null,
                visibleOn: null)
          ],
          backgroundColor: Colors.red,
          globalStyles: null);
      final expectedResult = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [],
          backgroundColor: Colors.green,
          globalStyles: null);
      // When
      final result = page.copyWith(sections: [], backgroundColor: Colors.green);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPage_Props", () {
    test("check if value equality works", () {
      // Given
      final page1 = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [
            PageBuilderSection(
                id: UniqueID.fromUniqueString("2"),
                name: "Test Section",
                widgets: [],
                background: null,
                maxWidth: 300,
                backgroundConstrained: null,
            customCSS: null,
            fullHeight: null,
                visibleOn: null)
          ],
          backgroundColor: Colors.red,
          globalStyles: null);

      final page2 = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [
            PageBuilderSection(
                id: UniqueID.fromUniqueString("2"),
                name: "Test Section",
                widgets: [],
                background: null,
                maxWidth: 300,
                backgroundConstrained: null,
            customCSS: null,
            fullHeight: null,
                visibleOn: null)
          ],
          backgroundColor: Colors.red,
          globalStyles: null);
      // Then
      expect(page1, page2);
    });
  });
}
