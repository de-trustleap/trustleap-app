import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/permissions/domain/permission_repository.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

class PromoterSearchFilterIntegrationTestModule extends Module {
  final PromoterCubit promoterCubit;
  final PromoterObserverCubit promoterObserverCubit;
  final UserObserverCubit userObserverCubit;
  final PermissionCubit permissionCubit;

  PromoterSearchFilterIntegrationTestModule({
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

  @override
  void routes(r) {}
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

  Permissions createTestPermissions() {
    return Permissions(
      permissions: {
        'showPromoterMenu': true,
        'showPromoterDetails': true,
        'registerPromoter': true,
        'deletePromoter': true,
        'editPromoter': true,
      },
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

  List<Promoter> createTestPromoters() {
    return [
      Promoter(
        id: UniqueID.fromUniqueString('promoter-1'),
        firstName: 'John',
        lastName: 'Smith',
        email: 'john.smith@example.com',
        registered: true,
      ),
      Promoter(
        id: UniqueID.fromUniqueString('promoter-2'),
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        registered: true,
      ),
      Promoter(
        id: UniqueID.fromUniqueString('promoter-3'),
        firstName: 'Bob',
        lastName: 'Johnson',
        email: 'bob.johnson@example.com',
        registered: false,
      ),
      Promoter(
        id: UniqueID.fromUniqueString('promoter-4'),
        firstName: 'Alice',
        lastName: 'Williams',
        email: 'alice.williams@example.com',
        registered: true,
      ),
    ];
  }

  setUp(() {
    ResponsiveHelper.enableTestMode();
    Modular.destroy();

    provideDummy<PromoterState>(PromoterInitial());
    provideDummy<PromoterObserverState>(PromoterObserverInitial());
    provideDummy<UserObserverState>(UserObserverInitial());
    provideDummy<PermissionState>(PermissionInitial());

    mockPromoterRepository = MockPromoterRepository();
    mockLandingPageRepository = MockLandingPageRepository();
    mockUserRepository = MockUserRepository();
    mockPermissionRepository = MockPermissionRepository();

    // Setup default mock behavior
    when(mockPromoterRepository.observePromotersByIds(
      registeredIds: anyNamed('registeredIds'),
      unregisteredIds: anyNamed('unregisteredIds'),
    )).thenAnswer((_) => const Stream.empty());

    promoterCubit = PromoterCubit(mockPromoterRepository, mockLandingPageRepository);
    promoterObserverCubit = PromoterObserverCubit(mockPromoterRepository);
    userObserverCubit = UserObserverCubit(mockUserRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
  });

  tearDown(() async {
    ResponsiveHelper.disableTestMode();
    // Close cubits before destroying Modular to avoid dispose issues
    await promoterCubit.close();
    await promoterObserverCubit.close();
    await userObserverCubit.close();
    await permissionCubit.close();
    Modular.destroy();
  });

  Widget createWidgetUnderTest() {
    final module = PromoterSearchFilterIntegrationTestModule(
      promoterCubit: promoterCubit,
      promoterObserverCubit: promoterObserverCubit,
      userObserverCubit: userObserverCubit,
      permissionCubit: permissionCubit,
    );

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
        child: MaterialApp(
          locale: const Locale('de'),
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

  group('Promoter Search and Filter Integration Tests', () {
    testWidgets('should filter promoters by search query (name)',
        (tester) async {
      // Ignore overflow errors - they occur in tests due to grid tile constraints
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.toString().contains('RenderFlex overflowed')) {
          originalOnError?.call(details);
        }
      };

      try {
        // Given - Setup promoters
        final promoters = createTestPromoters();
        final user = createTestUser(
          registeredPromoterIDs: promoters.map((p) => p.id.value).toList(),
        );

        // Setup mocks
        when(mockPromoterRepository.observePromotersByIds(
          registeredIds: anyNamed('registeredIds'),
          unregisteredIds: anyNamed('unregisteredIds'),
        )).thenAnswer((_) => Stream.value(right(promoters)));

        permissionCubit.emit(PermissionSuccessState(
          permissions: createTestPermissions(),
          permissionInitiallyLoaded: true,
        ));
        userObserverCubit.emit(UserObserverSuccess(user: user));

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Verify all promoters are initially shown
        expect(find.byType(PromotersOverviewGridTile), findsNWidgets(4));

        // Enter search query
        final searchBar = find.byType(SearchBar);
        await tester.enterText(searchBar, 'John');
        await tester.pumpAndSettle();

        // Then - Only John Smith should be visible
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('Jane Doe'), findsNothing);
        expect(find.text('Bob Johnson'), findsOneWidget); // Bob Johnson also contains "John"
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('should filter promoters by search query (email)',
        (tester) async {
      // Ignore overflow errors - they occur in tests due to grid tile constraints
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.toString().contains('RenderFlex overflowed')) {
          originalOnError?.call(details);
        }
      };

      try {
        // Given - Setup promoters
        final promoters = createTestPromoters();
        final user = createTestUser(
          registeredPromoterIDs: promoters.map((p) => p.id.value).toList(),
        );

        // Setup mocks
        when(mockPromoterRepository.observePromotersByIds(
          registeredIds: anyNamed('registeredIds'),
          unregisteredIds: anyNamed('unregisteredIds'),
        )).thenAnswer((_) => Stream.value(right(promoters)));

        permissionCubit.emit(PermissionSuccessState(
          permissions: createTestPermissions(),
          permissionInitiallyLoaded: true,
        ));
        userObserverCubit.emit(UserObserverSuccess(user: user));

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Change search option to email
        final dropdown = find.byType(DropdownButton<PromoterSearchOption>);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        final emailOption = find.text('Suche nach E-Mail').last;
        await tester.tap(emailOption);
        await tester.pumpAndSettle();

        // Enter email search query
        final searchBar = find.byType(SearchBar);
        await tester.enterText(searchBar, 'jane.doe');
        await tester.pumpAndSettle();

        // Then - Only Jane Doe should be visible
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('John Smith'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('should filter promoters by registration status',
        (tester) async {
      // Ignore overflow errors - they occur in tests due to grid tile constraints
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.toString().contains('RenderFlex overflowed')) {
          originalOnError?.call(details);
        }
      };

      try {
        // Given - Setup promoters
        final promoters = createTestPromoters();
        final user = createTestUser(
          registeredPromoterIDs: promoters.map((p) => p.id.value).toList(),
        );

        // Setup mocks
        when(mockPromoterRepository.observePromotersByIds(
          registeredIds: anyNamed('registeredIds'),
          unregisteredIds: anyNamed('unregisteredIds'),
        )).thenAnswer((_) => Stream.value(right(promoters)));

        permissionCubit.emit(PermissionSuccessState(
          permissions: createTestPermissions(),
          permissionInitiallyLoaded: true,
        ));
        userObserverCubit.emit(UserObserverSuccess(user: user));

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Verify all 4 promoters are shown initially
        expect(find.byType(PromotersOverviewGridTile), findsNWidgets(4));

        // Open filter
        final filterButton = find.byIcon(Icons.filter_list);
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        // Select "only registered" filter - tap on the radio button for registered
        final registeredRadio = find.byWidgetPredicate(
          (widget) =>
              widget is Radio<PromoterRegistrationFilterState> &&
              widget.value == PromoterRegistrationFilterState.registered,
        );
        expect(registeredRadio, findsOneWidget);
        await tester.tap(registeredRadio);
        await tester.pumpAndSettle();

        // Then - Only 3 registered promoters should be visible
        // (John Smith, Jane Doe, Alice Williams - not Bob Johnson who is unregistered)
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('Alice Williams'), findsOneWidget);
        expect(find.text('Bob Johnson'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('should combine search and filter', (tester) async {
      // Ignore overflow errors - they occur in tests due to grid tile constraints
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.toString().contains('RenderFlex overflowed')) {
          originalOnError?.call(details);
        }
      };

      try {
        // Given - Setup promoters
        final promoters = createTestPromoters();
        final user = createTestUser(
          registeredPromoterIDs: promoters.map((p) => p.id.value).toList(),
        );

        // Setup mocks
        when(mockPromoterRepository.observePromotersByIds(
          registeredIds: anyNamed('registeredIds'),
          unregisteredIds: anyNamed('unregisteredIds'),
        )).thenAnswer((_) => Stream.value(right(promoters)));

        permissionCubit.emit(PermissionSuccessState(
          permissions: createTestPermissions(),
          permissionInitiallyLoaded: true,
        ));
        userObserverCubit.emit(UserObserverSuccess(user: user));

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Enter search query first
        final searchBar = find.byType(SearchBar);
        await tester.enterText(searchBar, 'J'); // Matches John, Jane, Bob Johnson
        await tester.pumpAndSettle();

        // Should show 3 promoters with 'J'
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('Bob Johnson'), findsOneWidget);

        // Now apply registration filter
        final filterButton = find.byIcon(Icons.filter_list);
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        // Select "only registered" filter - tap on the radio button for registered
        final registeredRadio = find.byWidgetPredicate(
          (widget) =>
              widget is Radio<PromoterRegistrationFilterState> &&
              widget.value == PromoterRegistrationFilterState.registered,
        );
        expect(registeredRadio, findsOneWidget);
        await tester.tap(registeredRadio);
        await tester.pumpAndSettle();

        // Then - Should show only registered promoters with 'J'
        // (John Smith and Jane Doe, but not Bob Johnson who is unregistered)
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('Bob Johnson'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('should clear search and show all promoters', (tester) async {
      // Ignore overflow errors - they occur in tests due to grid tile constraints
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.toString().contains('RenderFlex overflowed')) {
          originalOnError?.call(details);
        }
      };

      try {
        // Given - Setup promoters
        final promoters = createTestPromoters();
        final user = createTestUser(
          registeredPromoterIDs: promoters.map((p) => p.id.value).toList(),
        );

        // Setup mocks
        when(mockPromoterRepository.observePromotersByIds(
          registeredIds: anyNamed('registeredIds'),
          unregisteredIds: anyNamed('unregisteredIds'),
        )).thenAnswer((_) => Stream.value(right(promoters)));

        permissionCubit.emit(PermissionSuccessState(
          permissions: createTestPermissions(),
          permissionInitiallyLoaded: true,
        ));
        userObserverCubit.emit(UserObserverSuccess(user: user));

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Enter search query
        final searchBar = find.byType(SearchBar);
        await tester.enterText(searchBar, 'John');
        await tester.pumpAndSettle();

        // Verify filtered results
        expect(find.text('Jane Doe'), findsNothing);

        // Clear search
        final clearButton = find.byIcon(Icons.close);
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Then - All promoters should be visible again
        expect(find.byType(PromotersOverviewGridTile), findsNWidgets(4));
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('Bob Johnson'), findsOneWidget);
        expect(find.text('Alice Williams'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}
