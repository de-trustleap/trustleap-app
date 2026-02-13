import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';

void main() {
  late PermissionCubit permissionCubit;
  late MockPermissionRepository mockPermissionRepo;

  setUp(() {
    mockPermissionRepo = MockPermissionRepository();
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepo);
  });

  test("init state should be PermissionInitial", () {
    expect(permissionCubit.state, PermissionInitial());
  });

  group("PermissionCubit_observePermissions", () {
    const testPermissions = Permissions(
        permissions: {"createLandingPage": true, "editLandingPage": false});
    test("should call repo if function is called", () async {
      // Given
      when(mockPermissionRepo.observeAllPermissions()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Permissions>>.fromIterable(
              [right(testPermissions)]));
      // When
      permissionCubit.observePermissions();
      await untilCalled(mockPermissionRepo.observeAllPermissions());
      // Then
      verify(mockPermissionRepo.observeAllPermissions());
      verifyNoMoreInteractions(mockPermissionRepo);
    });

    test(
        "should emit PermissionLoadingState and then PermissionSuccessState when event is added",
        () {
      // Given
      final expectedResult = [
        PermissionLoadingState(),
        PermissionSuccessState(
            permissions: testPermissions, permissionInitiallyLoaded: false)
      ];
      when(mockPermissionRepo.observeAllPermissions()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Permissions>>.fromIterable(
              [right(testPermissions)]));
      // Then
      expectLater(permissionCubit.stream, emitsInOrder(expectedResult));
      permissionCubit.observePermissions();
    });

    test(
        "should emit PermissionLoadingState and then PermissionFailureState when event is added",
        () {
      // Given
      final expectedResult = [
        PermissionLoadingState(),
        PermissionFailureState(failure: BackendFailure())
      ];
      when(mockPermissionRepo.observeAllPermissions()).thenAnswer((_) =>
          Stream<Either<DatabaseFailure, Permissions>>.fromIterable(
              [left(BackendFailure())]));
      // Then
      expectLater(permissionCubit.stream, emitsInOrder(expectedResult));
      permissionCubit.observePermissions();
    });
  });
}
