import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

void main() {
  late MockPagebuilderRepository mockPageBuilderRepo;

  setUp(() {
    mockPageBuilderRepo = MockPagebuilderRepository();
  });

  group("PageBuilderRepositoryImplementation_getLandingPageContent", () {
    final testPage =
        PageBuilderPage(id: UniqueID.fromUniqueString("2"), sections: null);
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
}
