import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_page_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';

void main() {
  group("PagebuilderPageModel_CopyWith", () {
    test(
        "set backgroundColor with copyWith should set backgroundColor for resulting object",
        () {
      // Given
      final page = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FF35A55");
      final expectedResult = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFFFFFFF");
      // When
      final result = page.copyWith(backgroundColor: "FFFFFFFF");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFFFFFFF");
      final expectedResult = {
        "id": "1",
        "sections": [],
        "backgroundColor": "FFFFFFFF"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"id": "1", "sections": [], "backgroundColor": "FFFFFFFF"};
      final expectedResult = PageBuilderPageModel(
          id: "", sections: [], backgroundColor: "FFFFFFFF");
      // When
      final result = PageBuilderPageModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderPageModel to PagebuilderPage works",
        () {
      // Given
      final model = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFFFFFFF");
      final expectedResult = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [],
          backgroundColor: Color(0xFFFFFFFF));
      // When
      final result = model.toDomain();
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderPage to PagebuilderPageModel works",
        () {
      // Given
      final model = PageBuilderPage(
          id: UniqueID.fromUniqueString("1"),
          sections: [],
          backgroundColor: Color(0xFFFFFFFF));
      final expectedResult = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFFFFFFF");
      // When
      final result = PageBuilderPageModel.fromDomain(model);
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_GetPageBuilderSectionList", () {
    test("check if returns correct PageBuilderSections from map list", () {
      // Given
      final sections = [
        {
          "id": "23af1357-fe6f-4fbd-bc38-f8d2561c92b9",
          "name": "Test Section 1",
          "layout": "column",
          "widgets": []
        },
        {
          "id": "bc3dc5e1-f43a-415c-9664-3692f3075d1c",
          "name": "Test Section 2",
          "layout": "column",
          "widgets": []
        },
      ];
      final model = PageBuilderPageModel(
          id: "1", sections: sections, backgroundColor: "FFFFFFFF");
      final expectedResult = [
        PageBuilderSection(
            id: UniqueID.fromUniqueString(
                "23af1357-fe6f-4fbd-bc38-f8d2561c92b9"),
            name: "Test Section 1",
            layout: PageBuilderSectionLayout.column,
            widgets: [],
            background: null,
            maxWidth: null, backgroundConstrained: null,
            customCSS: null,
            visibleOn: null),
        PageBuilderSection(
            id: UniqueID.fromUniqueString(
                "bc3dc5e1-f43a-415c-9664-3692f3075d1c"),
            name: "Test Section 2",
            layout: PageBuilderSectionLayout.column,
            widgets: [],
            background: null,
            maxWidth: null, backgroundConstrained: null,
            customCSS: null,
            visibleOn: null)
      ];
      // When
      final result = model.getPageBuilderSectionList(sections);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_GetMapFromPageBuilderSectionList", () {
    test("check if returns correct map list from PageBuilderSections", () {
      // Given
      final sections = [
        PageBuilderSection(
            id: UniqueID.fromUniqueString(
                "23af1357-fe6f-4fbd-bc38-f8d2561c92b9"),
            name: "Test Section 1",
            layout: PageBuilderSectionLayout.column,
            widgets: [],
            background: null,
            maxWidth: 500,
            backgroundConstrained: null,
            customCSS: null,
            visibleOn: null),
        PageBuilderSection(
            id: UniqueID.fromUniqueString(
                "bc3dc5e1-f43a-415c-9664-3692f3075d1c"),
            name: "Test Section 2",
            layout: PageBuilderSectionLayout.column,
            widgets: [],
            background: null,
            maxWidth: 400,
            backgroundConstrained: null,
            customCSS: null,
            visibleOn: null)
      ];
      final expectedResult = [
        {
          "id": "23af1357-fe6f-4fbd-bc38-f8d2561c92b9",
          "name": "Test Section 1",
          "layout": "column",
          "widgets": [],
          "maxWidth": 500.0
        },
        {
          "id": "bc3dc5e1-f43a-415c-9664-3692f3075d1c",
          "name": "Test Section 2",
          "layout": "column",
          "widgets": [],
          "maxWidth": 400.0
        }
      ];
      // When
      final result =
          PageBuilderPageModel.getMapFromPageBuilderSectionList(sections);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderPageModel_Props", () {
    test("check if value equality works", () {
      // Given
      final page1 = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFF0F0F0");
      final page2 = PageBuilderPageModel(
          id: "1", sections: [], backgroundColor: "FFF0F0F0");
      // Then
      expect(page1, page2);
    });
  });
}
