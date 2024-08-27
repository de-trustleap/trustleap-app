import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UserModel_CopyWith", () {
    test("set email with copyWith should change email for resulting object",
        () {
      // Given
      const user = UserModel(
          id: "1",
          firstName: "Max",
          lastName: "Mustermann",
          email: "tester@test.de");
      const expectedResult = UserModel(
          id: "1",
          firstName: "Max",
          lastName: "Mustermann",
          email: "testernew@test.de");
      // When
      final result = user.copyWith(email: "testernew@test.de");
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = UserModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          parentUserID: null,
          companyID: "2",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      final expectedResult = {
        "id": "1",
        "gender": "male",
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "address": null,
        "postCode": "41542",
        "place": "Test",
        "email": "tester@test.de",
        "parentUserID": null,
        "companyID": "2",
        "landingPageIDs": ["id"],
        "profileImageDownloadURL": "https://test.de",
        "thumbnailDownloadURL": "https://thumb.de",
        "pendingCompanyRequestID": null,
        "defaultLandingPageID": null,
        "registeredPromoterIDs": ["id"],
        "unregisteredPromoterIDs": ["id"],
        "deletesAt": null,
        "lastUpdated": null,
        "createdAt": Timestamp(100000, 0)
      };
      // When
      final result = model.toMap();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "gender": "male",
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "address": null,
        "postCode": "41542",
        "place": "Test",
        "email": "tester@test.de",
        "profileImageDownloadURL": "https://test.de",
        "thumbnailDownloadURL": "https://thumb.de",
        "landingPageIDs": ["id"],
        "registeredPromoterIDs": ["id"],
        "unregisteredPromoterIDs": ["id"],
        "createdAt": Timestamp(100000, 0)
      };
      final expectedResult = UserModel(
          id: "",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = UserModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_ToDomain", () {
    test("check if conversion from UserModel to CustomUser works", () {
      // Given
      final model = UserModel(
          id: "1",
          gender: null,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      final expectedResult = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.none,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"]);
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_FromDomain", () {
    test("check if conversion from CustomUser to UserModel works", () {
      // Given
      final user = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"]);
      final expectedResult = UserModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = UserModel.fromDomain(user);
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "",
        "gender": null,
        "firstName": "Max",
        "lastName": "Mustermann",
        "birthDate": "23.12.2023",
        "address": null,
        "postCode": "41542",
        "place": "Test",
        "email": "tester@test.de",
        "profileImageDownloadURL": "https://test.de",
        "thumbnailDownloadURL": "https://thumb.de",
        "landingPageIDs": ["id"],
        "registeredPromoterIDs": ["id"],
        "unregisteredPromoterIDs": ["id"],
        "createdAt": Timestamp(100000, 0)
      };
      final expectedResult = UserModel(
          id: "1",
          gender: "none",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = UserModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("UserModel_Props", () {
    test("check if value equality works", () {
      // Given
      final user1 = UserModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      final user2 = UserModel(
          id: "1",
          gender: "male",
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          address: null,
          postCode: "41542",
          place: "Test",
          email: "tester@test.de",
          profileImageDownloadURL: "https://test.de",
          thumbnailDownloadURL: "https://thumb.de",
          landingPageIDs: const ["id"],
          registeredPromoterIDs: const ["id"],
          unregisteredPromoterIDs: const ["id"],
          createdAt: Timestamp(100000, 0));
      // Then
      expect(user1, user2);
    });
  });
}
