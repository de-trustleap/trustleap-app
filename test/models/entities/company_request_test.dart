import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CompanyRequest_CopyWith", () {
    test(
        "set company and userID with copyWith should set company and userID for resulting object",
        () {
      // Given
      final companyRequest = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("1"),
              name: "Test AG",
              industry: "Test"),
          userID: UniqueID.fromUniqueString("1"));

      final expectedResult = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("2"),
              name: "Test AG 2",
              industry: "Test"),
          userID: UniqueID.fromUniqueString("2"));
      // When
      final result = companyRequest.copyWith(
          company: Company(
              id: UniqueID.fromUniqueString("2"),
              name: "Test AG 2",
              industry: "Test"),
          userID: UniqueID.fromUniqueString("2"));
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyRequest_props", () {
    test("check if value equality works", () {
      // Given
      final companyRequest1 = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("1"),
              name: "Test AG",
              industry: "Test"),
          userID: UniqueID.fromUniqueString("1"));
      final companyRequest2 = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("1"),
              name: "Test AG",
              industry: "Test"),
          userID: UniqueID.fromUniqueString("1"));
      // Then
      expect(companyRequest1, companyRequest2);
    });
  });
}
