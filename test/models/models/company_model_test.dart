import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/infrastructure/models/company_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CompanyModel_CopyWith", () {
    test("set website with copyWith should set website for resulting object",
        () {
      // Given
      const company = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789");
      const expectedResult = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de");
      // When
      final result = company.copyWith(websiteURL: "https://trust-leap.de");
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          ownerID: "5",
          defaultLandingPageID: "3",
          createdAt: Timestamp(100000, 0));

      final expectedResult = {
        "id": "1",
        "name": "Test",
        "industry": "TestIndustry",
        "phoneNumber": "123456789",
        "websiteURL": "https://trust-leap.de",
        "address": "Teststreet 5",
        "postCode": "40231",
        "place": "Testplace",
        "companyImageDownloadURL": "testURL",
        "thumbnailDownloadURL": "testURL",
        "employeeIDs": ["5"],
        "ownerID": "5",
        "defaultLandingPageID": "3",
        "createdAt": Timestamp(100000, 0),
        "avvData": null
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "name": "Test",
        "industry": "TestIndustry",
        "phoneNumber": "123456789",
        "websiteURL": "https://trust-leap.de",
        "address": "Teststreet 5",
        "postCode": "40231",
        "place": "Testplace",
        "companyImageDownloadURL": "testURL",
        "thumbnailDownloadURL": "testURL",
        "employeeIDs": ["5"],
        "createdAt": Timestamp(100000, 0)
      };
      final expectedResult = CompanyModel(
          id: "",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = CompanyModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("CompanyModel_ToDomain", () {
    test("check if conversion from CompanyModel to Company works", () {
      // Given
      final model = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));

      final expectedResult = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"]);

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("CompanyModel_FromDomain", () {
    test("check if conversion from Company to CompanyModel works", () {
      // Given
      final company = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"]);
      final expectedResult = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = CompanyModel.fromDomain(company);
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyModel_FromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "",
        "name": "Test",
        "industry": "TestIndustry",
        "phoneNumber": "123456789",
        "websiteURL": "https://trust-leap.de",
        "address": "Teststreet 5",
        "postCode": "40231",
        "place": "Testplace",
        "companyImageDownloadURL": "testURL",
        "thumbnailDownloadURL": "testURL",
        "employeeIDs": ["5"],
        "createdAt": Timestamp(100000, 0)
      };
      final expectedResult = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));
      // When
      final result = CompanyModel.fromFirestore(map, "1");
      // Then
      expect(expectedResult, result);
    });
  });

  group("CompanyModel_Props", () {
    test("check if value equality works", () {
      // Given
      final company1 = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));
      final company2 = CompanyModel(
          id: "1",
          name: "Test",
          industry: "TestIndustry",
          phoneNumber: "123456789",
          websiteURL: "https://trust-leap.de",
          address: "Teststreet 5",
          postCode: "40231",
          place: "Testplace",
          companyImageDownloadURL: "testURL",
          thumbnailDownloadURL: "testURL",
          employeeIDs: const ["5"],
          createdAt: Timestamp(100000, 0));
      // Then
      expect(company1, company2);
    });
  });
}
