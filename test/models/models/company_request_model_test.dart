import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/features/admin/domain/company_request.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/company_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CompanyRequestModel_copyWith", () {
    test("set userID with copyWith should set userID for resulting object", () {
      // Given
      final companyRequest1 = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      final expectedResult = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "2",
          createdAt: Timestamp(100000000, 0));
      // When
      final result = companyRequest1.copyWith(userID: "2");
      // Then
      expect(expectedResult, result);
    });
  });

  group("CompanyRequestModel_toMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      final expectedResult = {
        "id": "1",
        "company": {"id": "1", "name": "Test AG", "industry": "Test"},
        "userID": "1",
        "createdAt": Timestamp(100000000, 0)
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyRequestModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "id": "1",
        "company": {"id": "1", "name": "Test AG", "industry": "Test"},
        "userID": "1",
        "createdAt": Timestamp(100000000, 0)
      };
      final expectedResult = CompanyRequestModel(
          id: "",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      // When
      final result = CompanyRequestModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("CompanyRequestModel_toDomain", () {
    test("check if conversion from CompanyRequestModel to CompanyRequest works",
        () {
      // Given
      final model = CompanyRequestModel(
          id: "1",
          company: {
            "id": "1",
            "name": "Test AG",
            "industry": "Test",
            "createdAt": Timestamp(100000000, 0)
          },
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      final expectedResult = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("1"),
              name: "Test AG",
              industry: "Test",
              createdAt: Timestamp(100000000, 0).toDate()),
          userID: UniqueID.fromUniqueString("1"),
          createdAt: Timestamp(100000000, 0).toDate());
      // When
      final result = model.toDomain();
      expect(result, expectedResult);
    });
  });

  group("CompanyRequestModel_fromDomain", () {
    test("check if conversion from CompanyRequest to CompanyRequestModel works",
        () async {
      // Given
      final companyRequest = CompanyRequest(
          id: UniqueID.fromUniqueString("1"),
          company: Company(
              id: UniqueID.fromUniqueString("1"),
              name: "Test AG",
              industry: "Test",
              createdAt: Timestamp(100000000, 0).toDate()),
          userID: UniqueID.fromUniqueString("1"),
          createdAt: Timestamp(100000000, 0).toDate());
      final expectedResult = CompanyRequestModel(
          id: "1",
          company: {
            "id": "1",
            "name": "Test AG",
            "industry": "Test",
            "createdAt": Timestamp(100000000, 0)
          },
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      // WHen
      final result = CompanyRequestModel.fromDomain(companyRequest);
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyRequestModel_fromFirestore", () {
    test("test if fromFirestore sets the id successfully", () {
      // Given
      final map = {
        "id": "1",
        "company": {"id": "1", "name": "Test AG", "industry": "Test"},
        "userID": "1",
        "createdAt": Timestamp(100000000, 0)
      };
      final expectedResult = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      // When
      final result = CompanyRequestModel.fromFirestore(map, "1");
      // Then
      expect(result, expectedResult);
    });
  });

  group("CompanyRequestModel_props", () {
    test("check if value equality works", () {
      // Given
      final companyRequest1 = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      final companyRequest2 = CompanyRequestModel(
          id: "1",
          company: const {"id": "1", "name": "Test AG", "industry": "Test"},
          userID: "1",
          createdAt: Timestamp(100000000, 0));
      // Then
      expect(companyRequest1, companyRequest2);
    });
  });
}
