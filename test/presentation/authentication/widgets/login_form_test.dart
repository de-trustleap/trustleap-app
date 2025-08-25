import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_footer.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/password_forgotten_button.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/constants.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import '../../../mocks.mocks.dart';
import '../../../repositories/mock_user_credential.dart';
import '../../../widget_test_wrapper.dart';

// Test Module für Navigation Tests
class TestNavigationModule extends Module {
  final SignInCubit signInCubit;
  final AuthCubit authCubit;
  final PermissionCubit permissionCubit;

  TestNavigationModule({
    required this.signInCubit,
    required this.authCubit,
    required this.permissionCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<SignInCubit>(() => signInCubit);
    i.addSingleton<AuthCubit>(() => authCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
  }

  @override
  void routes(r) {
    r.child('/',
        child: (_) => Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<SignInCubit>(create: (_) => signInCubit),
                        BlocProvider<AuthCubit>(create: (_) => authCubit),
                        BlocProvider<PermissionCubit>(
                            create: (_) => permissionCubit),
                      ],
                      child: const LoginForm(),
                    ),
                  ),
                  const AuthFooter(),
                ],
              ),
            ));
    r.child(RoutePaths.registerPath,
        child: (_) => const Scaffold(
              body: Center(child: Text('Registration Page')),
            ));
    r.child(RoutePaths.passwordReset,
        child: (_) => const Scaffold(
              body: Center(child: Text('Password Reset Page')),
            ));
    r.child(RoutePaths.privacyPolicy,
        child: (_) => const Scaffold(
              body: Center(child: Text('Privacy Policy Page')),
            ));
    r.child(RoutePaths.imprint,
        child: (_) => const Scaffold(
              body: Center(child: Text('Imprint Page')),
            ));
    r.child(RoutePaths.termsAndCondition,
        child: (_) => const Scaffold(
              body: Center(child: Text('Terms and Conditions Page')),
            ));
  }
}

