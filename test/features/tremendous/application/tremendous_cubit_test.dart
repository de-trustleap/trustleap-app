import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/tremendous/application/tremendous_cubit.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_organization.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late TremendousCubit cubit;
  late MockTremendousRepository mockRepo;

  const org = TremendousOrganization(id: "org1", name: "Test Org");
  const products = [
    TremendousProduct(id: "p1", name: "Gift Card", category: "GIFT_CARDS"),
  ];
  const fundingSources = [
    TremendousFundingSource(id: "fs1", method: "US_ACH"),
  ];

  setUp(() {
    mockRepo = MockTremendousRepository();
    cubit = TremendousCubit(mockRepo);
  });

  tearDown(() => cubit.close());

  test("initial state is TremendousInitial", () {
    expect(cubit.state, isA<TremendousInitial>());
  });

  group("TremendousCubit_connect", () {
    test("emits TremendousConnectingState then TremendousOAuthReadyState on success",
        () async {
      // Given
      when(mockRepo.getAuthorizationUrl())
          .thenAnswer((_) async => right("https://auth.example.com/oauth"));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousConnectingState>(),
        isA<TremendousOAuthReadyState>()
            .having((s) => s.authUrl, 'authUrl', "https://auth.example.com/oauth"),
      ]));
      // When
      cubit.connect();
    });

    test("emits TremendousConnectingState then TremendousConnectionFailureState on failure",
        () async {
      // Given
      when(mockRepo.getAuthorizationUrl())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousConnectingState>(),
        isA<TremendousConnectionFailureState>(),
      ]));
      // When
      cubit.connect();
    });
  });

  group("TremendousCubit_disconnect", () {
    test("emits TremendousDisconnectedState on success", () async {
      // Given
      when(mockRepo.disconnect()).thenAnswer((_) async => right(unit));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousDisconnectedState>()));
      // When
      cubit.disconnect();
    });

    test("emits TremendousConnectionFailureState on failure", () async {
      // Given
      when(mockRepo.disconnect()).thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousConnectionFailureState>()));
      // When
      cubit.disconnect();
    });
  });

  group("TremendousCubit_startObservingConnectionStatus", () {
    test("emits TremendousConnectedState when connected and org loads successfully",
        () async {
      // Given
      when(mockRepo.observeConnectionStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockRepo.getOrganization())
          .thenAnswer((_) async => right(org));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousConnectedState>()
            .having((s) => s.organization, 'organization', org),
      ]));
      // When
      cubit.startObservingConnectionStatus();
    });

    test("emits TremendousNotConnectedState when not connected", () async {
      // Given
      when(mockRepo.observeConnectionStatus())
          .thenAnswer((_) => Stream.value(right(false)));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousNotConnectedState>()));
      // When
      cubit.startObservingConnectionStatus();
    });

    test("emits TremendousConnectionFailureState when stream emits failure",
        () async {
      // Given
      when(mockRepo.observeConnectionStatus())
          .thenAnswer((_) => Stream.value(left(BackendFailure())));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousConnectionFailureState>()));
      // When
      cubit.startObservingConnectionStatus();
    });

    test("emits TremendousConnectionFailureState on stream error", () async {
      // Given
      when(mockRepo.observeConnectionStatus())
          .thenAnswer((_) => Stream.error(Exception("network error")));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousConnectionFailureState>()));
      // When
      cubit.startObservingConnectionStatus();
    });

    test("emits TremendousConnectionFailureState when org load fails after connected",
        () async {
      // Given
      when(mockRepo.observeConnectionStatus())
          .thenAnswer((_) => Stream.value(right(true)));
      when(mockRepo.getOrganization())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emits(isA<TremendousConnectionFailureState>()));
      // When
      cubit.startObservingConnectionStatus();
    });
  });

  group("TremendousCubit_loadCatalog", () {
    test("emits TremendousCatalogLoadingState then TremendousCatalogSuccessState on success",
        () async {
      // Given
      when(mockRepo.getProductList())
          .thenAnswer((_) async => right(products));
      when(mockRepo.getFundingSourcesList())
          .thenAnswer((_) async => right(fundingSources));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousCatalogLoadingState>(),
        isA<TremendousCatalogSuccessState>()
            .having((s) => s.products, 'products', products)
            .having((s) => s.fundingSources, 'fundingSources', fundingSources),
      ]));
      // When
      cubit.loadCatalog();
    });

    test("emits TremendousCatalogLoadingState then TremendousCatalogFailureState when products fail",
        () async {
      // Given
      when(mockRepo.getProductList())
          .thenAnswer((_) async => left(BackendFailure()));
      when(mockRepo.getFundingSourcesList())
          .thenAnswer((_) async => right(fundingSources));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousCatalogLoadingState>(),
        isA<TremendousCatalogFailureState>(),
      ]));
      // When
      cubit.loadCatalog();
    });

    test("emits TremendousCatalogLoadingState then TremendousCatalogFailureState when funding sources fail",
        () async {
      // Given
      when(mockRepo.getProductList())
          .thenAnswer((_) async => right(products));
      when(mockRepo.getFundingSourcesList())
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(cubit.stream, emitsInOrder([
        isA<TremendousCatalogLoadingState>(),
        isA<TremendousCatalogFailureState>(),
      ]));
      // When
      cubit.loadCatalog();
    });
  });

  group("TremendousCubit_reset", () {
    test("emits TremendousInitial", () async {
      // Given - put cubit in non-initial state first
      when(mockRepo.disconnect()).thenAnswer((_) async => right(unit));
      await cubit.disconnect();
      // Then
      expectLater(cubit.stream, emits(isA<TremendousInitial>()));
      // When
      cubit.reset();
    });
  });
}
