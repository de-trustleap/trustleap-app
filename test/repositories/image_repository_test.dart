import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:finanzbegleiter/constants.dart';
import '../mocks.mocks.dart';

void main() {
  late MockImageRepository mockImageRepo;

  setUp(() {
    mockImageRepo = MockImageRepository();
  });

  group("ImageRepositoryImplementation_UploadImageForWeb", () {
    const testID = "1";
    final testImage = Uint8List(12);
    const testURL = "http://test.de";
    test("should return image url when call was successful", () async {
      // Given
      final expectedResult = right(testURL);
      when(mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user))
          .thenAnswer((_) async => right(testURL));
      // When
      final result = await mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user);
      // Then
      verify(mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockImageRepo);
    });

    test("should return failure when call has failed", () async {
      // Given
      final expectedResult = left(ObjectNotFound());
      when(mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user))
          .thenAnswer((_) async => left(ObjectNotFound()));
      // When
      final result = await mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user);
      // Then
      verify(mockImageRepo.uploadImageForWeb(testImage, testID, ImageUploader.user));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockImageRepo);
    });
  });

}
