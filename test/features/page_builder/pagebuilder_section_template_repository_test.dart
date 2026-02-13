import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late MockPagebuilderSectionTemplateRepository mockRepo;

  setUp(() {
    mockRepo = MockPagebuilderSectionTemplateRepository();
  });

  group("PagebuilderSectionTemplateRepository_GetAllTemplateMetas", () {
    final testMetas = [
      const PagebuilderSectionTemplateMeta(
        id: "template-1",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/hero.webp",
      ),
      const PagebuilderSectionTemplateMeta(
        id: "template-2",
        type: SectionType.about,
        thumbnailUrl: "https://example.com/about.webp",
      ),
      const PagebuilderSectionTemplateMeta(
        id: "template-3",
        type: SectionType.product,
        thumbnailUrl: "https://example.com/product.webp",
      ),
    ];

    test("should return list of template metas when call was successful",
        () async {
      // Given
      final expectedResult = right(testMetas);
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => right(testMetas));
      // When
      final result = await mockRepo.getAllTemplateMetas();
      // Then
      verify(mockRepo.getAllTemplateMetas());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return empty list when no templates exist", () async {
      // Given
      final emptyList = <PagebuilderSectionTemplateMeta>[];
      final expectedResult = right(emptyList);
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => right(emptyList));
      // When
      final result = await mockRepo.getAllTemplateMetas();
      // Then
      verify(mockRepo.getAllTemplateMetas());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return failure when backend error occurs", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRepo.getAllTemplateMetas();
      // Then
      verify(mockRepo.getAllTemplateMetas());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });
  });

  group("PagebuilderSectionTemplateRepository_GetTemplateById", () {
    final testTemplate = PagebuilderSectionTemplate(
      meta: const PagebuilderSectionTemplateMeta(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/hero.webp",
      ),
      section: PageBuilderSection(
        id: UniqueID.fromUniqueString("section-123"),
        name: "Hero Section",
        widgets: [],
        background: null,
        maxWidth: 1200,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        visibleOn: null,
      ),
    );
    const testId = "template-123";

    test("should return template when call was successful", () async {
      // Given
      final expectedResult = right(testTemplate);
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => right(testTemplate));
      // When
      final result = await mockRepo.getTemplateById(testId);
      // Then
      verify(mockRepo.getTemplateById(testId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return not found failure when template does not exist",
        () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => left(NotFoundFailure()));
      // When
      final result = await mockRepo.getTemplateById(testId);
      // Then
      verify(mockRepo.getTemplateById(testId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should return failure when backend error occurs", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockRepo.getTemplateById(testId);
      // Then
      verify(mockRepo.getTemplateById(testId));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockRepo);
    });

    test("should handle different template types correctly", () async {
      // Given
      final templates = [
        SectionType.hero,
        SectionType.about,
        SectionType.product,
        SectionType.callToAction,
        SectionType.advantages,
        SectionType.footer,
      ];

      for (var type in templates) {
        final template = PagebuilderSectionTemplate(
          meta: PagebuilderSectionTemplateMeta(
            id: "template-${type.name}",
            type: type,
            thumbnailUrl: "https://example.com/${type.name}.webp",
          ),
          section: PageBuilderSection(
            id: UniqueID.fromUniqueString("section-${type.name}"),
            name: "${type.name} Section",
            widgets: [],
            background: null,
            maxWidth: 1200,
            backgroundConstrained: null,
            customCSS: null,
            fullHeight: null,
            visibleOn: null,
          ),
        );

        when(mockRepo.getTemplateById("template-${type.name}"))
            .thenAnswer((_) async => right(template));

        // When
        final result = await mockRepo.getTemplateById("template-${type.name}");

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail("Should not return failure"),
          (returnedTemplate) {
            expect(returnedTemplate.meta.type, type);
            expect(returnedTemplate.meta.id, "template-${type.name}");
          },
        );
      }

      verify(mockRepo.getTemplateById(any)).called(templates.length);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