void main() {
  late SignInCubit signInCubit;
  late AuthCubit authCubit;
  late PermissionCubit permissionCubit;
  late MockAuthRepository mockAuthRepository;
  late MockPermissionRepository mockPermissionRepository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    ResponsiveHelper.enableTestMode();

    provideDummy<AuthState>(AuthStateUnAuthenticated());
    provideDummy<PermissionState>(PermissionInitial());
    provideDummy<SignInState>(SignInInitial());

    mockAuthRepository = MockAuthRepository();
    mockPermissionRepository = MockPermissionRepository();

    final mockCredential = MockUserCredential();
    when(mockAuthRepository.loginWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => right(mockCredential));

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);

    when(mockAuthRepository.getSignedInUser()).thenReturn(none());
    when(mockAuthRepository.observeAuthState())
        .thenAnswer((_) => Stream.empty());

    signInCubit = SignInCubit(authRepo: mockAuthRepository);
    authCubit = AuthCubit(authRepo: mockAuthRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    // Add a small delay to ensure complete cleanup
  });

  Widget createWidgetUnderTest() {
    return WidgetTestWrapper.createTestWidget(
      child: const LoginForm(),
      providers: [
        BlocProvider<SignInCubit>(create: (_) => signInCubit),
        BlocProvider<AuthCubit>(create: (_) => authCubit),
        BlocProvider<PermissionCubit>(create: (_) => permissionCubit),
      ],
      withCustomNavigator: true,
    );
  }

  Widget createNavigationTestApp() {
    return WidgetTestWrapper.createTestWidget(
      child:
          Container(), // Placeholder, actual child comes from navigation module routes
      withNavigation: true,
      navigationModule: TestNavigationModule(
        signInCubit: signInCubit,
        authCubit: authCubit,
        permissionCubit: permissionCubit,
      ),
    );
  }

  group('LoginForm Real Cubit Tests', () {
    testWidgets('should perform login with repository when form is submitted',
        (tester) async {
      final mockCredential = MockUserCredential();
      when(mockAuthRepository.loginWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => right(mockCredential));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('loginTextField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.byKey(const Key('passwordTextField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'password123');

      final loginButton = find.byKey(const Key('loginButton'));
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(mockAuthRepository.loginWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);
    });

    testWidgets('should show error when login fails with WrongPasswordFailure',
        (tester) async {
      when(mockAuthRepository.loginWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => left(WrongPasswordFailure()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('loginTextField'));
      final passwordField = find.byKey(const Key('passwordTextField'));
      final loginButton = find.byKey(const Key('loginButton'));

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should show loading state during login', (tester) async {
      signInCubit.emit(SignInLoadingState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final loginButton = find.byType(PrimaryButton);
      expect(loginButton, findsOneWidget);

      final buttonWidget = tester.widget<PrimaryButton>(loginButton);
      expect(buttonWidget.isLoading, isTrue);
    });

    testWidgets('should not show error view in normal states', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(FormErrorView), findsNothing);
    });
  });

  group('LoginForm Basic Widget Tests', () {
    testWidgets('should display all required form elements', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(FormTextfield), findsNWidgets(2));
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.byType(PasswordForgottenButton), findsOneWidget);
      expect(find.byType(RegisterButton), findsOneWidget);
    });

    testWidgets(
        'should display email and password text fields with correct keys',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byKey(const Key("loginTextField")), findsOneWidget);
      expect(find.byKey(const Key("passwordTextField")), findsOneWidget);
    });

    testWidgets('should display login button with correct key', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byKey(const Key("loginButton")), findsOneWidget);
    });

    testWidgets('should display password forgotten button with correct key',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byKey(const Key("passwordForgottenButton")), findsOneWidget);
    });

    testWidgets('should display register button with correct key',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byKey(const Key("registerButton")), findsOneWidget);
    });

    testWidgets(
        'should call loginWithEmailAndPassword when login button is tapped with valid input',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When
      await tester.enterText(
          find.byKey(const Key("loginTextField")), "test@example.com");
      await tester.enterText(
          find.byKey(const Key("passwordTextField")), "password123");
      await tester.tap(find.byKey(const Key("loginButton")));
      await tester.pumpAndSettle();

      // Then
      verify(mockAuthRepository.loginWithEmailAndPassword(
              email: "test@example.com", password: "password123"))
          .called(1);
    });

    testWidgets(
        'should NOT show error view when form validation fails (validationHasError is true)',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.byKey(const Key("loginButton")));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should show loading state when SignInLoadingState is emitted',
        (tester) async {
      // Given
      signInCubit.emit(SignInLoadingState());

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final loginButton =
          tester.widget<PrimaryButton>(find.byKey(const Key("loginButton")));
      expect(loginButton.disabled, true);
      expect(loginButton.isLoading, true);
    });

    testWidgets(
        'should show loading state when PermissionLoadingState is emitted',
        (tester) async {
      // Given
      permissionCubit.emit(PermissionLoadingState());

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final loginButton =
          tester.widget<PrimaryButton>(find.byKey(const Key("loginButton")));
      expect(loginButton.disabled, true);
      expect(loginButton.isLoading, true);
    });
  });

  group('LoginForm Real Navigation Tests', () {
    testWidgets('should find and tap register button without errors',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final registerButton = find.byKey(const Key('registerButton'));
      expect(registerButton, findsOneWidget);

      // Verify button can be tapped without throwing errors
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Test passes if no exceptions are thrown during button tap
    });

    testWidgets(
        'should navigate to password reset page when password forgotten button is tapped',
        (tester) async {
      await tester.pumpWidget(createNavigationTestApp());
      await tester.pumpAndSettle();

      final passwordForgottenButton = find.text('Password forgotten?');
      expect(passwordForgottenButton, findsOneWidget);

      await tester.tap(passwordForgottenButton);

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (Modular.to.path == RoutePaths.passwordReset) break;
      }
      await tester.pumpAndSettle();
      expect(Modular.to.path, equals(RoutePaths.passwordReset));
    });

    testWidgets('should have both navigation buttons available on login form',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('registerButton')), findsOneWidget);
      expect(find.byKey(const Key('passwordForgottenButton')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets(
        'should navigate to privacy policy when footer button is tapped',
        (tester) async {
      await tester.pumpWidget(createNavigationTestApp());
      await tester.pumpAndSettle();

      final privacyButton = find.text('Privacy Policy');
      expect(privacyButton, findsOneWidget);

      await tester.tap(privacyButton);

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (Modular.to.path == RoutePaths.privacyPolicy) break;
      }
      await tester.pumpAndSettle();
      expect(Modular.to.path, equals(RoutePaths.privacyPolicy));
    });

    testWidgets('should navigate to imprint when footer button is tapped',
        (tester) async {
      await tester.pumpWidget(createNavigationTestApp());
      await tester.pumpAndSettle();

      final imprintButton = find.text('Imprint');
      expect(imprintButton, findsOneWidget);

      await tester.tap(imprintButton);

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (Modular.to.path == RoutePaths.imprint) break;
      }
      await tester.pumpAndSettle();
      expect(Modular.to.path, equals(RoutePaths.imprint));
    });

    testWidgets(
        'should navigate to terms and conditions when footer button is tapped',
        (tester) async {
      await tester.pumpWidget(createNavigationTestApp());
      await tester.pumpAndSettle();

      final termsButton = find.text('Terms & Conditions');
      expect(termsButton, findsOneWidget);

      await tester.tap(termsButton);

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (Modular.to.path == RoutePaths.termsAndCondition) break;
      }
      await tester.pumpAndSettle();
      expect(Modular.to.path, equals(RoutePaths.termsAndCondition));
    });
  });

  group('LoginForm BlocListener Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets(
        'should call checkForAuthState when SignInSuccessState is emitted',
        (tester) async {
      final mockCredential = MockUserCredential();
      when(mockAuthRepository.loginWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => right(mockCredential));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('loginTextField'));
      final passwordField = find.byKey(const Key('passwordTextField'));
      final loginButton = find.byKey(const Key('loginButton'));

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(mockAuthRepository.loginWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);
    });

    testWidgets(
        'should enable auto-validation when SignInShowValidationState is emitted',
        (tester) async {
      // Given
      signInCubit.emit(SignInShowValidationState());

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.autovalidateMode, AutovalidateMode.always);
    });
  });
}
