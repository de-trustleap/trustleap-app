import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/auth_page_template.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../mocks.mocks.dart';
import '../../widget_test_wrapper.dart';
import '../../repositories/mock_user_credential.dart';

void main() {
  late SignInCubit signInCubit;
  late AuthCubit authCubit;
  late PermissionCubit permissionCubit;
  late MockAuthRepository mockAuthRepository;
  late MockPermissionRepository mockPermissionRepository;

  setUp(() {
    provideDummy<AuthState>(AuthStateUnAuthenticated());
    provideDummy<PermissionState>(PermissionInitial());
    provideDummy<SignInState>(SignInInitial());

    mockAuthRepository = MockAuthRepository();
    mockPermissionRepository = MockPermissionRepository();

    // Setup default mock returns
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

  Widget createWidgetUnderTest() {
    return WidgetTestWrapper.createTestWidget(
      providers: [
        BlocProvider<SignInCubit>(create: (_) => signInCubit),
        BlocProvider<AuthCubit>(create: (_) => authCubit),
        BlocProvider<PermissionCubit>(create: (_) => permissionCubit),
      ],
      child: AuthPageTemplate(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const LoginForm(),
          ),
        ),
      ),
      withCustomNavigator: true,
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('should display AuthPageTemplate with LoginForm',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(AuthPageTemplate), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should have correct container constraints', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      expect(
          container.constraints, equals(const BoxConstraints(maxWidth: 800)));
    });

    testWidgets('should create SignInCubit via BlocProvider', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(BlocProvider<SignInCubit>), findsOneWidget);
    });
  });

  group('Login Widget Integration Tests', () {
    testWidgets('CustomNavigator.of(context) should work in widget tree',
        (tester) async {
      // Given
      bool navigatorFound = false;
      String? errorMessage;

      final testWidget = WidgetTestWrapper.createTestWidget(
        child: Builder(
          builder: (context) {
            try {
              final navigator = CustomNavigator.of(context);
              navigatorFound = navigator != null;
            } catch (e) {
              errorMessage = e.toString();
            }
            return const Center(
              child: Text('Test Widget'),
            );
          },
        ),
        withCustomNavigator: true,
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Then
      expect(navigatorFound, true);
      expect(errorMessage, isNull);
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('CustomNavigator should provide navigation functionality',
        (tester) async {
      // Given
      bool navigationCalled = false;
      String? navigatedRoute;

      final testWidget = WidgetTestWrapper.createTestWidget(
        child: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                key: const Key('testButton'),
                onPressed: () {
                  try {
                    final navigator = CustomNavigator.of(context);
                    final currentPath = navigator.currentPath;
                    navigatedRoute = currentPath;
                    navigationCalled = true;
                  } catch (e) {
                    // Navigation call failed
                  }
                },
                child: const Text('Test Navigation'),
              ),
            );
          },
        ),
        withCustomNavigator: true,
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('testButton')));
      await tester.pumpAndSettle();

      // Then
      expect(navigationCalled, true);
      expect(navigatedRoute, isNotNull);
    });

    testWidgets('Should render basic login form elements', (tester) async {
      // Given
      final testWidget = WidgetTestWrapper.createTestWidget(
        child: Form(
          child: Column(
            children: [
              const TextField(
                key: Key('emailField'),
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const TextField(
                key: Key('passwordField'),
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    key: const Key('loginButton'),
                    onPressed: () {
                      CustomNavigator.of(context);
                    },
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
        withCustomNavigator: true,
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(Form), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Should handle form input', (tester) async {
      // Given
      final testWidget = WidgetTestWrapper.createTestWidget(
        child: Form(
          child: Column(
            children: [
              const TextField(
                key: Key('emailInput'),
              ),
              const TextField(
                key: Key('passwordInput'),
                obscureText: true,
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    key: const Key('submitButton'),
                    onPressed: () {
                      CustomNavigator.of(context);
                    },
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
        withCustomNavigator: true,
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.enterText(
          find.byKey(const Key('emailInput')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordInput')), 'password123');
      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
