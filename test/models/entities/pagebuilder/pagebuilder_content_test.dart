import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContent_CopyWith", () {
    test(
        "set content with copyWith should set width and content for resulting object",
        () {
      // Given
      final model = PagebuilderContent(
          landingPage: LandingPage(id: UniqueID.fromUniqueString("1")),
          content: PageBuilderPage(
              id: UniqueID.fromUniqueString("1"),
              sections: [
                PageBuilderSection(
                    id: UniqueID.fromUniqueString("2"),
                    layout: PageBuilderSectionLayout.column,
                    widgets: [],
                    background: null,
                    maxWidth: 300)
              ],
              backgroundColor: Colors.red),
          user: CustomUser(id: UniqueID.fromUniqueString("1")));
      final expectedResult = PagebuilderContent(
          landingPage: LandingPage(id: UniqueID.fromUniqueString("1")),
          content: PageBuilderPage(
              id: UniqueID.fromUniqueString("1"),
              sections: [
                PageBuilderSection(
                    id: UniqueID.fromUniqueString("2"),
                    layout: PageBuilderSectionLayout.column,
                    widgets: [],
                    background: null,
                    maxWidth: 500)
              ],
              backgroundColor: Colors.red),
          user: CustomUser(id: UniqueID.fromUniqueString("1")));
      // When
      final result = model.copyWith(
        content: PageBuilderPage(
            id: UniqueID.fromUniqueString("1"),
            sections: [
              PageBuilderSection(
                  id: UniqueID.fromUniqueString("2"),
                  layout: PageBuilderSectionLayout.column,
                  widgets: [],
                  background: null,
                  maxWidth: 500)
            ],
            backgroundColor: Colors.red),
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderContent_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderContent(
          landingPage: LandingPage(id: UniqueID.fromUniqueString("1")),
          content: PageBuilderPage(
              id: UniqueID.fromUniqueString("1"),
              sections: [
                PageBuilderSection(
                    id: UniqueID.fromUniqueString("2"),
                    layout: PageBuilderSectionLayout.column,
                    widgets: [],
                    background: null,
                    maxWidth: 300)
              ],
              backgroundColor: Colors.red),
          user: CustomUser(id: UniqueID.fromUniqueString("1")));
      final properties2 = PagebuilderContent(
          landingPage: LandingPage(id: UniqueID.fromUniqueString("1")),
          content: PageBuilderPage(
              id: UniqueID.fromUniqueString("1"),
              sections: [
                PageBuilderSection(
                    id: UniqueID.fromUniqueString("2"),
                    layout: PageBuilderSectionLayout.column,
                    widgets: [],
                    background: null,
                    maxWidth: 300)
              ],
              backgroundColor: Colors.red),
          user: CustomUser(id: UniqueID.fromUniqueString("1")));
      // Then
      expect(properties1, properties2);
    });
  });
}
