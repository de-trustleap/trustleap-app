import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

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
        id: UniqueID.fromUniqueString(contentID), sections: null);
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
            saveSuccessful: null)
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
}
