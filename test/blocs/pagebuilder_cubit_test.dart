import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_padding.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/foundation.dart';

void main() {
  late PagebuilderCubit pageBuilderCubit;
  late MockLandingPageRepository mockLandingPageRepo;
  late MockUserRepository mockUserRepo;
  late MockPagebuilderRepository mockPageBuilderRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    mockUserRepo = MockUserRepository();
    mockPageBuilderRepo = MockPagebuilderRepository();
    pageBuilderCubit = PagebuilderCubit(
        mockLandingPageRepo, mockPageBuilderRepo, mockUserRepo);
  });

  test("init state should be PagebuilderInitial", () {
    expect(pageBuilderCubit.state, PagebuilderInitial());
  });

  group("PagebuilderCubit_getLandingPage", () {
    const String landingPageID = "1";
    const contentID = "5";
    final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        contentID: UniqueID.fromUniqueString(contentID));
    final testUser = CustomUser(id: UniqueID.fromUniqueString("2"));
    final testContent = PageBuilderPage(
        id: UniqueID.fromUniqueString(contentID),
        sections: null,
        backgroundColor: null);
    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
      when(mockPageBuilderRepo.getLandingPageContent(contentID))
          .thenAnswer((_) async => right(testContent));

      // When
      pageBuilderCubit.getLandingPage(landingPageID);
      await untilCalled(mockLandingPageRepo.getLandingPage(landingPageID));
      // Then
      verify(mockLandingPageRepo.getLandingPage(landingPageID));
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

    test(
        "should emit GetLandingPageLoadingState and GetLandingPageAndUserSuccessState when function is called",
        () async {
      // Given
      final expectedResult = [
        GetLandingPageLoadingState(),
        GetLandingPageAndUserSuccessState(
            content: PagebuilderContent(
                landingPage: testLandingPage,
                content: testContent,
                user: testUser),
            saveLoading: false,
            saveFailure: null,
            saveSuccessful: null,
            isUpdated: null)
      ];
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
      when(mockPageBuilderRepo.getLandingPageContent(contentID))
          .thenAnswer((_) async => right(testContent));
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.getLandingPage(landingPageID);
    });

    test(
        "should emit GetLandingPageLoadingState and GetLandingPageFailureState when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        GetLandingPageLoadingState(),
        GetLandingPageFailureState(failure: BackendFailure())
      ];
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => left(BackendFailure()));
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));
      when(mockPageBuilderRepo.getLandingPageContent(contentID))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.getLandingPage(landingPageID);
    });

    test(
        "should emit GetLandingPageLoadingState and GetLandingPageFailureState when function is called and there was no contentID",
        () async {
      // Given
      final testLandingPage2 = LandingPage(id: UniqueID.fromUniqueString("1"));
      final expectedResult = [
        GetLandingPageLoadingState(),
        GetLandingPageFailureState(failure: NotFoundFailure())
      ];
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage2));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
      when(mockPageBuilderRepo.getLandingPageContent(contentID))
          .thenAnswer((_) async => right(testContent));
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.getLandingPage(landingPageID);
    });
  });

  group("PagebuilderCubit_saveLandingPage", () {
    final testLandingPage = LandingPage(id: UniqueID.fromUniqueString("1"));
    final testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("1"),
        backgroundColor: null,
        sections: [
          PageBuilderSection(
              id: UniqueID.fromUniqueString("2"),
              layout: PageBuilderSectionLayout.column,
              backgroundColor: null,
              widgets: [
                PageBuilderWidget(
                    id: UniqueID.fromUniqueString("3"),
                    elementType: PageBuilderWidgetType.text,
                    children: [],
                    widthPercentage: null,
                    backgroundColor: null,
                    containerChild: null,
                    padding: null,
                    properties: PageBuilderTextProperties(
                        text: "Test",
                        fontSize: 16,
                        color: Colors.black,
                        alignment: TextAlign.center))
              ])
        ]);
    final testUser = CustomUser(id: UniqueID.fromUniqueString("2"));
    final testContent = PagebuilderContent(
        landingPage: testLandingPage, content: testPage, user: testUser);

    test("should call pagebuilder repo if function is called", () async {
      // Given
      when(mockPageBuilderRepo.saveLandingPageContent(testContent.content))
          .thenAnswer((_) async => right(unit));
      // When
      pageBuilderCubit.saveLandingPageContent(testContent);
      await untilCalled(
          mockPageBuilderRepo.saveLandingPageContent(testContent.content));
      // Then
      verify(mockPageBuilderRepo.saveLandingPageContent(testContent.content));
      verifyNoMoreInteractions(mockPageBuilderRepo);
    });

    test(
        "should emit GetLandingPageAndUserSuccessState with loading and GetLandingPageAndUserSuccessState without loading when function is called",
        () async {
      // Given
      final expectedResult = [
        GetLandingPageAndUserSuccessState(
            content: testContent!,
            saveLoading: true,
            saveFailure: null,
            saveSuccessful: null,
            isUpdated: null),
        GetLandingPageAndUserSuccessState(
            content: testContent,
            saveLoading: false,
            saveFailure: null,
            saveSuccessful: true,
            isUpdated: false)
      ];
      when(mockPageBuilderRepo.saveLandingPageContent(testContent.content))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.saveLandingPageContent(testContent);
    });

    test(
        "should emit GetLandingPageAndUserSuccessState with loading and GetLandingPageAndUserSuccessState with failre when function is called and failed",
        () async {
      // Given
      final expectedResult = [
        GetLandingPageAndUserSuccessState(
            content: testContent!,
            saveLoading: true,
            saveFailure: null,
            saveSuccessful: null,
            isUpdated: null),
        GetLandingPageAndUserSuccessState(
            content: testContent,
            saveLoading: false,
            saveFailure: BackendFailure(),
            saveSuccessful: null,
            isUpdated: null)
      ];
      when(mockPageBuilderRepo.saveLandingPageContent(testContent.content))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.saveLandingPageContent(testContent);
    });
  });

  group("PagebuilderCubit_updateWidgets", () {
    final mockTextProperties1 = PageBuilderTextProperties(
        text: "Text 1",
        fontSize: 16.0,
        color: Colors.black,
        alignment: TextAlign.left);

    final mockTextProperties2 = PageBuilderTextProperties(
      text: "Text 2",
      fontSize: 18.0,
      color: Colors.red,
      alignment: TextAlign.center,
    );

    final mockImageProperties = PageBuilderImageProperties(
        url: "https://example.com/image.png",
        borderRadius: 10.0,
        width: 100.0,
        height: 150.0,
        localImage: Uint8List(0),
        alignment: Alignment.center);

    final mockTextWidget1 = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget1"),
        elementType: PageBuilderWidgetType.text,
        backgroundColor: null,
        properties: mockTextProperties1,
        children: [],
        widthPercentage: 100.0,
        containerChild: null,
        padding:
            PageBuilderPadding(top: 8.0, bottom: 8.0, left: 5.0, right: 5.0));

    final mockTextWidget2 = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget2"),
        elementType: PageBuilderWidgetType.text,
        backgroundColor: null,
        properties: mockTextProperties2,
        children: [],
        widthPercentage: 100.0,
        containerChild: null,
        padding:
            PageBuilderPadding(top: 8.0, bottom: 8.0, left: 5.0, right: 5.0));

    final mockImageWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget3"),
        elementType: PageBuilderWidgetType.image,
        backgroundColor: null,
        properties: mockImageProperties,
        children: [],
        containerChild: null,
        widthPercentage: 100.0,
        padding: null);

    final mockColumnWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("columnWidget"),
        elementType: PageBuilderWidgetType.column,
        backgroundColor: null,
        properties: null,
        children: [mockTextWidget1, mockTextWidget2, mockImageWidget],
        containerChild: null,
        widthPercentage: 100.0,
        padding: null);

    final mockRowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("rowWidget"),
        elementType: PageBuilderWidgetType.row,
        backgroundColor: null,
        properties: null,
        children: [mockTextWidget1, mockImageWidget],
        containerChild: null,
        widthPercentage: 100.0,
        padding: null);

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      layout: PageBuilderSectionLayout.column,
      backgroundColor: null,
      widgets: [mockColumnWidget, mockRowWidget],
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [mockSection],
    );

    final mockLandingPage = LandingPage(
      id: UniqueID.fromUniqueString("landingPage1"),
      contentID: UniqueID.fromUniqueString("content1"),
    );

    final mockUser = CustomUser(
      id: UniqueID.fromUniqueString("user1"),
    );

    final mockPagebuilderContent = PagebuilderContent(
      landingPage: mockLandingPage,
      content: mockPageBuilderPage,
      user: mockUser,
    );

    test("should emit GetLandingPageAndUserSuccessState with updated widget",
        () async {
      // Given
      final updatedWidget = mockTextWidget1.copyWith(
        widthPercentage: 80,
        properties: mockTextProperties1.copyWith(text: "Text3", fontSize: 30),
      );

      final updatedColumnWidget = mockColumnWidget.copyWith(children: [
        updatedWidget,
        mockTextWidget2,
        mockImageWidget,
      ]);

      final updatedRowWidget = mockRowWidget.copyWith(children: [
        updatedWidget,
        mockImageWidget,
      ]);

      final updatedSection = mockSection
          .copyWith(widgets: [updatedColumnWidget, updatedRowWidget]);

      final updatedPageBuilderPage =
          mockPageBuilderPage.copyWith(sections: [updatedSection]);

      final updatedContent =
          mockPagebuilderContent.copyWith(content: updatedPageBuilderPage);

      final expectedResult = GetLandingPageAndUserSuccessState(
        content: updatedContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      );

      // Then
      expectLater(
          pageBuilderCubit.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            expectedResult,
          ]));

      pageBuilderCubit.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderCubit.updateWidget(updatedWidget);
    });
  });
}
//TODO: Jetzt mit JSON weitermachen!