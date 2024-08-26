import 'package:bloc_test/bloc_test.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/login_form.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:mocktail/mocktail.dart';
import 'test_widget_wrapper.dart';
import 'package:dartz/dartz.dart';

import '../app_localization_widget_mock.dart';
import '../test_module.dart';

class MockSignInCubit extends MockCubit<SignInState> implements SignInCubit {}

class FakeSignInState extends Fake implements SignInState {}

void main() async {
  late MockSignInCubit mockSignInCubit;

  setUp(() {
    mockSignInCubit = MockSignInCubit();
  });

  setUpAll(() async {
    registerFallbackValue(FakeSignInState());

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("LoginForm contains elements", (widgetTester) async {
    when(() => mockSignInCubit.state).thenReturn(SignInInitial());

    await widgetTester.pumpWidget(TestWidgetWrapper(
      child: BlocProvider<SignInCubit>.value(
        value: mockSignInCubit,
        child: LoginForm(),
      ),
    ));
    await widgetTester.pumpAndSettle();

    expect(find.byType(Form), findsOneWidget);
    expect(find.byKey(const Key("loginTextField")), findsOneWidget);
    expect(find.byKey(const Key("passwordTextField")), findsOneWidget);
    expect(find.byKey(const Key("passwordForgottenButton")), findsOneWidget);
    expect(find.byKey(const Key("loginButton")), findsOneWidget);
    expect(find.byKey(const Key("registerButton")), findsOneWidget);
    expect(find.byKey(const Key("formErrorView")), findsNothing);
    expect(find.byKey(const Key("loadingIndicator")), findsNothing);
  });

  testWidgets(
      "LoginForm shows LoadingIndicator when state is SignInLoadingState",
      (widgetTester) async {
    when(() => mockSignInCubit.state).thenReturn(SignInLoadingState());

    await widgetTester.pumpWidget(TestWidgetWrapper(
      child: BlocProvider<SignInCubit>.value(
        value: mockSignInCubit,
        child: LoginForm(),
      ),
    ));
    await widgetTester.pump(Duration(seconds: 1));

    expect(find.byType(Form), findsOneWidget);
    expect(find.byKey(const Key("loginTextField")), findsOneWidget);
    expect(find.byKey(const Key("passwordTextField")), findsOneWidget);
    expect(find.byKey(const Key("passwordForgottenButton")), findsOneWidget);
    expect(find.byKey(const Key("loginButton")), findsOneWidget);
    expect(find.byKey(const Key("registerButton")), findsOneWidget);
    expect(find.byKey(const Key("formErrorView")), findsNothing);
  });
}
