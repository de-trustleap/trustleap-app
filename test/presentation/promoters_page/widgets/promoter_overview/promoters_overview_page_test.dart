library;

import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/no_search_results_view.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_grid.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_list.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';

import '../../../../mocks.mocks.dart';

class PromotersOverviewPageTestModule extends Module {
  final PromoterCubit promoterCubit;
  final PromoterObserverCubit promoterObserverCubit;
  final UserObserverCubit userObserverCubit;
  final PermissionCubit permissionCubit;

  PromotersOverviewPageTestModule({
    required this.promoterCubit,
    required this.promoterObserverCubit,
    required this.userObserverCubit,
    required this.permissionCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<PromoterCubit>(() => promoterCubit);
    i.addSingleton<PromoterObserverCubit>(() => promoterObserverCubit);
    i.addSingleton<UserObserverCubit>(() => userObserverCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
  }
}

void main() {
  late PromoterCubit promoterCubit;
  late PromoterObserverCubit promoterObserverCubit;
  late UserObserverCubit userObserverCubit;
  late PermissionCubit permissionCubit;
  late MockPromoterRepository mockPromoterRepository;
  late MockLandingPageRepository mockLandingPageRepository;
  late MockUserRepository mockUserRepository;
  late MockPermissionRepository mockPermissionRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<PromoterState>(PromoterInitial());
    provideDummy<PromoterObserverState>(PromoterObserverInitial());
    provideDummy<UserObserverState>(UserObserverInitial());
    provideDummy<PermissionState>(PermissionInitial());

    mockPromoterRepository = MockPromoterRepository();
    mockLandingPageRepository = MockLandingPageRepository();
    mockUserRepository = MockUserRepository();
    mockPermissionRepository = MockPermissionRepository();

    // Setup mock to return stream that never completes by default (stays in loading)
    when(mockPromoterRepository.observePromotersByIds(
      registeredIds: anyNamed('registeredIds'),
      unregisteredIds: anyNamed('unregisteredIds'),
    )).thenAnswer((_) => const Stream.empty());

    promoterCubit = PromoterCubit(mockPromoterRepository, mockLandingPageRepository);
    promoterObserverCubit = PromoterObserverCubit(mockPromoterRepository);
    userObserverCubit = UserObserverCubit(mockUserRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    promoterCubit.close();
    promoterObserverCubit.close();
    userObserverCubit.close();
    permissionCubit.close();
  });

  Promoter createTestPromoter({
    String? id,
    String? firstName,
    String? lastName,
    bool? registered,
  }) {
    return Promoter(
      id: UniqueID.fromUniqueString(id ?? 'test-promoter-123'),
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      email: 'john.doe@example.com',
      registered: registered ?? true,
    );
  }

  CustomUser createTestUser({
    List<String>? registeredPromoterIDs,
    List<String>? unregisteredPromoterIDs,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      companyID: 'company-123',
      role: Role.company,
      registeredPromoterIDs: registeredPromoterIDs,
      unregisteredPromoterIDs: unregisteredPromoterIDs,
    );
  }

  CustomUser createTestUserWithNoPromoters() {
    // User with no promoter IDs -> will immediately emit PromotersObserverSuccess([])
    return createTestUser();
  }

  CustomUser createTestUserWithPromoters() {
    // User with promoter IDs -> will subscribe to stream and wait for data
    return createTestUser(registeredPromoterIDs: ['promoter-1']);
  }

  Permissions createTestPermissions({bool showPromoterMenu = true}) {
    return Permissions(
      permissions: {
        'showPromoterMenu': showPromoterMenu,
        'showPromoterDetails': true,
        'registerPromoter': true,
        'deletePromoter': true,
        'editPromoter': true,
      },
    );
  }

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = PromotersOverviewPageTestModule(
      promoterCubit: promoterCubit,
      promoterObserverCubit: promoterObserverCubit,
      userObserverCubit: userObserverCubit,
      permissionCubit: permissionCubit,
    );

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
        child: MaterialApp(
          locale: const Locale('de'), // Force German locale in tests
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: PromotersOverviewPage(),
          ),
        ),
      ),
    );
  }

  group('PromotersOverviewPage Widget Tests', () {
    testWidgets('should create PromotersOverviewPage widget', (tester) async {
      // Given
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));
      promoterObserverCubit.emit(PromoterObserverInitial());

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(PromotersOverviewPage), findsOneWidget);
    });

    testWidgets('should display LoadingIndicator when observer is in initial state',
        (tester) async {
      // Given - user with promoter IDs so stream is subscribed (not immediately success)
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUserWithPromoters()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then - since Stream.empty() doesn't emit, cubit stays in loading state
      // and else clause (line 268-270) shows LoadingIndicator
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets(
        'should display LoadingIndicator when PromoterCubit is loading',
        (tester) async {
      // Given
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      promoterCubit.emit(PromoterLoadingState());
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('should display EmptyPage when no promoters exist',
        (tester) async {
      // Given - user with no promoter IDs -> immediately emits PromotersObserverSuccess([])
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUserWithNoPromoters()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Wait for PromotersObserverSuccess to trigger getPromoters
      await tester.pump();

      // Then - empty list triggers EmptyPage
      expect(find.byType(EmptyPage), findsOneWidget);
    });

    testWidgets('should display ErrorView when observer fails', (tester) async {
      // Given
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - emit failure after widget is built
      promoterObserverCubit.emit(PromotersObserverFailure(failure: BackendFailure()));
      await tester.pump();

      // Then
      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('should display NoSearchResultsView when search has no results',
        (tester) async {
      // Given
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - emit search not found after widget is built
      promoterObserverCubit.emit(PromotersObserverSearchNotFound());
      await tester.pump();

      // Then
      expect(find.byType(NoSearchResultsView), findsOneWidget);
    });

    testWidgets('should display PromoterOverviewHeader when promoters exist',
        (tester) async {
      // Given
      final testPromoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - emit promoters after widget is built
      promoterObserverCubit.emit(PromotersObserverGetElementsSuccess(promoters: [testPromoter]));
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewHeader), findsOneWidget);
    });

    testWidgets('should display PromoterOverviewGrid by default',
        (tester) async {
      // Given
      final testPromoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - emit promoters after widget is built
      promoterObserverCubit.emit(PromotersObserverGetElementsSuccess(promoters: [testPromoter]));
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewGrid), findsOneWidget);
      expect(find.byType(PromoterOverviewList), findsNothing);
    });

    testWidgets('should switch to PromoterOverviewList when view state changes',
        (tester) async {
      // Given
      final testPromoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUser()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Emit promoters after widget is built
      promoterObserverCubit.emit(PromotersObserverGetElementsSuccess(promoters: [testPromoter]));
      await tester.pump();

      // When - find and tap the list view button in the header
      final listButton = find.byIcon(Icons.format_list_bulleted);
      await tester.tap(listButton);
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewList), findsOneWidget);
      expect(find.byType(PromoterOverviewGrid), findsNothing);
    });
  });

  group('PromotersOverviewPage State Management Tests', () {
    testWidgets('should observe promoters when user state changes',
        (tester) async {
      // Given
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      promoterObserverCubit.emit(PromoterObserverInitial());

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - emit user with promoter IDs so observePromotersByIds gets called
      userObserverCubit.emit(UserObserverSuccess(user: createTestUserWithPromoters()));
      await tester.pump();
      await tester.pump(); // Additional pump for BlocListener to trigger

      // Then
      verify(mockPromoterRepository.observePromotersByIds(
        registeredIds: anyNamed('registeredIds'),
        unregisteredIds: anyNamed('unregisteredIds'),
      )).called(greaterThan(0));
    });

    testWidgets('should handle PromoterDeleteSuccessState', (tester) async {
      // Given
      final testPromoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUserWithPromoters()));
      promoterObserverCubit
          .emit(PromotersObserverGetElementsSuccess(promoters: [testPromoter]));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      promoterCubit.emit(PromoterDeleteSuccessState());
      await tester.pump(); // Trigger the state change

      // Then - check that success snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);

      // Verify the snackbar contains success message in German
      expect(find.text('Promoter erfolgreich gelöscht!'), findsOneWidget);
    });

    testWidgets('should handle PromoterDeleteFailureState', (tester) async {
      // Given
      final testPromoter = createTestPromoter();
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));
      userObserverCubit.emit(UserObserverSuccess(user: createTestUserWithPromoters()));
      promoterObserverCubit
          .emit(PromotersObserverGetElementsSuccess(promoters: [testPromoter]));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      promoterCubit.emit(PromoterDeleteFailureState(failure: BackendFailure()));
      await tester.pump(); // Trigger the state change

      // Then - check that error snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);

      // Verify the snackbar contains failure message in German
      expect(find.text('Promoter löschen fehlgeschlagen!'), findsOneWidget);
    });
  });
}
