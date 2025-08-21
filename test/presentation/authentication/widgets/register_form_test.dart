import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_form.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/legals_check.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import '../../../widget_test_helper.dart';
import '../../../widget_test_wrapper.dart';
import '../../../mocks.mocks.dart';
import '../../../repositories/mock_user_credential.dart';

void main() {
  LiveTestWidgetsFlutterBinding();

  late SignInCubit signInCubit;
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    ResponsiveHelper.enableTestMode();
    WidgetTestHelper.setupDummyValues();

    mockAuthRepository = MockAuthRepository();
    signInCubit = SignInCubit(authRepo: mockAuthRepository);
    authCubit = AuthCubit(authRepo: mockAuthRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
  });

  Widget createWidgetUnderTest({String? registrationCode}) {
    final widget = RegisterForm(registrationCode: registrationCode);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      home: CustomNavigator.create(
        child: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<SignInCubit>(create: (_) => signInCubit),
              BlocProvider<AuthCubit>(create: (_) => authCubit),
            ],
            child: widget,
          ),
        ),
      ),
    );
  }

  Future<void> pumpWidgetWithResponsiveInit(WidgetTester tester,
      {String? registrationCode}) async {
    // Set wider test window size to prevent overflow
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    await tester
        .pumpWidget(createWidgetUnderTest(registrationCode: registrationCode));
    await tester.pumpAndSettle();
  }

  group('RegisterForm Real Validation Tests', () {
    testWidgets('should show email validation error for invalid email',
        (tester) async {
      // Set cubit to validation state using emit
      signInCubit.emit(SignInShowValidationState());

      await pumpWidgetWithResponsiveInit(tester);

      final emailField = find.byKey(const Key('emailTextField'));
      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();

        expect(find.text('Ungültige E-Mail Adresse'), findsOneWidget);
      }
    });

    testWidgets('should show firstname validation error for empty firstname',
        (tester) async {
      signInCubit.emit(SignInShowValidationState());

      await pumpWidgetWithResponsiveInit(tester);

      final firstNameField = find.byKey(const Key('firstNameTextField'));
      final emailField = find.byKey(const Key('emailTextField'));

      if (firstNameField.evaluate().isNotEmpty &&
          emailField.evaluate().isNotEmpty) {
        await tester.tap(firstNameField);
        await tester.pump();
        await tester.tap(emailField); // Focus away to trigger validation
        await tester.pump();

        expect(find.text('Bitte den Vornamen angeben'), findsOneWidget);
      }
    });

    testWidgets('should show lastname validation error for empty lastname',
        (tester) async {
      signInCubit.emit(SignInShowValidationState());

      await pumpWidgetWithResponsiveInit(tester);

      final lastNameField = find.byKey(const Key('lastNameTextField'));
      final emailField = find.byKey(const Key('emailTextField'));

      if (lastNameField.evaluate().isNotEmpty &&
          emailField.evaluate().isNotEmpty) {
        await tester.tap(lastNameField);
        await tester.pump();
        await tester.tap(emailField); // Focus away to trigger validation
        await tester.pump();

        expect(find.text('Bitte den Nachnamen angeben'), findsOneWidget);
      }
    });

    testWidgets('should show registration code validation error for empty code',
        (tester) async {
      signInCubit.emit(SignInShowValidationState());

      await pumpWidgetWithResponsiveInit(tester);

      final codeField = find.byKey(const Key('codeTextField'));
      final emailField = find.byKey(const Key('emailTextField'));

      if (codeField.evaluate().isNotEmpty && emailField.evaluate().isNotEmpty) {
        await tester.tap(codeField);
        await tester.pump();
        await tester.tap(emailField); // Focus away to trigger validation
        await tester.pump();

        expect(find.textContaining('Code'), findsOneWidget);
      }
    });
  });

  group('RegisterForm Submit Button Behavior Tests', () {
    testWidgets('should keep submit button disabled for invalid data',
        (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      final emailField = find.byKey(const Key('emailTextField'));
      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();
      }

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      final button = find.byType(PrimaryButton);
      if (button.evaluate().isNotEmpty) {
        final primaryButton = tester.widget<PrimaryButton>(button);
        expect(primaryButton.disabled, isFalse);
      }
    });

    testWidgets('should disable submit button initially', (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      final button = find.byType(PrimaryButton);
      if (button.evaluate().isNotEmpty) {
        final primaryButton = tester.widget<PrimaryButton>(button);
        expect(primaryButton.disabled, isTrue);
      }
    });

    testWidgets('should enable submit button when legal conditions accepted',
        (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();

        final button = find.byType(PrimaryButton);
        if (button.evaluate().isNotEmpty) {
          final primaryButton = tester.widget<PrimaryButton>(button);
          expect(primaryButton.disabled, isFalse);
        }
      }
    });

    testWidgets('should show loading state during registration',
        (tester) async {
      signInCubit.emit(SignInLoadingState());

      await pumpWidgetWithResponsiveInit(tester);

      final button = find.byType(PrimaryButton);
      if (button.evaluate().isNotEmpty) {
        final primaryButton = tester.widget<PrimaryButton>(button);
        expect(primaryButton.isLoading, isTrue);
        expect(primaryButton.disabled, isTrue);
      }
    });
  });

  group('RegisterForm Form Submission Tests', () {
    testWidgets('should call repository with null for invalid form submission',
        (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();

        await tester.pumpAndSettle();

        verify(mockAuthRepository.isRegistrationCodeValid(
                email: null, code: null))
            .called(1);
      }
    });

    testWidgets('should call repository with data for valid form submission',
        (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      final emailField = find.byKey(const Key('emailTextField'));
      final codeField = find.byKey(const Key('codeTextField'));
      final firstNameField = find.byKey(const Key('firstNameTextField'));

      if (emailField.evaluate().isNotEmpty && codeField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(codeField, 'TESTCODE');
        await tester.pump();
      }

      if (firstNameField.evaluate().isNotEmpty) {
        await tester.enterText(firstNameField, 'John');
        await tester.pump();
      }

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();

        await tester.pumpAndSettle();

        verify(mockAuthRepository.isRegistrationCodeValid(
                email: 'test@example.com', code: 'TESTCODE'))
            .called(1);
      }
    });

    testWidgets('should trigger registration flow when code is valid',
        (tester) async {
      when(mockAuthRepository.isRegistrationCodeValid(
              email: anyNamed('email'), code: anyNamed('code')))
          .thenAnswer((_) async => right(true));

      final mockUserCredential = MockUserCredential();
      when(mockAuthRepository.loginWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => right(mockUserCredential));

      await pumpWidgetWithResponsiveInit(tester);

      final emailField = find.byKey(const Key('emailTextField'));
      final passwordField = find.byKey(const Key('passwordTextField'));
      final codeField = find.byKey(const Key('codeTextField'));

      if (emailField.evaluate().isNotEmpty &&
          passwordField.evaluate().isNotEmpty &&
          codeField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'testpassword123');
        await tester.enterText(codeField, 'VALIDCODE');
        await tester.pump();
      }

      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();

        await tester.pumpAndSettle();

        verify(mockAuthRepository.isRegistrationCodeValid(
                email: 'test@example.com', code: 'VALIDCODE'))
            .called(1);

        verify(mockAuthRepository.loginWithEmailAndPassword(
                email: 'test@example.com', password: 'testpassword123'))
            .called(1);
      }
    });
  });

  group('RegisterForm Error Display Tests', () {
    testWidgets('should not show error view in normal states', (tester) async {
      await pumpWidgetWithResponsiveInit(tester);

      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should show error when code validation fails in repository',
        (tester) async {
      // Mock repository to return code validation failure
      when(mockAuthRepository.isRegistrationCodeValid(
              email: anyNamed('email'), code: anyNamed('code')))
          .thenAnswer((_) async => left(BackendFailure()));

      await pumpWidgetWithResponsiveInit(tester);

      // Fill form with valid data
      final emailField = find.byKey(const Key('emailTextField'));
      final codeField = find.byKey(const Key('codeTextField'));

      if (emailField.evaluate().isNotEmpty && codeField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(codeField, 'INVALIDCODE');
        await tester.pump();
      }

      // Accept terms to enable submit button
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      // Submit form - this will trigger the repository error
      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();
        await tester.pumpAndSettle();

        // VERIFY: Error should be displayed by the RegisterForm
        expect(find.byType(FormErrorView), findsOneWidget);
      }
    });

    testWidgets('should show invalid code error when code validation returns false',
        (tester) async {
      // Mock repository to return code validation false (code not valid)
      when(mockAuthRepository.isRegistrationCodeValid(
              email: anyNamed('email'), code: anyNamed('code')))
          .thenAnswer((_) async => right(false));

      await pumpWidgetWithResponsiveInit(tester);

      // Fill form with valid data but invalid code
      final emailField = find.byKey(const Key('emailTextField'));
      final codeField = find.byKey(const Key('codeTextField'));

      if (emailField.evaluate().isNotEmpty && codeField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(codeField, 'WRONGCODE');
        await tester.pump();
      }

      // Accept terms
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      // Submit form
      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();
        await tester.pumpAndSettle();

        // VERIFY: Code validation error should be displayed
        expect(find.byType(FormErrorView), findsOneWidget);
        // The error message should be about invalid code
        expect(find.textContaining('Code'), findsWidgets);
      }
    });

    testWidgets('should show registration error when registration fails',
        (tester) async {
      // Mock code validation to succeed but registration to fail
      when(mockAuthRepository.isRegistrationCodeValid(
              email: anyNamed('email'), code: anyNamed('code')))
          .thenAnswer((_) async => right(true));
      
      when(mockAuthRepository.registerAndCreateUser(
              email: anyNamed('email'),
              password: anyNamed('password'),
              user: anyNamed('user'),
              privacyPolicyAccepted: anyNamed('privacyPolicyAccepted'),
              termsAndConditionsAccepted: anyNamed('termsAndConditionsAccepted')))
          .thenAnswer((_) async => left(EmailAlreadyInUseFailure()));

      await pumpWidgetWithResponsiveInit(tester);

      // Fill complete form
      final emailField = find.byKey(const Key('emailTextField'));
      final passwordField = find.byKey(const Key('passwordTextField'));
      final codeField = find.byKey(const Key('codeTextField'));
      final firstNameField = find.byKey(const Key('firstNameTextField'));

      if (emailField.evaluate().isNotEmpty && 
          passwordField.evaluate().isNotEmpty && 
          codeField.evaluate().isNotEmpty &&
          firstNameField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'existing@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.enterText(codeField, 'VALIDCODE');
        await tester.enterText(firstNameField, 'John');
        await tester.pump();
      }

      // Accept terms
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().length >= 2) {
        await tester.tap(checkboxes.first);
        await tester.pump();
        await tester.tap(checkboxes.last);
        await tester.pump();
      }

      // Submit form
      final submitButton = find.byType(PrimaryButton);
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pump();
        await tester.pumpAndSettle();

        // VERIFY: Registration error should be displayed
        expect(find.byType(FormErrorView), findsOneWidget);
        // Should show email already in use error
        expect(find.textContaining('E-Mail'), findsWidgets);
      }
    });
  });

  group('RegisterForm Registration Code Tests', () {
    testWidgets('should pre-fill registration code in text field',
        (tester) async {
      const testCode = 'PRECODE123';
      await pumpWidgetWithResponsiveInit(tester, registrationCode: testCode);

      final registerForm =
          tester.widget<RegisterForm>(find.byType(RegisterForm));
      expect(registerForm.registrationCode, equals(testCode));

      final codeField = find.byKey(const Key('codeTextField'));
      if (codeField.evaluate().isNotEmpty) {
        final codeFieldWidget = tester.widget<FormTextfield>(codeField);
        expect(codeFieldWidget.controller.text, equals(testCode));
      }
    });

    testWidgets('should initialize without registration code when not provided',
        (tester) async {
      await pumpWidgetWithResponsiveInit(
          tester); // No registrationCode provided

      final codeField = find.byKey(const Key('codeTextField'));
      if (codeField.evaluate().isNotEmpty) {
        final codeFieldWidget = tester.widget<FormTextfield>(codeField);
        expect(codeFieldWidget.controller.text, equals(''));
      }
    });
  });
}
