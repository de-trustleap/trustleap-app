import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_recommendor_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UnregisteredRecommendorModel_CopyWith", () {
    test(
        "set lastName with copyWith should change lastName for resulting object",
        () {
      // Given
      const user = UnregisteredRecommendorModel(
          id: "1", firstName: "Max", lastName: "Mustermann");
      const expectedResult = UnregisteredRecommendorModel(
          id: "1", firstName: "Max", lastName: "Neumann");
      // WHen
      final result = user.copyWith(lastName: "Neumann");
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendorModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = UnregisteredRecommendorModel(
          id: "1",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          createdAt: Timestamp(1000000, 0));
      final expectedResult = {
        "id": "1",
        "gender": null,
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "email": "tester@test.de",
        "parentUserID": "2",
        "code": "1234",
        "createdAt": Timestamp(1000000, 0)
      };
      // When
      final result = model.toMap();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendorModel_FromMap", () {
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
        "createdAt": Timestamp(1000000, 0)
      };
      final expectedResult = UnregisteredRecommendorModel(
          id: "",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          createdAt: Timestamp(1000000, 0));
      // When
      final result = UnregisteredRecommendorModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendorModel_ToDomain", () {
    test(
        "check if conversion from UnregisteredRecommendorModel to UnregisteredRecommendor works",
        () {
      //Given
      final model = UnregisteredRecommendorModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          createdAt: Timestamp(1000000, 0));
      final expectedResult = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendorModel_FromDomain", () {
    test(
        "check if conversion from UnregisteredRecommendor to UnregisteredRecommendorModel works",
        () {
      // Given
      final user = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));
      const expectedResult = UnregisteredRecommendorModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          parentUserID: "2",
          code: "1234");
      // When
      final result = UnregisteredRecommendorModel.fromDomain(user);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendorModel_Props", () {
    test("check if value equality works", () {
      // Given
      final user1 = UnregisteredRecommendorModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          createdAt: Timestamp(10000, 0));
      final user2 = UnregisteredRecommendorModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: "2",
          code: "1234",
          createdAt: Timestamp(10000, 0));
      // Then
      expect(user1, user2);
    });
  });
}
