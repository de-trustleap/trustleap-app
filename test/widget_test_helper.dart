import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

/// Test module for providing mocked dependencies in widget tests
class TestModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<SignInCubit>(() => WidgetTestHelper.createMockSignInCubit());
    i.addSingleton<AuthCubit>(() => WidgetTestHelper.createMockAuthCubit());
    i.addSingleton<PermissionCubit>(
        () => WidgetTestHelper.createMockPermissionCubit());
  }

  @override
  void routes(r) {}
}

class WidgetTestHelper {
  static void setupDummyValues() {
    provideDummy<AuthState>(AuthStateUnAuthenticated());
    provideDummy<PermissionState>(PermissionInitial());
    provideDummy<SignInState>(SignInInitial());
  }

  static MockSignInCubit createMockSignInCubit() {
    final mock = MockSignInCubit();

    when(mock.state).thenReturn(SignInInitial());
    when(mock.stream).thenAnswer((_) => Stream.value(SignInInitial()));

    when(mock.loginWithEmailAndPassword(any, any)).thenAnswer((_) async {});
    when(mock.emit(any)).thenReturn(null);
    when(mock.close()).thenAnswer((_) async {});
    when(mock.isClosed).thenReturn(false);

    return mock;
  }

  static MockAuthCubit createMockAuthCubit() {
    final mock = MockAuthCubit();

    when(mock.state).thenReturn(AuthStateUnAuthenticated());
    when(mock.stream)
        .thenAnswer((_) => Stream.value(AuthStateUnAuthenticated()));

    when(mock.checkForAuthState()).thenAnswer((_) async {});
    when(mock.resetPassword(any)).thenAnswer((_) async {});
    when(mock.emit(any)).thenReturn(null);
    when(mock.close()).thenAnswer((_) async {});
    when(mock.isClosed).thenReturn(false);

    return mock;
  }

  static MockPermissionCubit createMockPermissionCubit() {
    final mock = MockPermissionCubit();

    when(mock.state).thenReturn(PermissionInitial());
    when(mock.stream).thenAnswer((_) => Stream.value(PermissionInitial()));

    when(mock.observePermissions()).thenAnswer((_) async {});
    when(mock.emit(any)).thenReturn(null);
    when(mock.close()).thenAnswer((_) async {});
    when(mock.isClosed).thenReturn(false);

    return mock;
  }
}
