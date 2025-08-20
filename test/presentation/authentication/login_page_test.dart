import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/auth_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../mocks.mocks.dart';
import '../../widget_test_helper.dart';
import '../../widget_test_wrapper.dart';

void main() {
  late MockSignInCubit mockSignInCubit;
  late MockAuthCubit mockAuthCubit;
  late MockPermissionCubit mockPermissionCubit;

  setUp(() {
    WidgetTestHelper.setupDummyValues();

    mockSignInCubit = WidgetTestHelper.createMockSignInCubit();
    mockAuthCubit = WidgetTestHelper.createMockAuthCubit();
    mockPermissionCubit = WidgetTestHelper.createMockPermissionCubit();

    Modular.bindModule(TestModule());
  });

  tearDown(() {
    Modular.destroy();
  });

  Widget createWidgetUnderTest() {
    return WidgetTestWrapper.createAppWithProviders(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => mockAuthCubit),
        BlocProvider<PermissionCubit>(create: (_) => mockPermissionCubit),
      ],
      child: AuthPageTemplate(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: BlocProvider(
              create: (context) => Modular.get<SignInCubit>(),
              child: const LoginForm(),
            ),
          ),
        ),
      ),
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
}
