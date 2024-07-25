import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late UserCubit userCubit;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    userCubit = UserCubit(userRepo: mockUserRepo);
  });

  test("init state should be UserInitial", () {
    expect(userCubit.state, UserInitial());
  });

  group("UserCubit_CreateUser", () {
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        firstName: "Max",
        lastName: "Mustermann",
        address: "Teststreet 5",
        registeredPromoterIDs: const ["1"]);
    test("should call auth repo if event is added", () async {
      // Given
      when(mockUserRepo.createUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // When
      userCubit.createUser(testUser);
      await untilCalled(mockUserRepo.createUser(user: testUser));
      // Then
      verify(mockUserRepo.createUser(user: testUser));
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should emit UserLoading and UserSuccess when function is called", () async {
      // Given
      final expectedResult = [
        UserLoading(),
        UserSuccess()
      ];
      when(mockUserRepo.createUser(user: testUser))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(userCubit.stream, emitsInOrder(expectedResult));
      userCubit.createUser(testUser);
    });

    test(
        "should emit UserLoading and UserFailure when function is called and there was an error",
        () async {
      // Given
      final expectedResult = [
        UserLoading(),
        UserFailure(failure: BackendFailure()),
      ];
      when(mockUserRepo.createUser(user: testUser))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(userCubit.stream, emitsInOrder(expectedResult));
      userCubit.createUser(testUser);
    });
  });
}
