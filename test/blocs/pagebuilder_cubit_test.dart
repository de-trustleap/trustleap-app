import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

void main() {
  late PagebuilderCubit pageBuilderCubit;
  late MockLandingPageRepository mockLandingPageRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
    mockUserRepo = MockUserRepository();
    pageBuilderCubit = PagebuilderCubit(mockLandingPageRepo, mockUserRepo);
  });

  test("init state should be PagebuilderInitial", () {
    expect(pageBuilderCubit.state, PagebuilderInitial());
  });

  group("PagebuilderCubit_getLandingPage", () {
    const String landingPageID = "1";
    final testLandingPage = LandingPage(id: UniqueID.fromUniqueString("1"));
    final testUser = CustomUser(id: UniqueID.fromUniqueString("2"));

    test("should call landingpage repo if function is called", () async {
      // Given
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
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
            landingPage: testLandingPage, user: testUser)
      ];
      when(mockLandingPageRepo.getLandingPage(landingPageID))
          .thenAnswer((_) async => right(testLandingPage));
      when(mockUserRepo.getUser()).thenAnswer((_) async => right(testUser));
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
      // Then
      expectLater(pageBuilderCubit.stream, emitsInOrder(expectedResult));
      pageBuilderCubit.getLandingPage(landingPageID);
    });
  });
}
