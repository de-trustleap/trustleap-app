import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = DateTime.now();
  group("UnregisteredPromoterModel_CopyWith", () {
    test(
        "set lastName with copyWith should change lastName for resulting object",
        () {
      // Given
      final user = UnregisteredPromoterModel(
          id: "1", firstName: "Max", lastName: "Mustermann", expiresAt: date);
      final expectedResult = UnregisteredPromoterModel(
          id: "1", firstName: "Max", lastName: "Neumann", expiresAt: date);
      // WHen
      final result = user.copyWith(lastName: "Neumann");
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = UnregisteredPromoterModel(
          id: "1",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(1000000, 0));
      final expectedResult = {
        "id": "1",
        "gender": null,
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "email": "tester@test.de",
        "additionalInfo": null,
        "parentUserID": "2",
        "code": "1234",
        "expiresAt": date,
        "createdAt": Timestamp(1000000, 0)
      };
      // When
      final result = model.toMap();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "gender": null,
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "email": "tester@test.de",
        "parentUserID": "2",
        "code": "1234",
        "expiresAt": Timestamp(1000000, 0),
        "createdAt": Timestamp(1000000, 0)
      };
      final expectedResult = UnregisteredPromoterModel(
          id: "",
          gender: "none",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(1000000, 0));
      // When
      final result = UnregisteredPromoterModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_ToDomain", () {
    test(
        "check if conversion from UnregisteredPromoterModel to UnregisteredPromoter works",
        () {
      //Given
      final model = UnregisteredPromoterModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(1000000, 0));
      final expectedResult = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"),
          expiresAt: date);
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_FromDomain", () {
    test(
        "check if conversion from UnregisteredPromoter to UnregisteredPromoterModel works",
        () {
      // Given
      final user = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"),
          expiresAt: date);
      final expectedResult = UnregisteredPromoterModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          parentUserID: "2",
          code: "1234",
          expiresAt: date);
      // When
      final result = UnregisteredPromoterModel.fromDomain(user);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "",
        "gender": null,
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "email": "tester@test.de",
        "parentUserID": "2",
        "code": "1234",
        "expiresAt": Timestamp(1000000, 0),
        "createdAt": Timestamp(1000000, 0)
      };
      final expectedResult = UnregisteredPromoterModel(
          id: "1",
          gender: "none",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(1000000, 0));
      // When
      final result = UnregisteredPromoterModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoterModel_Props", () {
    test("check if value equality works", () {
      // Given
      final user1 = UnregisteredPromoterModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(10000, 0));
      final user2 = UnregisteredPromoterModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          expiresAt: date,
          createdAt: Timestamp(10000, 0));
      // Then
      expect(user1, user2);
    });
  });
}
