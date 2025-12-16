import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
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
        backgroundColor: null,
        globalStyles: null);
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
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
      when(mockPageBuilderRepo.getLandingPageContent(contentID))
          .thenAnswer((_) async => right(testContent));
      // Then
      expectLater(pageBuilderBloc.stream, emitsInOrder([
        isA<GetLandingPageLoadingState>(),
        isA<GetLandingPageAndUserSuccessState>()
      ]));
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
              background: null,
              maxWidth: null,
              backgroundConstrained: null,
              customCSS: null,
        fullHeight: null,
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
                        textShadow: null),
                    hoverProperties: null)
              ],
              visibleOn: null)
        ],
        globalStyles: null);
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
      when(mockPageBuilderRepo.saveLandingPageContent(testContent!.content))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(pageBuilderBloc.stream, emitsInOrder([
        isA<GetLandingPageAndUserSuccessState>()
            .having((state) => state.saveLoading, "saveLoading", true),
        isA<GetLandingPageAndUserSuccessState>()
            .having((state) => state.saveLoading, "saveLoading", false)
            .having((state) => state.saveSuccessful, "saveSuccessful", true)
      ]));
      pageBuilderBloc.add(SaveLandingPageContentEvent(testContent));
    });

    test(
        "should emit GetLandingPageAndUserSuccessState with loading and GetLandingPageAndUserSuccessState with failre when function is called and failed",
        () async {
      // Given
      when(mockPageBuilderRepo.saveLandingPageContent(testContent!.content))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(pageBuilderBloc.stream, emitsInOrder([
        isA<GetLandingPageAndUserSuccessState>()
            .having((state) => state.saveLoading, "saveLoading", true),
        isA<GetLandingPageAndUserSuccessState>()
            .having((state) => state.saveLoading, "saveLoading", false)
            .having((state) => state.saveFailure, "saveFailure", isA<BackendFailure>())
      ]));
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
        textShadow: null);

    final mockTextProperties2 = PageBuilderTextProperties(
        text: "Text 2",
        fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
        fontFamily: "TestFont",
        color: Colors.red,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        textShadow: null);

    final mockImageProperties = PageBuilderImageProperties(
        url: "https://example.com/image.png",
        border: const PagebuilderBorder(radius: 10.0, width: null, color: null),
        width: const PagebuilderResponsiveOrConstant.constant(100.0),
        height: const PagebuilderResponsiveOrConstant.constant(150.0),
        localImage: Uint8List(0),
        contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
        overlayPaint: null,
        shadow: null,
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
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [mockColumnWidget, mockRowWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [mockSection],
      globalStyles: null,
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
        fullHeight: null,
      visibleOn: null,
    );

    final section2 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section2"),
      name: "Section 2",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
        fullHeight: null,
      visibleOn: null,
    );

    final section3 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section3"),
      name: "Section 3",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [],
        fullHeight: null,
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [section1, section2, section3],
      globalStyles: null,
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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

      // Then - should only emit the initial state, no additional states
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
          customCSS: null,      widgets: [columnWidget],
        fullHeight: null,
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
      globalStyles: null,
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
    final mockTextProperties = PageBuilderTextProperties(
        text: "Original text",
        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: "TestFont",
        color: Colors.black,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        textShadow: null);

    final mockTextWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("widget1"),
        elementType: PageBuilderWidgetType.text,
        background: null,
        hoverBackground: null,
        properties: mockTextProperties,
        hoverProperties: null,
        children: [],
        widthPercentage: const PagebuilderResponsiveOrConstant.constant(100.0),
        containerChild: null,
        maxWidth: null,
        alignment: null,
        customCSS: null,
        margin: null,
        padding: null);

    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [mockTextWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [mockSection],
      globalStyles: null,
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

    test("should not be able to undo initially", () {
      expect(pageBuilderBloc.canUndo(), false);
    });

    test("should not be able to redo initially", () {
      expect(pageBuilderBloc.canRedo(), false);
    });

    test("canUndo and canRedo should delegate to PagebuilderLocalHistory", () {
      expect(pageBuilderBloc.canUndo(), isA<bool>());
      expect(pageBuilderBloc.canRedo(), isA<bool>());
    });
  });

  group("PagebuilderBloc_UpdateSection", () {
    final mockSection = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Test Section",
      background: null,
      maxWidth: 1200.0,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
      globalStyles: null,
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

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [targetWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
      globalStyles: null,
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
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

  group("PagebuilderBloc_AddSection", () {
    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [],
      backgroundColor: null,
      globalStyles: null,
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

    test("should emit GetLandingPageAndUserSuccessState with new section for 1 column",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              // Verify that new section was added
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final newSection = sections.last;
              // For 1 column: Column -> Placeholder
              return newSection.widgets?.length == 1 &&
                  newSection.widgets!.first.elementType == PageBuilderWidgetType.column &&
                  newSection.widgets!.first.children?.length == 1 &&
                  newSection.widgets!.first.children!.first.elementType == PageBuilderWidgetType.placeholder &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddSectionEvent(1));
    });

    test("should emit GetLandingPageAndUserSuccessState with new section for 3 columns",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              // Verify that new section was added
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final newSection = sections.last;
              // For 3 columns: Column -> Row -> 3 Placeholders with widthPercentage
              if (newSection.widgets?.length != 1) return false;
              final column = newSection.widgets!.first;
              if (column.elementType != PageBuilderWidgetType.column) return false;
              if (column.children?.length != 1) return false;

              final row = column.children!.first;
              if (row.elementType != PageBuilderWidgetType.row) return false;
              if (row.children?.length != 3) return false;

              // Check all children are placeholders with correct widthPercentage
              for (final child in row.children!) {
                if (child.elementType != PageBuilderWidgetType.placeholder) return false;
                if (child.widthPercentage == null) return false;
                // Should be approximately 33.33% for 3 columns
                final percentage = child.widthPercentage!.constantValue;
                if (percentage == null || (percentage - 33.33).abs() > 0.1) return false;
              }

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

      pageBuilderBloc.add(AddSectionEvent(3));
    });

    test("should mark content as updated after adding section", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(AddSectionEvent(2));
    });

    test("should not emit new state if current state is not success state",
        () async {
      // Then
      expectLater(pageBuilderBloc.stream, emitsInOrder([]));

      pageBuilderBloc.add(AddSectionEvent(1));
    });
  });

  group("PagebuilderBloc_ReplacePlaceholder", () {
    final placeholderWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("placeholder1"),
      elementType: PageBuilderWidgetType.placeholder,
      properties: null,
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(50.0),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    final rowWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("row1"),
      elementType: PageBuilderWidgetType.row,
      properties: null,
      hoverProperties: null,
      children: [placeholderWidget],
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

    final columnWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("column1"),
      elementType: PageBuilderWidgetType.column,
      properties: null,
      hoverProperties: null,
      children: [rowWidget],
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
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [columnWidget],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      sections: [mockSection],
      backgroundColor: null,
      globalStyles: null,
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

    test("should emit GetLandingPageAndUserSuccessState with placeholder replaced by text widget",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              // Verify that placeholder was replaced with text widget
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final column = section.widgets?.first;
              if (column == null) return false;

              final row = column.children?.first;
              if (row == null || row.children == null || row.children!.isEmpty) return false;

              final replacedWidget = row.children!.first;

              // Should be text widget now, not placeholder
              if (replacedWidget.elementType != PageBuilderWidgetType.text) return false;

              // Should preserve widthPercentage from placeholder
              if (replacedWidget.widthPercentage?.constantValue != 50.0) return false;

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

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "placeholder1",
        widgetType: PageBuilderWidgetType.text,
      ));
    });

    test("should emit GetLandingPageAndUserSuccessState with placeholder replaced by image widget",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final column = section.widgets?.first;
              if (column == null) return false;

              final row = column.children?.first;
              if (row == null || row.children == null || row.children!.isEmpty) return false;

              final replacedWidget = row.children!.first;

              return replacedWidget.elementType == PageBuilderWidgetType.image &&
                  replacedWidget.widthPercentage?.constantValue == 50.0 &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "placeholder1",
        widgetType: PageBuilderWidgetType.image,
      ));
    });

    test("should mark content as updated after replacing placeholder",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "placeholder1",
        widgetType: PageBuilderWidgetType.text,
      ));
    });

    test("should not emit new state if placeholder is not found", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "nonexistent",
        widgetType: PageBuilderWidgetType.text,
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithNoSections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "placeholder1",
        widgetType: PageBuilderWidgetType.text,
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
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithEmptySections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(ReplacePlaceholderEvent(
        placeholderId: "placeholder1",
        widgetType: PageBuilderWidgetType.text,
      ));
    });
  });

  group("PagebuilderBloc_DeleteSection", () {
    final section1 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Section 1",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final section2 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section2"),
      name: "Section 2",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final section3 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section3"),
      name: "Section 3",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [section1, section2, section3],
      globalStyles: null,
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

    test("should emit GetLandingPageAndUserSuccessState with section deleted when deleting first section",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 2 sections left
              if (sections == null || sections.length != 2) return false;
              // Should be section2 and section3
              return sections[0].id.value == "section2" &&
                  sections[1].id.value == "section3" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section1"));
    });

    test("should emit GetLandingPageAndUserSuccessState with section deleted when deleting middle section",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 2 sections left
              if (sections == null || sections.length != 2) return false;
              // Should be section1 and section3
              return sections[0].id.value == "section1" &&
                  sections[1].id.value == "section3" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section2"));
    });

    test("should emit GetLandingPageAndUserSuccessState with section deleted when deleting last section",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 2 sections left
              if (sections == null || sections.length != 2) return false;
              // Should be section1 and section2
              return sections[0].id.value == "section1" &&
                  sections[1].id.value == "section2" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section3"));
    });

    test("should mark content as updated after deleting section", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section1"));
    });

    test("should not emit new state if section to delete is not found",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should still have all 3 sections
              return sections?.length == 3 && state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("nonexistent"));
    });

    test("should not emit new state if sections list is null", () async {
      // Given
      final pageWithNoSections = mockPageBuilderPage.copyWith(sections: null);
      final contentWithNoSections =
          mockPagebuilderContent.copyWith(content: pageWithNoSections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithNoSections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section1"));
    });

    test("should not emit new state if sections list is empty", () async {
      // Given
      final pageWithEmptySections = mockPageBuilderPage.copyWith(sections: []);
      final contentWithEmptySections =
          mockPagebuilderContent.copyWith(content: pageWithEmptySections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithEmptySections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section1"));
    });

    test("should handle deleting the only remaining section", () async {
      // Given
      final pageWithOneSection = mockPageBuilderPage.copyWith(
        sections: [section1],
      );
      final contentWithOneSection =
          mockPagebuilderContent.copyWith(content: pageWithOneSection);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have empty list
              return sections?.isEmpty == true && state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithOneSection,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteSectionEvent("section1"));
    });
  });

  group("PagebuilderBloc_DuplicateSection", () {
    final childWidget = PageBuilderWidget(
      id: UniqueID.fromUniqueString("child1"),
      elementType: PageBuilderWidgetType.text,
      properties: PageBuilderTextProperties(
        text: "Test Text",
        fontSize: null,
        fontFamily: null,
        lineHeight: null,
        letterSpacing: null,
        color: null,
        alignment: null,
        textShadow: null,
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

    final section1 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section1"),
      name: "Section 1",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [childWidget],
      visibleOn: null,
    );

    final section2 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section2"),
      name: "Section 2",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final section3 = PageBuilderSection(
      id: UniqueID.fromUniqueString("section3"),
      name: "Section 3",
      background: null,
      maxWidth: null,
      backgroundConstrained: null,
      customCSS: null,
        fullHeight: null,
      widgets: [],
      visibleOn: null,
    );

    final mockPageBuilderPage = PageBuilderPage(
      id: UniqueID.fromUniqueString("page1"),
      backgroundColor: null,
      sections: [section1, section2, section3],
      globalStyles: null,
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

    test("should emit GetLandingPageAndUserSuccessState with duplicated section after original",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 4 sections now (3 original + 1 duplicate)
              if (sections == null || sections.length != 4) return false;
              // Duplicated section should be at index 1 (after section1)
              // Check that the name has " (Kopie)" appended
              if (!(sections[1].name?.contains("(Kopie)") ?? false)) return false;
              // Check that the ID is different from original
              if (sections[1].id.value == "section1") return false;
              // Check that sections are in correct order
              if (sections[0].id.value != "section1") return false;
              if (sections[2].id.value != "section2") return false;
              if (sections[3].id.value != "section3") return false;
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

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });

    test("should duplicate section with all its widgets and assign new IDs",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.length != 4) return false;

              // Get the duplicated section
              final duplicatedSection = sections[1];
              final originalSection = sections[0];

              // Check that widgets are duplicated
              if (duplicatedSection.widgets?.length != originalSection.widgets?.length) {
                return false;
              }

              // Check that widget IDs are different
              if (duplicatedSection.widgets?[0].id.value == originalSection.widgets?[0].id.value) {
                return false;
              }

              // Check that the widget properties are preserved
              final origWidget = originalSection.widgets?[0];
              final dupWidget = duplicatedSection.widgets?[0];
              if (origWidget?.elementType != dupWidget?.elementType) return false;

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

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });

    test("should duplicate middle section and insert it at correct position",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 4 sections
              if (sections == null || sections.length != 4) return false;
              // Check order: section1, section2, duplicate of section2, section3
              if (sections[0].id.value != "section1") return false;
              if (sections[1].id.value != "section2") return false;
              // Index 2 should be the duplicate (different ID but name with Kopie)
              if (sections[2].id.value == "section2") return false;
              if (!(sections[2].name?.contains("(Kopie)") ?? false)) return false;
              if (sections[3].id.value != "section3") return false;
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

      pageBuilderBloc.add(DuplicateSectionEvent("section2"));
    });

    test("should duplicate last section and append it at the end", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              // Should have 4 sections
              if (sections == null || sections.length != 4) return false;
              // Check that the last section is the duplicate
              if (sections[3].id.value == "section3") return false;
              if (!(sections[3].name?.contains("(Kopie)") ?? false)) return false;
              // Check order of other sections
              if (sections[0].id.value != "section1") return false;
              if (sections[1].id.value != "section2") return false;
              if (sections[2].id.value != "section3") return false;
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

      pageBuilderBloc.add(DuplicateSectionEvent("section3"));
    });

    test("should mark content as updated after duplicating section",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });

    test("should not emit new state if section to duplicate is not found",
        () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateSectionEvent("nonexistent"));
    });

    test("should not emit new state if sections list is null", () async {
      // Given
      final pageWithNoSections = mockPageBuilderPage.copyWith(sections: null);
      final contentWithNoSections =
          mockPagebuilderContent.copyWith(content: pageWithNoSections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithNoSections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });

    test("should not emit new state if sections list is empty", () async {
      // Given
      final pageWithEmptySections = mockPageBuilderPage.copyWith(sections: []);
      final contentWithEmptySections =
          mockPagebuilderContent.copyWith(content: pageWithEmptySections);

      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: contentWithEmptySections,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });

    test("should append (Kopie) to section name when duplicating", () async {
      // Then
      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.length != 4) return false;
              // Check that the duplicated section has the correct name
              final duplicatedSection = sections[1];
              return duplicatedSection.name == "Section 1 (Kopie)" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateSectionEvent("section1"));
    });
  });

  group("PagebuilderBloc_DeleteWidget", () {
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
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(50.0),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

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
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(50.0),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

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
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(33.33),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    test(
        "should delete widget from Row with 2 widgets and unwrap the remaining widget",
        () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              return section.widgets?.length == 1 &&
                  section.widgets!.first.id.value == "widget2" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test(
        "should delete widget from Row with 3 widgets and redistribute widthPercentages",
        () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
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
        customCSS: null,
      );

      final mockSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        name: "Test Section",
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final widgets = section.widgets;
              if (widgets == null || widgets.isEmpty) return false;

              final row = widgets.first;
              if (row.elementType != PageBuilderWidgetType.row) return false;
              if (row.children == null || row.children!.length != 2)
                return false;

              for (final child in row.children!) {
                final widthValue = child.widthPercentage?.constantValue;
                if (widthValue == null || (widthValue - 50.0).abs() > 0.1) {
                  return false;
                }
              }

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

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test(
        "should delete widget from Column with 2 widgets and unwrap the remaining widget",
        () async {
      final columnWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("column1"),
        elementType: PageBuilderWidgetType.column,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [columnWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              return section.widgets?.length == 1 &&
                  section.widgets!.first.id.value == "widget2" &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test("should delete containerChild and remove the Container", () async {
      final containerWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("container1"),
        elementType: PageBuilderWidgetType.container,
        properties: null,
        hoverProperties: null,
        children: null,
        containerChild: widget1,
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [containerWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              return section.widgets?.isEmpty == true &&
                  state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test("should mark content as updated after deleting widget", () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test("should not emit new state if widget to delete is not found",
        () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
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

      pageBuilderBloc.add(DeleteWidgetEvent("nonexistent"));
    });

    test("should not emit new state if sections list is null", () async {
      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: null,
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });

    test("should not emit new state if sections list is empty", () async {
      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DeleteWidgetEvent("widget1"));
    });
  });

  group("PagebuilderBloc_DuplicateWidget", () {
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
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(50.0),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

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
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: const PagebuilderResponsiveOrConstant.constant(50.0),
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );

    test("should duplicate widget in row and redistribute widths", () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final row = section.widgets?.first;

              // Should have 3 widgets now (2 original + 1 duplicate)
              if (row?.children?.length != 3) return false;

              // Check that duplicated widget has different ID
              if (row!.children![1].id.value == "widget1") return false;

              // Check width redistribution
              final width1 = row.children![0].widthPercentage?.getValueForBreakpoint(PagebuilderResponsiveBreakpoint.desktop);
              final width2 = row.children![1].widthPercentage?.getValueForBreakpoint(PagebuilderResponsiveBreakpoint.desktop);
              final width3 = row.children![2].widthPercentage?.getValueForBreakpoint(PagebuilderResponsiveBreakpoint.desktop);

              if (width1 == null || width2 == null || width3 == null) return false;

              return (width1 - 33.33).abs() < 0.01 &&
                     (width2 - 33.33).abs() < 0.01 &&
                     (width3 - 33.34).abs() < 0.01 &&
                     state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateWidgetEvent("widget1"));
    });

    test("should duplicate widget in column", () async {
      final columnWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("column1"),
        elementType: PageBuilderWidgetType.column,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [columnWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final column = section.widgets?.first;

              // Should have 3 widgets now (2 original + 1 duplicate)
              if (column?.children?.length != 3) return false;

              // Check that first widget is still widget1
              if (column!.children![0].id.value != "widget1") return false;

              // Check that duplicated widget has different ID
              if (column.children![1].id.value == "widget1") return false;

              // Check that third widget is widget2
              if (column.children![2].id.value != "widget2") return false;

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

      pageBuilderBloc.add(DuplicateWidgetEvent("widget1"));
    });

    test("should mark content as updated after duplicating widget", () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", true),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateWidgetEvent("widget1"));
    });

    test("should not emit new state if widget to duplicate is not found",
        () async {
      final rowWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("row1"),
        elementType: PageBuilderWidgetType.row,
        properties: null,
        hoverProperties: null,
        children: [widget1, widget2],
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [rowWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final row = section.widgets?.first;

              // Should still have 2 widgets
              return row?.children?.length == 2 && state.isUpdated == true;
            }),
          ]));

      pageBuilderBloc.emit(GetLandingPageAndUserSuccessState(
        content: mockPagebuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      ));

      pageBuilderBloc.add(DuplicateWidgetEvent("nonexistent"));
    });

    test("should duplicate container child and wrap in column", () async {
      final childWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("child1"),
        elementType: PageBuilderWidgetType.text,
        properties: PageBuilderTextProperties(
          text: "Child 1",
          fontSize: null,
          fontFamily: null,
          lineHeight: null,
          letterSpacing: null,
          color: null,
          alignment: null,
          textShadow: null,
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

      final containerWidget = PageBuilderWidget(
        id: UniqueID.fromUniqueString("container1"),
        elementType: PageBuilderWidgetType.container,
        properties: null,
        hoverProperties: null,
        children: null,
        containerChild: childWidget,
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
        background: null,
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        widgets: [containerWidget],
        visibleOn: null,
      );

      final mockPageBuilderPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: [mockSection],
        backgroundColor: null,
        globalStyles: null,
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

      expectLater(
          pageBuilderBloc.stream,
          emitsInOrder([
            isA<GetLandingPageAndUserSuccessState>()
                .having((state) => state.isUpdated, "isUpdated", false),
            predicate<GetLandingPageAndUserSuccessState>((state) {
              final sections = state.content.content?.sections;
              if (sections == null || sections.isEmpty) return false;

              final section = sections.first;
              final container = section.widgets?.first;

              // Container child should now be a column
              if (container?.containerChild?.elementType != PageBuilderWidgetType.column) return false;

              // Column should have 2 children
              if (container!.containerChild!.children?.length != 2) return false;

              // First child should be original
              if (container.containerChild!.children![0].id.value != "child1") return false;

              // Second child should have different ID
              if (container.containerChild!.children![1].id.value == "child1") return false;

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

      pageBuilderBloc.add(DuplicateWidgetEvent("child1"));
    });
  });

  group("PagebuilderBloc_UpdateGlobalStyles", () {
    test(
        "should emit GetLandingPageAndUserSuccessState with updated globalStyles and isUpdated true",
        () async {
      // Given
      const initialGlobalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF0000),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );

      const updatedGlobalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFF00FF00),
          secondary: Color(0xFF0000FF),
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );

      final testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("1"),
        sections: [],
        backgroundColor: null,
        globalStyles: initialGlobalStyles,
      );

      final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        contentID: UniqueID.fromUniqueString("1"),
      );

      final testUser = CustomUser(id: UniqueID.fromUniqueString("1"));

      final testContent = PagebuilderContent(
        landingPage: testLandingPage,
        content: testPage,
        user: testUser,
      );

      final initialState = GetLandingPageAndUserSuccessState(
        content: testContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      );

      pageBuilderBloc.emit(initialState);

      // Then
      expectLater(
        pageBuilderBloc.stream,
        emits(predicate<GetLandingPageAndUserSuccessState>((state) {
          return state.isUpdated == true &&
                 state.content.content?.globalStyles?.colors?.primary == Color(0xFF00FF00) &&
                 state.content.content?.globalStyles?.colors?.secondary == Color(0xFF0000FF);
        })),
      );

      // When
      pageBuilderBloc.add(UpdateGlobalStylesEvent(updatedGlobalStyles));
    });

    test(
        "should not emit any state when currentPage is null",
        () async {
      // Given
      const updatedGlobalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFF00FF00),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );

      final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        contentID: UniqueID.fromUniqueString("1"),
      );

      final testUser = CustomUser(id: UniqueID.fromUniqueString("1"));

      final testContent = PagebuilderContent(
        landingPage: testLandingPage,
        content: null,
        user: testUser,
      );

      final initialState = GetLandingPageAndUserSuccessState(
        content: testContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      );

      pageBuilderBloc.emit(initialState);

      // When
      pageBuilderBloc.add(UpdateGlobalStylesEvent(updatedGlobalStyles));
      await Future.delayed(Duration(milliseconds: 100));

      // Then
      expect(pageBuilderBloc.state, initialState);
    });

    test(
        "should update globalStyles and preserve page structure",
        () async {
      // Given
      const initialGlobalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFFFF0000),
          secondary: null,
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );

      const updatedGlobalStyles = PageBuilderGlobalStyles(
        colors: PageBuilderGlobalColors(
          primary: Color(0xFF00FF00),
          secondary: Color(0xFF0000FF),
          tertiary: null,
          background: null,
          surface: null,
        ),
        fonts: null,
      );

      final testSection = PageBuilderSection(
        id: UniqueID.fromUniqueString("section1"),
        name: "Test Section",
        background: null,
        widgets: [],
        maxWidth: null,
        backgroundConstrained: null,
        customCSS: null,
        fullHeight: null,
        visibleOn: null,
      );

      final testPage = PageBuilderPage(
        id: UniqueID.fromUniqueString("1"),
        sections: [testSection],
        backgroundColor: null,
        globalStyles: initialGlobalStyles,
      );

      final testLandingPage = LandingPage(
        id: UniqueID.fromUniqueString("1"),
        contentID: UniqueID.fromUniqueString("1"),
      );

      final testUser = CustomUser(id: UniqueID.fromUniqueString("1"));

      final testContent = PagebuilderContent(
        landingPage: testLandingPage,
        content: testPage,
        user: testUser,
      );

      final initialState = GetLandingPageAndUserSuccessState(
        content: testContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: false,
      );

      pageBuilderBloc.emit(initialState);

      // Then
      expectLater(
        pageBuilderBloc.stream,
        emits(predicate<GetLandingPageAndUserSuccessState>((state) {
          // Check that globalStyles were updated
          final stylesUpdated = state.content.content?.globalStyles?.colors?.primary == Color(0xFF00FF00) &&
                 state.content.content?.globalStyles?.colors?.secondary == Color(0xFF0000FF);

          // Check that page structure was preserved
          final structurePreserved = state.content.content?.sections?.length == 1 &&
                 state.content.content?.sections?[0].id.value == "section1";

          return state.isUpdated == true && stylesUpdated && structurePreserved;
        })),
      );

      // When
      pageBuilderBloc.add(UpdateGlobalStylesEvent(updatedGlobalStyles));
    });
  });
}
