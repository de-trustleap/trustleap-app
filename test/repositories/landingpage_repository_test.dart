import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'landingpage_repository_test.mocks.dart';

@GenerateMocks([LandingPageRepository])
void main() {
  late MockLandingPageRepository mockLandingPageRepo;

  setUp(() {
    mockLandingPageRepo = MockLandingPageRepository();
  });

  group("LandingPageRepositoryImplementation_getAllLandingPages", () {
    final testLandingPages = [
      LandingPage(id: UniqueID.fromUniqueString("1")),
      LandingPage(id: UniqueID.fromUniqueString("2")),
      LandingPage(id: UniqueID.fromUniqueString("3"))
    ];
    const ids = ["1", "2", "3"];
    test("should return landingpages when the call was successful", () async {
      // Given
      final expectedResult = right(testLandingPages);
      when(mockLandingPageRepo.getAllLandingPages(ids)).thenAnswer((_) async => right(testLandingPages));
      // When
      final result = await mockLandingPageRepo.getAllLandingPages(ids);
      // Then
      verify(mockLandingPageRepo.getAllLandingPages(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });

     test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.getAllLandingPages(ids)).thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.getAllLandingPages(ids);
      // Then
      verify(mockLandingPageRepo.getAllLandingPages(ids));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
    });
  });

  group("LandingPageRepositoryImplementation_createLandingPage", () {
    final testLandingPage = LandingPage(
      id: UniqueID.fromUniqueString("1"),
      name: "Test",
      text: "Test",
      ownerID: UniqueID.fromUniqueString("1"));
    final testImageData = Uint8List(1);
    const imageHasChanged = false;
  test( "should return unit when landingpage has been created and the call was successful", () async {
     // Given
      final expectedResult = right(unit);
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged)).thenAnswer((_) async => right(unit));
      // When
      final result = await mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged);
      // Then
      verify(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
  });

  test( "should return failure when the call has failed", () async {
     // Given
      final expectedResult = left(BackendFailure());
      when(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged)).thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged);
      // Then
      verify(mockLandingPageRepo.createLandingPage(testLandingPage, testImageData, imageHasChanged));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLandingPageRepo);
  });
  });
}


