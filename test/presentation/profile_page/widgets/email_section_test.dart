import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_desktop.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_section_mobile.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_verification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../mocks.mocks.dart';

class EmailSectionTestModule extends Module {
  final ProfileCubit profileCubit;
  final AuthCubit authCubit;

  EmailSectionTestModule({
    required this.profileCubit,
    required this.authCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<ProfileCubit>(() => profileCubit);
    i.addSingleton<AuthCubit>(() => authCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late ProfileCubit profileCubit;
  late AuthCubit authCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());
    when(mockUserRepository.isEmailVerified()).thenAnswer((_) async => false);

    profileCubit = ProfileCubit(
      authRepo: mockAuthRepository,
      userRepo: mockUserRepository,
    );

    authCubit = AuthCubit(authRepo: mockAuthRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    profileCubit.close();
    authCubit.close();
  });

  CustomUser createTestUser({
    String? email = 'test@example.com',
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'John',
      lastName: 'Doe',
      email: email ?? 'test@example.com',
      role: Role.promoter,
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
    Function? sendEmailVerificationCallback,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = EmailSectionTestModule(
      profileCubit: profileCubit,
      authCubit: authCubit,
    );

    return ModularApp(
      module: module,
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
              BlocProvider<ProfileCubit>.value(value: profileCubit),
              BlocProvider<AuthCubit>.value(value: authCubit),
            ],
            child: EmailSection(
              user: user,
              sendEmailVerificationCallback:
                  sendEmailVerificationCallback ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  group('EmailSection Widget Tests', () {
    testWidgets('should display section title', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_email_section_title),
        findsOneWidget,
      );

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display email section layout', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      // In test mode, EmailSectionDesktop is displayed
      expect(find.byType(EmailSectionDesktop), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display user email', (tester) async {
      // Given
      final testUser = createTestUser(email: 'john.doe@example.com');

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      expect(find.text('john.doe@example.com'), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should display edit button', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('EmailSection Email Verification Tests', () {
    testWidgets('should show unverified badge when email is not verified',
        (tester) async {
      // Given
      final testUser = createTestUser();
      profileCubit.emit(ProfileEmailVerifySuccessState(isEmailVerified: false));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump();

      // Then
      final badge = tester.widget<EmailVerificationBadge>(
        find.byType(EmailVerificationBadge),
      );
      expect(badge.state, EmailVerificationState.unverified);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show verified badge when email is verified',
        (tester) async {
      // Given
      final testUser = createTestUser();
      profileCubit.emit(ProfileEmailVerifySuccessState(isEmailVerified: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump();

      // Then
      final badge = tester.widget<EmailVerificationBadge>(
        find.byType(EmailVerificationBadge),
      );
      expect(badge.state, EmailVerificationState.verified);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show resend verification link when email not verified',
        (tester) async {
      // Given
      final testUser = createTestUser();
      profileCubit.emit(ProfileEmailVerifySuccessState(isEmailVerified: false));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization
            .profile_page_email_section_resend_verify_email_button_title),
        findsOneWidget,
      );
      expect(find.byType(ClickableLink), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should NOT show resend verification link when email verified',
        (tester) async {
      // Given
      final testUser = createTestUser();
      profileCubit.emit(ProfileEmailVerifySuccessState(isEmailVerified: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization
            .profile_page_email_section_resend_verify_email_button_title),
        findsNothing,
      );

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show loading when resending verification email',
        (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileCubit.emit(ProfileResendEmailVerificationLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should show error when resend verification fails',
        (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileCubit.emit(
          ProfileResendEmailVerificationFailureState(failure: BackendFailure()));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should call callback when resend verification succeeds',
        (tester) async {
      // Given
      final testUser = createTestUser();
      bool callbackCalled = false;

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(
        user: testUser,
        sendEmailVerificationCallback: () {
          callbackCalled = true;
        },
      ));
      await tester.pump();

      // When
      profileCubit.emit(ProfileResendEmailVerificationSuccessState());
      await tester.pump();

      // Then
      expect(callbackCalled, true);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });

  group('EmailSection Update Email Tests', () {
    testWidgets('should show error when email update fails', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileCubit.emit(
          ProfileEmailUpdateFailureState(failure: BackendFailure()));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });
  });
}
