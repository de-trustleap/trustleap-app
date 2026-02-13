@TestOn('chrome')
library;

import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/features/promoter/presentation/promoters_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../mocks.mocks.dart';

class PromotersPageTestModule extends Module {
  final PermissionCubit permissionCubit;
  final UserObserverCubit userObserverCubit;
  final AuthCubit authCubit;
  final MockPromoterRepository mockPromoterRepository;
  final MockLandingPageRepository mockLandingPageRepository;
  final MockUserRepository mockUserRepository;
  final MockAuthRepository mockAuthRepository;

  PromotersPageTestModule({
    required this.permissionCubit,
    required this.userObserverCubit,
    required this.authCubit,
    required this.mockPromoterRepository,
    required this.mockLandingPageRepository,
    required this.mockUserRepository,
    required this.mockAuthRepository,
  });

  @override
  void binds(i) {
    i.addSingleton<PermissionCubit>(() => permissionCubit);
    i.addSingleton<UserObserverCubit>(() => userObserverCubit);
    i.addSingleton<AuthCubit>(() => authCubit);
    i.addSingleton<PromoterCubit>(
        () => PromoterCubit(mockPromoterRepository, mockLandingPageRepository));
    i.addSingleton<PromoterObserverCubit>(
        () => PromoterObserverCubit(mockPromoterRepository));
  }

  @override
  void routes(r) {
    r.child('/',
        child: (_) => const Scaffold(
              body: PromotersPage(),
            ));
  }
}

void main() {
  late PermissionCubit permissionCubit;
  late UserObserverCubit userObserverCubit;
  late AuthCubit authCubit;
  late MockPermissionRepository mockPermissionRepository;
  late MockPromoterRepository mockPromoterRepository;
  late MockLandingPageRepository mockLandingPageRepository;
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<PermissionState>(PermissionInitial());
    provideDummy<UserObserverState>(UserObserverInitial());
    provideDummy<AuthState>(AuthStateUnAuthenticated());

    mockPermissionRepository = MockPermissionRepository();
    mockPromoterRepository = MockPromoterRepository();
    mockLandingPageRepository = MockLandingPageRepository();
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();

    // Setup default mock returns
    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());
    when(mockAuthRepository.observeAuthState())
        .thenAnswer((_) => Stream.empty());

    when(mockUserRepository.observeUser()).thenAnswer((_) => Stream.empty());
    when(mockUserRepository.isEmailVerified()).thenAnswer((_) async => true);

    when(mockPromoterRepository.observePromotersByIds(
      registeredIds: anyNamed('registeredIds'),
      unregisteredIds: anyNamed('unregisteredIds'),
    )).thenAnswer((_) => Stream.empty());

    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
    userObserverCubit = UserObserverCubit(mockUserRepository);
    authCubit = AuthCubit(authRepo: mockAuthRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    userObserverCubit.close();
    authCubit.close();
    permissionCubit.close();
  });

  // Helper function to create test user
  CustomUser createTestUser({
    String? firstName = 'John',
    String? lastName = 'Doe',
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: firstName,
      lastName: lastName,
      email: 'john.doe@example.com',
      companyID: null,
      role: Role.promoter,
    );
  }

  // Helper function to create test permissions
  Permissions createTestPermissions({
    bool canRegisterPromoter = false,
  }) {
    return Permissions(
      permissions: canRegisterPromoter ? {'registerPromoter': true} : {},
    );
  }

  Widget createWidgetUnderTest({String? editedPromoter}) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = PromotersPageTestModule(
      permissionCubit: permissionCubit,
      userObserverCubit: userObserverCubit,
      authCubit: authCubit,
      mockPromoterRepository: mockPromoterRepository,
      mockLandingPageRepository: mockLandingPageRepository,
      mockUserRepository: mockUserRepository,
      mockAuthRepository: mockAuthRepository,
    );

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<PermissionCubit>.value(value: permissionCubit),
                BlocProvider<UserObserverCubit>.value(value: userObserverCubit),
              ],
              child: PromotersPage(editedPromoter: editedPromoter),
            ),
          ),
        ),
      ),
    );
  }

  group('PromotersPage Widget Tests', () {
    testWidgets('should display CustomTabBar when widget is built',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions();

      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(CustomTabBar), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should create PromotersPage widget', (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions();
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(PromotersPage), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should accept editedPromoter parameter', (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions();
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(editedPromoter: "true"));
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final promotersPage =
          tester.widget<PromotersPage>(find.byType(PromotersPage));
      expect(promotersPage.editedPromoter, equals("true"));

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('PromotersPage Tab Tests', () {
    testWidgets('should show 1 tab when user has no register permissions',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions(canRegisterPromoter: false);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final customTabBar =
          tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(1)); // only overview

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show 2 tabs when user has register permissions',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions(canRegisterPromoter: true);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final customTabBar =
          tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(2)); // overview + register

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show correct tab titles without register permissions',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions(canRegisterPromoter: false);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final customTabBar =
          tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(1));
      expect(customTabBar.tabs[0].icon, equals(Icons.people));

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show correct tab titles with register permissions',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testPermissions = createTestPermissions(canRegisterPromoter: true);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissions,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final customTabBar =
          tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(2));
      expect(customTabBar.tabs[0].icon, equals(Icons.people)); // overview
      expect(customTabBar.tabs[1].icon, equals(Icons.person_add)); // register

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('PromotersPage Permission Tests', () {
    testWidgets('should hide register tab when permissions change',
        (tester) async {
      // Given - start with register permissions
      final testUser = createTestUser();
      final testPermissionsWithRegister =
          createTestPermissions(canRegisterPromoter: true);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissionsWithRegister,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify 2 tabs initially
      var customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(2));

      // When - remove register permissions and rebuild widget completely
      final testPermissionsWithoutRegister =
          createTestPermissions(canRegisterPromoter: false);
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissionsWithoutRegister,
        permissionInitiallyLoaded: true,
      ));

      // Rebuild the entire widget tree with new permissions
      await tester.pumpWidget(Container()); // Clear the tree first
      await tester.pump();
      await tester
          .pumpWidget(createWidgetUnderTest()); // Rebuild with new state
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then - should show only 1 tab
      customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(1));

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show register tab when permissions are granted',
        (tester) async {
      // Given - start without register permissions
      final testUser = createTestUser();
      final testPermissionsWithoutRegister =
          createTestPermissions(canRegisterPromoter: false);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissionsWithoutRegister,
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify 1 tab initially
      var customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(1));

      // When - grant register permissions and rebuild widget completely
      final testPermissionsWithRegister =
          createTestPermissions(canRegisterPromoter: true);
      permissionCubit.emit(PermissionSuccessState(
        permissions: testPermissionsWithRegister,
        permissionInitiallyLoaded: true,
      ));

      // Rebuild the entire widget tree with new permissions
      await tester.pumpWidget(Container()); // Clear the tree first
      await tester.pump();
      await tester
          .pumpWidget(createWidgetUnderTest()); // Rebuild with new state
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then - should show 2 tabs
      customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(2));

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });
}
