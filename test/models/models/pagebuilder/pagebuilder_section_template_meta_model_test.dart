import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_template_meta_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';

void main() {
  group("PagebuilderSectionTemplateMetaModel_FromFirestore", () {
    test("check if Firestore map is successfully converted to model", () {
      // Given
      final map = {
        "type": "hero",
        "thumbnailUrl":
            "https://example.com/thumbnail.webp"
      };
      final id = "test-template-id";
      final expectedResult = const PagebuilderSectionTemplateMetaModel(
        id: "test-template-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      // When
      final result = PagebuilderSectionTemplateMetaModel.fromFirestore(map, id);
      // Then
      expect(result, expectedResult);
    });

    test("should default to hero type when type not found", () {
      // Given
      final map = {
        "type": "unknown_type",
        "thumbnailUrl": "https://example.com/thumbnail.webp"
      };
      final id = "test-template-id";
      // When
      final result = PagebuilderSectionTemplateMetaModel.fromFirestore(map, id);
      // Then
      expect(result.type, SectionType.hero);
    });

    test("should handle all SectionType values correctly", () {
      // Given
      final testCases = [
        {"type": "hero", "expected": SectionType.hero},
        {"type": "about", "expected": SectionType.about},
        {"type": "product", "expected": SectionType.product},
        {"type": "callToAction", "expected": SectionType.callToAction},
        {"type": "advantages", "expected": SectionType.advantages},
        {"type": "footer", "expected": SectionType.footer},
      ];

      for (var testCase in testCases) {
        final map = {
          "type": testCase["type"] as String,
          "thumbnailUrl": "https://example.com/thumbnail.webp"
        };
        final id = "test-id";
        // When
        final result =
            PagebuilderSectionTemplateMetaModel.fromFirestore(map, id);
        // Then
        expect(result.type, testCase["expected"]);
      }
    });
  });

  group("PagebuilderSectionTemplateMetaModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderSectionTemplateMetaModel to PagebuilderSectionTemplateMeta works",
        () {
      // Given
      final model = const PagebuilderSectionTemplateMetaModel(
        id: "test-template-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final expectedResult = const PagebuilderSectionTemplateMeta(
        id: "test-template-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderSectionTemplateMetaModel_Props", () {
    test("check if value equality works", () {
      // Given
      final meta1 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final meta2 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      // Then
      expect(meta1, meta2);
    });

    test("check if value inequality works with different id", () {
      // Given
      final meta1 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id-1",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final meta2 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id-2",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      // Then
      expect(meta1 == meta2, false);
    });

    test("check if value inequality works with different type", () {
      // Given
      final meta1 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      final meta2 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.about,
        thumbnailUrl: "https://example.com/thumbnail.webp",
      );
      // Then
      expect(meta1 == meta2, false);
    });

    test("check if value inequality works with different thumbnailUrl", () {
      // Given
      final meta1 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail1.webp",
      );
      final meta2 = const PagebuilderSectionTemplateMetaModel(
        id: "test-id",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/thumbnail2.webp",
      );
      // Then
      expect(meta1 == meta2, false);
    });
  });
}
