import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import '../../../mocks.mocks.dart';

void main() {
  late PagebuilderSectionTemplateCubit cubit;
  late MockPagebuilderSectionTemplateRepository mockRepo;

  setUp(() {
    mockRepo = MockPagebuilderSectionTemplateRepository();
    cubit = PagebuilderSectionTemplateCubit(mockRepo);
  });

  test("init state should be PagebuilderSectionTemplateInitial", () {
    expect(cubit.state, PagebuilderSectionTemplateInitial());
  });

  group("PagebuilderSectionTemplateCubit_GetAllTemplateMetas", () {
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
    ];

    test("should call repository if function is called", () async {
      // Given
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => right(testMetas));
      // When
      cubit.getAllTemplateMetas();
      await untilCalled(mockRepo.getAllTemplateMetas());
      // Then
      verify(mockRepo.getAllTemplateMetas());
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should emit PagebuilderSectionTemplateLoading and then PagebuilderSectionTemplateMetasLoadSuccess when function is called",
        () async {
      // Given
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateMetasLoadSuccess(metas: testMetas)
      ];
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => right(testMetas));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getAllTemplateMetas();
    });

    test(
        "should emit PagebuilderSectionTemplateLoading and then PagebuilderSectionTemplateFailure when function failed",
        () async {
      // Given
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateFailure(failure: BackendFailure())
      ];
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getAllTemplateMetas();
    });

    test("should handle empty list successfully", () async {
      // Given
      final emptyList = <PagebuilderSectionTemplateMeta>[];
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateMetasLoadSuccess(metas: emptyList)
      ];
      when(mockRepo.getAllTemplateMetas())
          .thenAnswer((_) async => right(emptyList));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getAllTemplateMetas();
    });
  });

  group("PagebuilderSectionTemplateCubit_GetTemplateById", () {
    final testTemplate = PagebuilderSectionTemplate(
      meta: const PagebuilderSectionTemplateMeta(
        id: "template-123",
        type: SectionType.hero,
        thumbnailUrl: "https://example.com/hero.webp",
      ),
      section: PageBuilderSection(
        id: UniqueID.fromUniqueString("section-123"),
        name: "Hero Section",
        layout: PageBuilderSectionLayout.column,
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

    test("should call repository if function is called", () async {
      // Given
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => right(testTemplate));
      // When
      cubit.getTemplateById(testId);
      await untilCalled(mockRepo.getTemplateById(testId));
      // Then
      verify(mockRepo.getTemplateById(testId));
      verifyNoMoreInteractions(mockRepo);
    });

    test(
        "should emit PagebuilderSectionTemplateLoading and then PagebuilderSectionTemplateFullLoadSuccess when function is called",
        () async {
      // Given
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateFullLoadSuccess(template: testTemplate)
      ];
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => right(testTemplate));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTemplateById(testId);
    });

    test(
        "should emit PagebuilderSectionTemplateLoading and then PagebuilderSectionTemplateFailure when function failed",
        () async {
      // Given
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateFailure(failure: NotFoundFailure())
      ];
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => left(NotFoundFailure()));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTemplateById(testId);
    });

    test(
        "should emit PagebuilderSectionTemplateFailure with BackendFailure when backend error occurs",
        () async {
      // Given
      final expectedResult = [
        PagebuilderSectionTemplateLoading(),
        PagebuilderSectionTemplateFailure(failure: BackendFailure())
      ];
      when(mockRepo.getTemplateById(testId))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTemplateById(testId);
    });
  });
}
