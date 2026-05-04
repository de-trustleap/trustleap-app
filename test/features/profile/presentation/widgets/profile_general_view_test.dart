import 'package:finanzbegleiter/core/remote_config/app_remote_config_cubit.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_service.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_state.dart';
import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/tremendous/application/tremendous_cubit.dart';
import 'package:finanzbegleiter/features/calendly/application/calendly_cubit.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/features/images/application/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/calendly_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/contact_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/email_section/email_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/profile_general_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/profile_image_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/profile_register_company_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/tremendous_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../../mocks.mocks.dart';

class ProfileGeneralViewTestModule extends Module {
  final UserObserverCubit userObserverCubit;
  final AuthCubit authCubit;
  final MockUserRepository mockUserRepository;
  final MockAuthRepository mockAuthRepository;
  final MockImageRepository mockImageRepository;
  final MockCalendlyRepository mockCalendlyRepository;
  final MockCompanyRepository mockCompanyRepository;
  final MockAppRemoteConfigService mockAppRemoteConfigService;
  final MockTremendousRepository mockTremendousRepository;

  ProfileGeneralViewTestModule({
    required this.userObserverCubit,
    required this.authCubit,
    required this.mockUserRepository,
    required this.mockAuthRepository,
    required this.mockImageRepository,
    required this.mockCalendlyRepository,
    required this.mockCompanyRepository,
    required this.mockAppRemoteConfigService,
    required this.mockTremendousRepository,
  });

  @override
  void binds(i) {
    i.addSingleton<UserObserverCubit>(() => userObserverCubit);
    i.addSingleton<AuthCubit>(() => authCubit);
    i.addSingleton<ProfileCubit>(() => ProfileCubit(
          authRepo: mockAuthRepository,
          userRepo: mockUserRepository,
        ));
    i.addSingleton<ProfileImageBloc>(
        () => ProfileImageBloc(mockImageRepository));
    i.addSingleton<CalendlyCubit>(() => CalendlyCubit(mockCalendlyRepository));
    i.addSingleton<CompanyRequestCubit>(() => CompanyRequestCubit(mockCompanyRepository, mockUserRepository));
    i.addSingleton<AppRemoteConfigService>(() => mockAppRemoteConfigService);
    i.addSingleton<AppRemoteConfigCubit>(() => AppRemoteConfigCubit(mockAppRemoteConfigService));
    i.addSingleton<TremendousCubit>(() => TremendousCubit(mockTremendousRepository));
  }

  @override
  void routes(r) {
    r.child('/',
        child: (_) => const Scaffold(
              body: ProfileGeneralView(),
            ));
  }
}

void main() {
  late UserObserverCubit userObserverCubit;
  late AuthCubit authCubit;
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late MockImageRepository mockImageRepository;
  late MockCalendlyRepository mockCalendlyRepository;
  late MockCompanyRepository mockCompanyRepository;
  late MockAppRemoteConfigService mockAppRemoteConfigService;
  late MockTremendousRepository mockTremendousRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<UserObserverState>(UserObserverInitial());
    provideDummy<AuthState>(AuthStateUnAuthenticated());
    provideDummy<AppRemoteConfigState>(const AppRemoteConfigState(tremendousEnabled: false));

    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
    mockImageRepository = MockImageRepository();
    mockCalendlyRepository = MockCalendlyRepository();
    mockCompanyRepository = MockCompanyRepository();
    mockAppRemoteConfigService = MockAppRemoteConfigService();
    mockTremendousRepository = MockTremendousRepository();

    when(mockAppRemoteConfigService.tremendousEnabled).thenReturn(false);
    when(mockAppRemoteConfigService.onConfigUpdated).thenAnswer((_) => Stream.empty());
    when(mockTremendousRepository.observeConnectionStatus()).thenAnswer((_) => Stream.empty());

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());
    when(mockAuthRepository.observeAuthState())
        .thenAnswer((_) => Stream.empty());

    when(mockUserRepository.observeUser()).thenAnswer((_) => Stream.empty());
    when(mockUserRepository.isEmailVerified()).thenAnswer((_) async => true);

    when(mockCalendlyRepository.observeAuthenticationStatus())
        .thenAnswer((_) => Stream.empty());

    userObserverCubit = UserObserverCubit(mockUserRepository);
    authCubit = AuthCubit(authRepo: mockAuthRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
  });

  CustomUser createTestUser({
    String? companyID,
    String? firstName = 'John',
    String? lastName = 'Doe',
    String? email = 'john.doe@example.com',
    Role role = Role.promoter,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: firstName,
      lastName: lastName,
      email: email,
      companyID: companyID,
      role: role,
    );
  }

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = ProfileGeneralViewTestModule(
      userObserverCubit: userObserverCubit,
      authCubit: authCubit,
      mockUserRepository: mockUserRepository,
      mockAuthRepository: mockAuthRepository,
      mockImageRepository: mockImageRepository,
      mockCalendlyRepository: mockCalendlyRepository,
      mockCompanyRepository: mockCompanyRepository,
      mockAppRemoteConfigService: mockAppRemoteConfigService,
      mockTremendousRepository: mockTremendousRepository,
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
                BlocProvider<ProfileImageBloc>(
                  create: (_) => ProfileImageBloc(mockImageRepository),
                ),
                BlocProvider<CompanyRequestCubit>(
                  create: (_) => CompanyRequestCubit(mockCompanyRepository, mockUserRepository),
                ),
              ],
              child: const ProfileGeneralView(),
            ),
          ),
        ),
      ),
    );
  }

  group('ProfileGeneralView Widget Tests', () {
    testWidgets('should display ProfileGeneralView when user is loaded',
        (tester) async {
      // Given
      final testUser = createTestUser();
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(ProfileGeneralView), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display all main sections', (tester) async {
      // Given
      final testUser = createTestUser();
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then - Check all main widgets are displayed
      expect(find.byType(ProfileImageSection), findsOneWidget);
      expect(find.byType(ContactSection), findsOneWidget);
      expect(find.byType(CalendlySection), findsOneWidget);
      expect(find.byType(EmailSection), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display ProfileRegisterCompanySection when user has no company',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: null);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(ProfileRegisterCompanySection), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display ProfileRegisterCompanySection when user has empty company',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: '');
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(ProfileRegisterCompanySection), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should NOT display ProfileRegisterCompanySection when user has company',
        (tester) async {
      // Given
      final testUser = createTestUser(companyID: 'test-company-123');
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(ProfileRegisterCompanySection), findsNothing);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should hide TremendousSection when feature disabled',
        (tester) async {
      // Given
      when(mockAppRemoteConfigService.tremendousEnabled).thenReturn(false);
      final testUser = createTestUser(
        companyID: 'test-company-123',
        role: Role.company,
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(TremendousSection), findsNothing);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show TremendousSection when feature enabled',
        (tester) async {
      // Given
      when(mockAppRemoteConfigService.tremendousEnabled).thenReturn(true);
      final testUser = createTestUser(
        companyID: 'test-company-123',
        role: Role.company,
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(TremendousSection), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display logout button', (tester) async {
      // Given
      final testUser = createTestUser();
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then - Find logout button by its text
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.profile_page_logout_button_title), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });
}
