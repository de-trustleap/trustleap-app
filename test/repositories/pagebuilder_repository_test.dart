import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/constants.dart';

void main() {
  late MockPagebuilderRepository mockPageBuilderRepo;

  setUp(() {
    mockPageBuilderRepo = MockPagebuilderRepository();
  });

  group("PageBuilderRepositoryImplementation_getLandingPageContent", () {
    final testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("2"),
        sections: null,
        backgroundColor: null);
    final testID = "1";
    test("should return content when call was successful", () async {
      // Given
      final expectedResult = right(testPage);
      when(mockPageBuilderRepo.getLandingPageContent(testID))
          .thenAnswer((_) async => right(testPage));
      // When
      final result = await mockPageBuilderRepo.getLandingPageContent(testID);
      // Then
      verify(mockPageBuilderRepo.getLandingPageContent(testID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPageBuilderRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPageBuilderRepo.getLandingPageContent(testID))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPageBuilderRepo.getLandingPageContent(testID);
      // Then
      verify(mockPageBuilderRepo.getLandingPageContent(testID));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPageBuilderRepo);
    });
  });

  group("PageBuilderRepositoryImplementation_saveLandingPageContent", () {
    final testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("1"),
        sections: [
          PageBuilderSection(
              id: UniqueID.fromUniqueString("2"),
              name: "Test Section",
              layout: PageBuilderSectionLayout.column,
              background: null,
              maxWidth: null,
              backgroundConstrained: null,
              customCSS: null,
              widgets: [
                PageBuilderWidget(
                    id: UniqueID.fromUniqueString("3"),
                    elementType: PageBuilderWidgetType.text,
                    children: [],
                    widthPercentage: null,
                    background: null,
                    hoverBackground: null,
                    padding: null,
                    margin: null,
                    containerChild: null,
                    maxWidth: null,
                    alignment: null,
                    customCSS: null,
                    properties: PageBuilderTextProperties(
                        text: "Test",
                        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                        fontFamily: "TestFont",
                        color: Colors.black,
                        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
                        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
                        letterSpacing: const PagebuilderResponsiveOrConstant.constant(1.0),
                        textShadow: PageBuilderShadow(
                            color: Colors.black,
                            spreadRadius: 1.0,
                            blurRadius: 1.0,
                            offset: Offset(1, 1))),
                    hoverProperties: null)
              ],
              visibleOn: null)
        ],
        backgroundColor: null);
    test(
        "should return unit when content has been saved and call was successful",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockPageBuilderRepo.saveLandingPageContent(testPage))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockPageBuilderRepo.saveLandingPageContent(testPage);
      // Then
      verify(mockPageBuilderRepo.saveLandingPageContent(testPage));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPageBuilderRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPageBuilderRepo.saveLandingPageContent(testPage))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockPageBuilderRepo.saveLandingPageContent(testPage);
      // Then
      verify(mockPageBuilderRepo.saveLandingPageContent(testPage));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPageBuilderRepo);
    });
  });
}
