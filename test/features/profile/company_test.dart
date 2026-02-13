import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Company_CopyWith", () {
    test(
        "set name and industry with copyWith should set name and industry for resulting object",
        () {
      // Given
      final company = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          industry: "TestIndustry",
          websiteURL: "https://trust-leap.de");

      final expectedResult = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "TestNew",
          industry: "TestIndustryNew",
          websiteURL: "https://trust-leap.de");
      // When
      final result =
          company.copyWith(name: "TestNew", industry: "TestIndustryNew");
      // Then
      expect(result, expectedResult);
    });
  });

  group("Company_Props", () {
    test("check if value equality works", () {
      // Given
      final company1 = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          industry: "TestIndustry",
          websiteURL: "https://trust-leap.de",
          address: "TestAddress",
          postCode: "40231",
          place: "TestPlace",
          phoneNumber: "123456789",
          companyImageDownloadURL: "https://download.de",
          thumbnailDownloadURL: "https://download-thumb.de",
          employeeIDs: const ["1", "2"]);

      final company2 = Company(
          id: UniqueID.fromUniqueString("1"),
          name: "Test",
          industry: "TestIndustry",
          websiteURL: "https://trust-leap.de",
          address: "TestAddress",
          postCode: "40231",
          place: "TestPlace",
          phoneNumber: "123456789",
          companyImageDownloadURL: "https://download.de",
          thumbnailDownloadURL: "https://download-thumb.de",
          employeeIDs: const ["1", "2"]);
      // Then
      expect(company1, company2);
    });
  });
}
