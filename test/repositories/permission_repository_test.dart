import '../mocks.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

void main() {
  late MockPermissionRepository mockPermissionRepo;

  setUp(() {
    mockPermissionRepo = MockPermissionRepository();
  });

  group("PermissionRepositoryImplementation_observeAllPermissions", () {
    const testPermissions = Permissions(
        permissions: {"createLandingPage": true, "editLandingPage": false});
    test("should return permissions when the call was successful", () async {
      // Given
      final expectedResult = right(testPermissions);
      when(mockPermissionRepo.observeAllPermissions())
          .thenAnswer((_) => Stream.value(right(testPermissions)));
      // When
      final result = await mockPermissionRepo.observeAllPermissions().first;
      // Then
      verify(mockPermissionRepo.observeAllPermissions());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPermissionRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockPermissionRepo.observeAllPermissions())
          .thenAnswer((_) => Stream.value(left(BackendFailure())));
      // When
      final result = await mockPermissionRepo.observeAllPermissions().first;
      // Then
      verify(mockPermissionRepo.observeAllPermissions());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockPermissionRepo);
    });
  });
}
