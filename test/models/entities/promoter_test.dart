import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Promoter_CopyWith", () {
    test(
        "set lastName and firstName with copyWith should set lastName and firstName for resulting object",
        () {
      // Given
      final promoter = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de",
          registered: false,
          expiresAt: DateTime.now(),
          createdAt: null);

      final expectedResult = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test1",
          lastName: "Test2",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de",
          registered: false,
          expiresAt: DateTime.now(),
          createdAt: null);
      // When
      final result = promoter.copyWith(firstName: "Test1", lastName: "Test2");
      // Then
      expect(expectedResult, result);
    });
  });

  group("Promoter_FromUser", () {
    test("test if fromUser returns correct Promoter", () {
      // Given
      final date = DateTime.now();
      final user = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.female,
          firstName: "Test",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://test.de/thumb",
          unregisteredPromoterIDs: const ["4", "5"],
          registeredPromoterIDs: const ["3", "2"],
          createdAt: date);

      final expectedResult = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.female,
          firstName: "Test",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de/thumb",
          registered: true,
          expiresAt: null,
          createdAt: date);
      // When
      final result = Promoter.fromUser(user);
      // Then
      expect(expectedResult, result);
    });
  });

  group("Promoter_FromUnregisteredUser", () {
    test("test if fromUnregisteredUser returns correct promoter", () {
      // Given
      final date = DateTime.now();
      final unregisteredPromoter = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test",
          lastName: "Test",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"),
          expiresAt: date);

      final expectedResult = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test",
          lastName: "Test",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: null,
          registered: false,
          expiresAt: date,
          createdAt: null);
      // When
      final result = Promoter.fromUnregisteredPromoter(unregisteredPromoter);
      // Then
      expect(expectedResult, result);
    });
  });

  group("Promoter_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime.now();
      final promoter1 = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.female,
          firstName: "Test",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de/thumb",
          registered: true,
          expiresAt: null,
          createdAt: date);

      final promoter2 = Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.female,
          firstName: "Test",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de/thumb",
          registered: true,
          expiresAt: null,
          createdAt: date);
      // Then
      expect(promoter1, promoter2);
    });
  });
}
