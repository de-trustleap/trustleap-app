import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/password_forgotten_button.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';
import '../../../repositories/mock_user_credential.dart';
import '../../../widget_test_helper.dart';
import '../../../widget_test_wrapper.dart';

void main() {
  late MockSignInCubit mockSignInCubit;
  late MockAuthCubit mockAuthCubit;
  late MockPermissionCubit mockPermissionCubit;

  setUpAll(() async {
    // Force reset of Flutter test framework
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    WidgetTestHelper.setupDummyValues();

    // Create fresh mock instances
    mockSignInCubit = MockSignInCubit();
    mockAuthCubit = MockAuthCubit();
    mockPermissionCubit = MockPermissionCubit();

    // Setup basic stubs
    when(mockSignInCubit.state).thenReturn(SignInInitial());
    when(mockSignInCubit.stream)
        .thenAnswer((_) => Stream.value(SignInInitial()));
    when(mockAuthCubit.state).thenReturn(AuthStateUnAuthenticated());
    when(mockAuthCubit.stream)
        .thenAnswer((_) => Stream.value(AuthStateUnAuthenticated()));
    when(mockPermissionCubit.state).thenReturn(PermissionInitial());
    when(mockPermissionCubit.stream)
        .thenAnswer((_) => Stream.value(PermissionInitial()));

    // Setup method stubs to prevent errors
    when(mockSignInCubit.loginWithEmailAndPassword(any, any))
        .thenAnswer((_) async {});
    when(mockAuthCubit.checkForAuthState()).thenAnswer((_) async {});
    when(mockPermissionCubit.observePermissions()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return WidgetTestWrapper.createAppWithProviders(
      providers: [
        BlocProvider<SignInCubit>(create: (_) => mockSignInCubit),
        BlocProvider<AuthCubit>(create: (_) => mockAuthCubit),
        BlocProvider<PermissionCubit>(create: (_) => mockPermissionCubit),
      ],
      child: const LoginForm(),
    );
  }

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
      verify(mockSignInCubit.loginWithEmailAndPassword(
              "test@example.com", "password123"))
          .called(1);
    });

    testWidgets(
        'should call loginWithEmailAndPassword with null values when form validation fails',
        (tester) async {
      // Given
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When - leave fields empty and tap login
      await tester.tap(find.byKey(const Key("loginButton")));
      await tester.pumpAndSettle();

      // Then
      verify(mockSignInCubit.loginWithEmailAndPassword(null, null)).called(1);
    });

    testWidgets('should show loading state when SignInLoadingState is emitted',
        (tester) async {
      // Given
      when(mockSignInCubit.state).thenReturn(SignInLoadingState());
      when(mockSignInCubit.stream)
          .thenAnswer((_) => Stream.value(SignInLoadingState()));

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
      when(mockPermissionCubit.state).thenReturn(PermissionLoadingState());
      when(mockPermissionCubit.stream)
          .thenAnswer((_) => Stream.value(PermissionLoadingState()));

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

  group('LoginForm BlocListener Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets(
        'should call checkForAuthState when SignInSuccessState is emitted',
        (tester) async {
      // Given - create mock with success state
      final successMockCubit = MockSignInCubit();
      final successState = SignInSuccessState(creds: MockUserCredential());

      when(successMockCubit.state).thenReturn(successState);
      when(successMockCubit.stream)
          .thenAnswer((_) => Stream.value(successState));
      when(successMockCubit.loginWithEmailAndPassword(any, any))
          .thenAnswer((_) async {});

      final widget = WidgetTestWrapper.createAppWithProviders(
        providers: [
          BlocProvider<SignInCubit>(create: (_) => successMockCubit),
          BlocProvider<AuthCubit>(create: (_) => mockAuthCubit),
          BlocProvider<PermissionCubit>(create: (_) => mockPermissionCubit),
        ],
        child: const LoginForm(),
      );

      // When
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Then
      verify(mockAuthCubit.checkForAuthState()).called(1);
    });

    testWidgets(
        'should enable auto-validation when SignInShowValidationState is emitted',
        (tester) async {
      // Given
      when(mockSignInCubit.state).thenReturn(SignInShowValidationState());
      when(mockSignInCubit.stream)
          .thenAnswer((_) => Stream.value(SignInShowValidationState()));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.autovalidateMode, AutovalidateMode.always);
    });
  });
}
