import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_template_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_template_meta_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_section_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';

void main() {
  group("PagebuilderSectionTemplateModel_FromFirestore", () {
    test("check if Firestore map is successfully converted to model", () {
      // Given
      final map = {
        "type": "hero",
        "thumbnailUrl": "https://example.com/thumbnail.webp",
        "section": {
          "id": "section-123",
          "name": "Hero Section",
          "maxWidth": 1200.0,
          "widgets": []
        }
      };
      final id = "template-123";
      final expectedMeta = const PagebuilderSectionTemplateMetaModel(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final expectedSection = PageBuilderSectionModel(
        id: "section-123",
        name: "Hero Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final expectedResult = PagebuilderSectionTemplateModel(
        meta: expectedMeta,
        section: expectedSection,
      );
      // When
      final result =
          PagebuilderSectionTemplateModel.fromFirestore(map, id);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionTemplateModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderSectionTemplateModel to PagebuilderSectionTemplate works",
        () {
      // Given
      final metaModel = const PagebuilderSectionTemplateMetaModel(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final sectionModel = PageBuilderSectionModel(
        id: "section-123",
        name: "Hero Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final model = PagebuilderSectionTemplateModel(
        meta: metaModel,
        section: sectionModel,
      );
      final expectedMeta = const PagebuilderSectionTemplateMeta(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final expectedSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section-123"),
        name: "Hero Section",
        widgets: [],
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        visibleOn: null,
      );
      final expectedResult = PagebuilderSectionTemplate(
        meta: expectedMeta,
        section: expectedSection,
      );
      // When
      final result = model.toDomain(null);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionTemplateModel_Props", () {
    test("check if value equality works", () {
      // Given
      final meta = const PagebuilderSectionTemplateMetaModel(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final section = PageBuilderSectionModel(
        id: "section-123",
        name: "Hero Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final template1 = PagebuilderSectionTemplateModel(
        meta: meta,
        section: section,
      );
      final template2 = PagebuilderSectionTemplateModel(
        meta: meta,
        section: section,
      );
      // Then
      expect(template1, template2);
    });

    test("check if value inequality works with different meta", () {
      // Given
      final meta1 = const PagebuilderSectionTemplateMetaModel(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final meta2 = const PagebuilderSectionTemplateMetaModel(
        id: "template-456",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final section = PageBuilderSectionModel(
        id: "section-123",
        name: "Hero Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final template1 = PagebuilderSectionTemplateModel(
        meta: meta1,
        section: section,
      );
      final template2 = PagebuilderSectionTemplateModel(
        meta: meta2,
        section: section,
      );
      // Then
      expect(template1 == template2, false);
    });

    test("check if value inequality works with different section", () {
      // Given
      final meta = const PagebuilderSectionTemplateMetaModel(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final section1 = PageBuilderSectionModel(
        id: "section-123",
        name: "Hero Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final section2 = PageBuilderSectionModel(
        id: "section-456",
        name: "About Section",
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [],
        visibleOn: null,
      );
      final template1 = PagebuilderSectionTemplateModel(
        meta: meta,
        section: section1,
      );
      final template2 = PagebuilderSectionTemplateModel(
        meta: meta,
        section: section2,
      );
      // Then
      expect(template1 == template2, false);
    });
  });
}
