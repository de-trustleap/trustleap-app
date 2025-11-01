@TestOn('chrome')
library;

import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/application/images/company/company_image_bloc.dart';
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../mocks.mocks.dart';
import '../../widget_test_wrapper.dart';

// Test Module for ProfilePage
class ProfilePageTestModule extends Module {
  final UserObserverCubit userObserverCubit;
  final AuthCubit authCubit;
  final PermissionCubit permissionCubit;
  final MockUserRepository mockUserRepository;
  final MockAuthRepository mockAuthRepository;
  final MockImageRepository mockImageRepository;
  final MockCompanyRepository mockCompanyRepository;
  final MockCalendlyRepository mockCalendlyRepository;

  ProfilePageTestModule({
    required this.userObserverCubit,
    required this.authCubit,
    required this.permissionCubit,
    required this.mockUserRepository,
    required this.mockAuthRepository,
    required this.mockImageRepository,
    required this.mockCompanyRepository,
    required this.mockCalendlyRepository,
  });

  @override
  void binds(i) {
    i.addSingleton<UserObserverCubit>(() => userObserverCubit);
    i.addSingleton<AuthCubit>(() => authCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
    i.addSingleton<ProfileCubit>(() => ProfileCubit(
          authRepo: mockAuthRepository,
          userRepo: mockUserRepository,
        ));
    i.addSingleton<ProfileImageBloc>(() => ProfileImageBloc(mockImageRepository));
    i.addSingleton<CompanyImageBloc>(() => CompanyImageBloc(mockImageRepository));
    i.addSingleton<CompanyCubit>(() => CompanyCubit(mockCompanyRepository, mockAuthRepository));
    i.addSingleton<CompanyObserverCubit>(() => CompanyObserverCubit(mockCompanyRepository));
    i.addSingleton<CompanyRequestCubit>(() => CompanyRequestCubit(mockCompanyRepository, mockUserRepository));
    i.addSingleton<CalendlyCubit>(() => CalendlyCubit(mockCalendlyRepository));
  }

  @override
  void routes(r) {
    r.child('/',
        child: (_) => const Scaffold(
              body: ProfilePage(),
            ));
  }
}

void main() {
  late UserObserverCubit userObserverCubit;
  late AuthCubit authCubit;
  late PermissionCubit permissionCubit;
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late MockImageRepository mockImageRepository;
  late MockCompanyRepository mockCompanyRepository;
  late MockPermissionRepository mockPermissionRepository;
  late MockCalendlyRepository mockCalendlyRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<UserObserverState>(UserObserverInitial());
    provideDummy<AuthState>(AuthStateUnAuthenticated());
    provideDummy<PermissionState>(PermissionInitial());

    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
    mockImageRepository = MockImageRepository();
    mockCompanyRepository = MockCompanyRepository();
    mockPermissionRepository = MockPermissionRepository();
    mockCalendlyRepository = MockCalendlyRepository();

    // Setup default mock returns
    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());
    when(mockAuthRepository.observeAuthState())
        .thenAnswer((_) => Stream.empty());

    when(mockUserRepository.observeUser())
        .thenAnswer((_) => Stream.empty());
    when(mockUserRepository.isEmailVerified())
        .thenAnswer((_) async => true);

    when(mockCalendlyRepository.observeAuthenticationStatus())
        .thenAnswer((_) => Stream.empty());

    userObserverCubit = UserObserverCubit(mockUserRepository);
    authCubit = AuthCubit(authRepo: mockAuthRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
  });

  // Helper function to create a test user
  CustomUser createTestUser({
    String? companyID,
    String? firstName = 'John',
    String? lastName = 'Doe',
    String? email = 'john.doe@example.com',
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: firstName,
      lastName: lastName,
      email: email,
      companyID: companyID,
      role: Role.promoter,
    );
  }

  // Helper function to create test permissions
  Permissions createTestPermissions({
    bool canReadCompany = true,
  }) {
    return Permissions(
      permissions: canReadCompany ? {'readCompany': true} : {},
    );
  }

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = ProfilePageTestModule(
      userObserverCubit: userObserverCubit,
      authCubit: authCubit,
      permissionCubit: permissionCubit,
      mockUserRepository: mockUserRepository,
      mockAuthRepository: mockAuthRepository,
      mockImageRepository: mockImageRepository,
      mockCompanyRepository: mockCompanyRepository,
      mockCalendlyRepository: mockCalendlyRepository,
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
                BlocProvider<UserObserverCubit>.value(value: userObserverCubit),
                BlocProvider<PermissionCubit>.value(value: permissionCubit),
              ],
              child: const ProfilePage(),
            ),
          ),
        ),
      ),
    );
  }

  group('ProfilePage Widget Tests', () {
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

    testWidgets('should create all required BlocProviders',
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
      expect(find.byType(ProfilePage), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('ProfilePage Tab Tests', () {
    testWidgets('should show 3 tabs when user has no companyID',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: null);
      final testPermissions = createTestPermissions(canReadCompany: true);

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
      final customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(3)); // general, password, delete

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show 4 tabs when user has companyID and read permissions',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: 'test-company-id');
      final testPermissions = createTestPermissions(canReadCompany: true);

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
      final customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(4)); // general, company, password, delete

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show 3 tabs when user has companyID but no read permissions',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: 'test-company-id');
      final testPermissions = createTestPermissions(canReadCompany: false);

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
      final customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(3)); // general, password, delete (no company)

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show 3 tabs when user has empty companyID',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: '');
      final testPermissions = createTestPermissions(canReadCompany: true);

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
      final customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(3)); // general, password, delete

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('ProfilePage State Management Tests', () {
    testWidgets('should rebuild when UserObserverState changes',
        (tester) async {
      // Given - start without user
      userObserverCubit.emit(UserObserverInitial());
      permissionCubit.emit(PermissionSuccessState(
        permissions: createTestPermissions(),
        permissionInitiallyLoaded: true,
      ));

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Give more time for navigation to complete on Chrome
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // When - emit user success state
      final testUser = createTestUser(companyID: null);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();
      await tester.pump(); // Extra pump to let BlocBuilder rebuild

      // Then - should show tabs
      expect(find.byType(CustomTabBar), findsOneWidget);
      final customTabBar = tester.widget<CustomTabBar>(find.byType(CustomTabBar));
      expect(customTabBar.tabs.length, equals(3));

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });
}
