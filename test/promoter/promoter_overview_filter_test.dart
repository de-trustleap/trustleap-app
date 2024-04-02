import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_overview_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PromoterOverviewFilter sut;

  setUp(() {
    sut = PromoterOverviewFilter();
  });

  group("PromoterOverviewFilter_OnFilterChanged", () {
    final date = DateTime.now();
    final List<Promoter> searchResults = [
      Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de",
          registered: false,
          expiresAt: date,
          createdAt: null),
      Promoter(
          id: UniqueID.fromUniqueString("2"),
          gender: Gender.female,
          firstName: "Test2",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester2@test.de",
          thumbnailDownloadURL: "https://test2.de",
          registered: true,
          createdAt: date),
      Promoter(
          id: UniqueID.fromUniqueString("3"),
          gender: Gender.male,
          firstName: "Test3",
          birthDate: "23.12.2023",
          email: "tester3@test.de",
          thumbnailDownloadURL: "https://test3.de",
          registered: true,
          createdAt: date)
    ];
    test(
        "should return registered users when filter is configured to show registered users",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.registrationFilterState =
          PromoterRegistrationFilterState.registered;
      const expectedResult = 2;
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(result.length, expectedResult);
    });

    test(
        "should return unregistered users when filter is configured to show unregistered users",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.registrationFilterState =
          PromoterRegistrationFilterState.unregistered;
      const expectedResult = 1;
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(result.length, expectedResult);
    });

    test("should return all users when filter is configured to show all users",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.registrationFilterState = PromoterRegistrationFilterState.all;
      const expectedResult = 3;
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(result.length, expectedResult);
    });

    test(
        "should return all users with email in ascending order when filter is configured to do so",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.sortByFilterState = PromoterSortByFilterState.email;
      filter.sortOrderFilterState = PromoterSortOrderFilterState.asc;
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("2"),
            gender: Gender.female,
            firstName: "Test2",
            birthDate: "23.12.2023",
            email: "tester2@test.de",
            thumbnailDownloadURL: "https://test2.de",
            registered: true,
            createdAt: date),
        Promoter(
            id: UniqueID.fromUniqueString("3"),
            gender: Gender.male,
            firstName: "Test3",
            birthDate: "23.12.2023",
            email: "tester3@test.de",
            thumbnailDownloadURL: "https://test3.de",
            registered: true,
            createdAt: date),
        Promoter(
            id: UniqueID.fromUniqueString("1"),
            gender: Gender.male,
            firstName: "Test",
            birthDate: "23.12.2023",
            email: "tester@test.de",
            thumbnailDownloadURL: "https://test.de",
            registered: false,
            expiresAt: date,
            createdAt: null)
      ];
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(expectedResult, result);
    });

    test(
        "should return all users with email in descending order when filter is configured to do so",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.sortByFilterState = PromoterSortByFilterState.email;
      filter.sortOrderFilterState = PromoterSortOrderFilterState.desc;
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("1"),
            gender: Gender.male,
            firstName: "Test",
            birthDate: "23.12.2023",
            email: "tester@test.de",
            thumbnailDownloadURL: "https://test.de",
            registered: false,
            expiresAt: date,
            createdAt: null),
        Promoter(
            id: UniqueID.fromUniqueString("3"),
            gender: Gender.male,
            firstName: "Test3",
            birthDate: "23.12.2023",
            email: "tester3@test.de",
            thumbnailDownloadURL: "https://test3.de",
            registered: true,
            createdAt: date),
        Promoter(
            id: UniqueID.fromUniqueString("2"),
            gender: Gender.female,
            firstName: "Test2",
            birthDate: "23.12.2023",
            email: "tester2@test.de",
            thumbnailDownloadURL: "https://test2.de",
            registered: true,
            createdAt: date),
      ];
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(expectedResult, result);
    });

    test(
        "should return only registered users with firstName in descending order when filter is configured to do so",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.registrationFilterState =
          PromoterRegistrationFilterState.registered;
      filter.sortByFilterState = PromoterSortByFilterState.firstName;
      filter.sortOrderFilterState = PromoterSortOrderFilterState.desc;
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("3"),
            gender: Gender.male,
            firstName: "Test3",
            birthDate: "23.12.2023",
            email: "tester3@test.de",
            thumbnailDownloadURL: "https://test3.de",
            registered: true,
            createdAt: date),
        Promoter(
            id: UniqueID.fromUniqueString("2"),
            gender: Gender.female,
            firstName: "Test2",
            birthDate: "23.12.2023",
            email: "tester2@test.de",
            thumbnailDownloadURL: "https://test2.de",
            registered: true,
            createdAt: date),
      ];
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(expectedResult, result);
    });

    test(
        "should return only unregistered users with firstName in ascending order when filter is configured to do so",
        () {
      // Given
      final filter = PromoterOverviewFilterStates();
      filter.registrationFilterState =
          PromoterRegistrationFilterState.unregistered;
      filter.sortByFilterState = PromoterSortByFilterState.firstName;
      filter.sortOrderFilterState = PromoterSortOrderFilterState.asc;
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("1"),
            gender: Gender.male,
            firstName: "Test",
            birthDate: "23.12.2023",
            email: "tester@test.de",
            thumbnailDownloadURL: "https://test.de",
            registered: false,
            expiresAt: date,
            createdAt: null)
      ];
      // When
      final result = sut.onFilterChanged(filter, searchResults);
      // Then
      expect(expectedResult, result);
    });
  });

  group("PromoterOverviewFilter_OnSearchQueryChanged", () {
    final date = DateTime.now();
    final List<Promoter> allPromoters = [
      Promoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Test",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          thumbnailDownloadURL: "https://test.de",
          registered: false,
          expiresAt: date,
          createdAt: null),
      Promoter(
          id: UniqueID.fromUniqueString("2"),
          gender: Gender.female,
          firstName: "Test2",
          lastName: "Tester",
          birthDate: "23.12.2023",
          email: "tester2@test.de",
          thumbnailDownloadURL: "https://test2.de",
          registered: true,
          createdAt: date),
      Promoter(
          id: UniqueID.fromUniqueString("3"),
          gender: Gender.male,
          firstName: "Test3",
          birthDate: "23.12.2023",
          email: "tester3@test.de",
          thumbnailDownloadURL: "https://test3.de",
          registered: true,
          createdAt: date)
    ];
    test("should return promoter with firstName = Test2 when query is Test2",
        () {
      // Given
      const query = "Test2";
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("2"),
            gender: Gender.female,
            firstName: "Test2",
            lastName: "Tester",
            birthDate: "23.12.2023",
            email: "tester2@test.de",
            thumbnailDownloadURL: "https://test2.de",
            registered: true,
            createdAt: date)
      ];
      // When
      final result = sut.onSearchQueryChanged(query, allPromoters);
      // Then
      expect(expectedResult, result);
    });

    test("should ignore element when lastName is null", () {
      // Given
      const query = "Test3";
      final List<Promoter> expectedResult = [];
      // When
      final result = sut.onSearchQueryChanged(query, allPromoters);
      // Then
      expect(expectedResult, result);
    });

    test(
        "should return only the element where lastName is set when query is Test",
        () {
      // Given
      const query = "Test";
      final List<Promoter> expectedResult = [
        Promoter(
            id: UniqueID.fromUniqueString("2"),
            gender: Gender.female,
            firstName: "Test2",
            lastName: "Tester",
            birthDate: "23.12.2023",
            email: "tester2@test.de",
            thumbnailDownloadURL: "https://test2.de",
            registered: true,
            createdAt: date)
      ];
      // When
      final result = sut.onSearchQueryChanged(query, allPromoters);
      // Then
      expect(expectedResult, result);
    });
  });
}
