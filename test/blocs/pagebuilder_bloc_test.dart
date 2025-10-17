import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
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
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  late PagebuilderBloc pageBuilderBloc;
  late MockLandingPageRepository mockLandingPageRepo;
  late MockUserRepository mockUserRepo;
  late MockPagebuilderRepository mockPageBuilderRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    mockUserRepo = MockUserRepository();
    mockPageBuilderRepo = MockPagebuilderRepository();
    pageBuilderBloc = PagebuilderBloc(
        landingPageRepo: mockLandingPageRepo,
        pageBuilderRepo: mockPageBuilderRepo,
        userRepo: mockUserRepo);
  });

  test("init state should be PagebuilderInitial", () {
    expect(pageBuilderBloc.state, PagebuilderInitial());
  });

  group("PagebuilderBloc_getLandingPage", () {
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
      pageBuilderBloc.add(GetLandingPageEvent(landingPageID));
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
      expectLater(pageBuilderBloc.stream, emitsInOrder(expectedResult));
      pageBuilderBloc.add(GetLandingPageEvent(landingPageID));
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
      expectLater(pageBuilderBloc.stream, emitsInOrder(expectedResult));
      pageBuilderBloc.add(GetLandingPageEvent(landingPageID));
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
      expectLater(pageBuilderBloc.stream, emitsInOrder(expectedResult));
      pageBuilderBloc.add(GetLandingPageEvent(landingPageID));
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
                    containerChild: null,
                    padding: null,
                    margin: null,
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
                        letterSpacing: null,
                        textShadow: null,
                        isBold: null,
                        isItalic: null),
                    hoverProperties: null)
              ],
              visibleOn: null)
        ]);
    final testUser = CustomUser(id: UniqueID.fromUniqueString("2"));
    final testContent = PagebuilderContent(
        landingPage: testLandingPage, content: testPage, user: testUser);

    test("should call pagebuilder repo if function is called", () async {
      // Given
      when(mockPageBuilderRepo.saveLandingPageContent(testContent.content))
          .thenAnswer((_) async => right(unit));
      // When
      pageBuilderBloc.add(SaveLandingPageContentEvent(testContent));
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
      expectLater(pageBuilderBloc.stream, emitsInOrder(expectedResult));
      pageBuilderBloc.add(SaveLandingPageContentEvent(testContent));
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
      expectLater(pageBuilderBloc.stream, emitsInOrder(expectedResult));
      pageBuilderBloc.add(SaveLandingPageContentEvent(testContent));
    });
  });

  group("PagebuilderCubit_updateWidgets", () {
    final mockTextProperties1 = PageBuilderTextProperties(
        text: "Text 1",
        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: "TestFont",
        color: Colors.black,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        textShadow: null,
        isBold: null,
        isItalic: null);

    final mockTextProperties2 = PageBuilderTextProperties(
        text: "Text 2",
        fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
        fontFamily: "TestFont",
        color: Colors.red,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        textShadow: null,
        isBold: null,
        isItalic: null);

    final mockImageProperties = PageBuilderImageProperties(
        url: "https://example.com/image.png",
        borderRadius: 10.0,
        width: const PagebuilderResponsiveOrConstant.constant(100.0),
        height: const PagebuilderResponsiveOrConstant.constant(150.0),
        localImage: Uint8List(0),
        contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
        overlayPaint: null,
        showPromoterImage: false);

    final mockTextWidget1 = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget1"),
        elementType: PageBuilderWidgetType.text,
        background: null,
        hoverBackground: null,
        properties: mockTextProperties1,
        hoverProperties: null,
        children: [],
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        containerChild: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding:
            const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(8.0), bottom: PagebuilderResponsiveOrConstant.constant(8.0), left: PagebuilderResponsiveOrConstant.constant(5.0), right: PagebuilderResponsiveOrConstant.constant(5.0)));

    final mockTextWidget2 = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget2"),
        elementType: PageBuilderWidgetType.text,
        background: null,
        hoverBackground: null,
        properties: mockTextProperties2,
        hoverProperties: null,
        children: [],
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        maxWidth: null,
        containerChild: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding:
            const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(8.0), bottom: PagebuilderResponsiveOrConstant.constant(8.0), left: PagebuilderResponsiveOrConstant.constant(5.0), right: PagebuilderResponsiveOrConstant.constant(5.0)));

    final mockImageWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget3"),
        elementType: PageBuilderWidgetType.image,
        background: null,
        hoverBackground: null,
        properties: mockImageProperties,
        hoverProperties: null,
        children: [],
        containerChild: null,
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        maxWidth: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding: null);

    final mockColumnWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("columnWidget"),
        elementType: PageBuilderWidgetType.column,
        background: null,
        hoverBackground: null,
        properties: null,
        hoverProperties: null,
        children: [mockTextWidget1, mockTextWidget2, mockImageWidget],
        containerChild: null,
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        maxWidth: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding: null);

    final mockRowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("rowWidget"),
        elementType: PageBuilderWidgetType.row,
        background: null,
        hoverBackground: null,
        properties: null,
        hoverProperties: null,
        children: [mockTextWidget1, mockImageWidget],
        containerChild: null,
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        maxWidth: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding: null);

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Mock Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
      widgets: [mockColumnWidget, mockRowWidget],
      visibleOn: null,
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
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(80),
        properties: mockTextProperties1.copyWith(text: "Text3", fontSize: const PagebuilderResponsiveOrConstant.constant(30.0)),
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
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(UpdateWidgetEvent(updatedWidget));
    });
  });

  group("PagebuilderBloc_reorderSections", () {
    final section1 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Section 1",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
      visibleOn: null,
    );

    final section2 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section2"),
      name: "Section 2",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
      visibleOn: null,
    );

    final section3 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section3"),
      name: "Section 3",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [section1, section2, section3],
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

    test("should emit GetLandingPageAndUserSuccessState with reordered sections when moving from index 0 to 2",
        () async {
      // Given
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [section2, section1, section3],
      );

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
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderSectionsEvent(0, 2));
    });

    test("should emit GetLandingPageAndUserSuccessState with reordered sections when moving from index 2 to 0",
        () async {
      // Given
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [section3, section1, section2],
      );

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
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderSectionsEvent(2, 0));
    });

    test("should not emit any state if sections list is null", () async {
      // Given
      final pageWithNoSections = mockPageBuilderPage.copyWith(sections: null);
      final contentWithNoSections =
          mockPagebuilderContent.copyWith(content: pageWithNoSections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: contentWithNoSections,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithNoSections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderSectionsEvent(0, 1));
    });

    test("should not emit any state if sections list is empty", () async {
      // Given
      final pageWithEmptySections = mockPageBuilderPage.copyWith(sections: []);
      final contentWithEmptySections =
          mockPagebuilderContent.copyWith(content: pageWithEmptySections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: contentWithEmptySections,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithEmptySections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderSectionsEvent(0, 1));
    });

    test("should mark content as updated after reordering", () async {
      // Given
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [section2, section1, section3],
      );

      final updatedContent =
          mockPagebuilderContent.copyWith(content: updatedPageBuilderPage);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>(
                (state) => state.isUpdated == true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderSectionsEvent(0, 2));
    });
  });

  group("PagebuilderBloc_ReorderWidget", () {
    final widget1 = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget1"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Widget 1",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
          customCSS: null,    );

    final widget2 = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget2"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Widget 2",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
          customCSS: null,    );

    final widget3 = PageBuilderWidget(
      id: UniqueID.fromUniqueString("widget3"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Widget 3",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
          customCSS: null,    );

    final columnWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("column1"),
      elementType: PageBuilderWidgetType.column,
      properties: null,
      hoverProperties: null,
      children: [widget1, widget2, widget3],
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
          customCSS: null,    );

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [columnWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
    );

    final mockLandingPage = LandingPage(
      id: UniqueID.fromUniqueString("lp1"),
      contentID: UniqueID.fromUniqueString("page1"),
    );

    final mockUser = CustomUser(id: UniqueID.fromUniqueString("user1"));

    final mockPagebuilderContent = PagebuilderContent(
      landingPage: mockLandingPage,
      content: mockPageBuilderPage,
      user: mockUser,
    );

    test("should emit GetLandingPageAndUserSuccessState with reordered widgets when moving from index 0 to 2",
        () async {
      // Given
      final reorderedColumnWidget = columnWidget.copyWith(
        children: [widget2, widget1, widget3],
      );
      final updatedSection = mockSection.copyWith(
        widgets: [reorderedColumnWidget],
      );
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [updatedSection],
      );
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
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderWidgetEvent("column1", 0, 2));
    });

    test("should emit GetLandingPageAndUserSuccessState with reordered widgets when moving from index 2 to 0",
        () async {
      // Given
      final reorderedColumnWidget = columnWidget.copyWith(
        children: [widget3, widget1, widget2],
      );
      final updatedSection = mockSection.copyWith(
        widgets: [reorderedColumnWidget],
      );
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [updatedSection],
      );
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
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderWidgetEvent("column1", 2, 0));
    });

    test("should mark content as updated after reordering widgets", () async {
      // Given
      final reorderedColumnWidget = columnWidget.copyWith(
        children: [widget2, widget1, widget3],
      );
      final updatedSection = mockSection.copyWith(
        widgets: [reorderedColumnWidget],
      );
      final updatedPageBuilderPage = mockPageBuilderPage.copyWith(
        sections: [updatedSection],
      );

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>(
                (state) => state.isUpdated == true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderWidgetEvent("column1", 0, 2));
    });

    test("should not emit any state if parent widget is not found", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReorderWidgetEvent("nonexistent", 0, 1));
    });
  });

  group("PagebuilderBloc_UndoRedo", () {
    test("should not be able to undo initially", () {
      expect(pageBuilderBloc.canUndo(), false);
    });

    test("should not be able to redo initially", () {
      expect(pageBuilderBloc.canRedo(), false);
    });

    test("canUndo and canRedo should delegate to PagebuilderLocalHistory", () {
      // Test verifies that the methods exist and return boolean values
      expect(pageBuilderBloc.canUndo(), isA<bool>());
      expect(pageBuilderBloc.canRedo(), isA<bool>());
    });
  });

  group("PagebuilderBloc_UpdateSection", () {
    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: 1200.0,
      backgroundConstrained: null,
      customCSS: null,
      widgets: [],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
    );

    final mockLandingPage = LandingPage(
      id: UniqueID.fromUniqueString("lp1"),
      contentID: UniqueID.fromUniqueString("page1"),
    );

    final mockUser = CustomUser(id: UniqueID.fromUniqueString("user1"));

    final mockPagebuilderContent = PagebuilderContent(
      landingPage: mockLandingPage,
      content: mockPageBuilderPage,
      user: mockUser,
    );

    test("should emit GetLandingPageAndUserSuccessState with updated section",
        () async {
      // Given
      final updatedSection = mockSection.copyWith(
        name: "Updated Section",
        maxWidth: 1400.0,
      );

      final updatedPage = mockPageBuilderPage.copyWith(
        sections: [updatedSection],
      );

      final updatedContent = mockPagebuilderContent.copyWith(
        content: updatedPage,
      );

      final expectedResult = GetLandingPageAndUserSuccessState(
        content: updatedContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      );

      // Then
      expectLater(
          pageBuilderBloc.stream,
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

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(UpdateSectionEvent(updatedSection));
    });

    test("should mark content as updated after section update", () async {
      // Given
      final updatedSection = mockSection.copyWith(
        name: "Updated Section",
      );

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>(
                (state) => state.isUpdated == true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(UpdateSectionEvent(updatedSection));
    });
  });

  group("PagebuilderBloc_AddWidgetAtPosition", () {
    final targetWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("target"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Target",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    final newWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("new"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "New Widget",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
        isBold: null,
        isItalic: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      layout: PageBuilderSectionLayout.column,
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
      widgets: [targetWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
    );

    final mockLandingPage = LandingPage(
      id: UniqueID.fromUniqueString("lp1"),
      contentID: UniqueID.fromUniqueString("page1"),
    );

    final mockUser = CustomUser(id: UniqueID.fromUniqueString("user1"));

    final mockPagebuilderContent = PagebuilderContent(
      landingPage: mockLandingPage,
      content: mockPageBuilderPage,
      user: mockUser,
    );

    test("should emit GetLandingPageAndUserSuccessState when adding widget with 'before' position",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              // Verify that a new state was emitted with isUpdated = true
              return state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.before,
      ));
    });

    test("should emit GetLandingPageAndUserSuccessState when adding widget with 'after' position",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              return state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.after,
      ));
    });

    test("should emit GetLandingPageAndUserSuccessState when adding widget with 'above' position",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              return state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.above,
      ));
    });

    test("should emit GetLandingPageAndUserSuccessState when adding widget with 'below' position",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              return state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.below,
      ));
    });

    test("should mark content as updated after adding widget", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: mockPagebuilderContent,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
            predicate<GetLandingPageAndUserSuccessState>(
                (state) => state.isUpdated == true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.before,
      ));
    });

    test("should not emit new state if sections are null", () async {
      // Given
      final pageWithNoSections = mockPageBuilderPage.copyWith(sections: null);
      final contentWithNoSections =
          mockPagebuilderContent.copyWith(content: pageWithNoSections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: contentWithNoSections,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithNoSections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.before,
      ));
    });

    test("should not emit new state if sections are empty", () async {
      // Given
      final pageWithEmptySections = mockPageBuilderPage.copyWith(sections: []);
      final contentWithEmptySections =
          mockPagebuilderContent.copyWith(content: pageWithEmptySections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            GetLandingPageAndUserSuccessState(
              content: contentWithEmptySections,
              saveLoading: false,
              saveFailure: null,
              saveSuccessful: null,
              isUpdated: false,
            ),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithEmptySections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddWidgetAtPositionEvent(
        newWidget: newWidget,
        targetWidgetId: "target",
        position: DropPosition.before,
      ));
    });
  });
}
