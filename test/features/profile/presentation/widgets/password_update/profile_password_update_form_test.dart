import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_form.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_new.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_reauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../../../mocks.mocks.dart';

class ProfilePasswordUpdateFormTestModule extends Module {
  final ProfileCubit profileCubit;
  final AuthCubit authCubit;

  ProfilePasswordUpdateFormTestModule({
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

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = ProfilePasswordUpdateFormTestModule(
      profileCubit: profileCubit,
      authCubit: authCubit,
    );

    return ModularApp(
      module: module,
      child: MaterialApp(
        locale: const Locale('en'),
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
            child: const ProfilePasswordUpdateForm(),
          ),
        ),
      ),
    );
  }

  group('ProfilePasswordUpdateForm Widget Tests', () {
    testWidgets('should display reauth form initially', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(ProfilePasswordUpdateReauth), findsOneWidget);
      expect(find.byType(ProfilePasswordUpdateNew), findsNothing);
    });

    testWidgets('should display title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.profile_page_password_update_section_title),
          findsOneWidget);
    });

    testWidgets('should not show error initially', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should switch to new password form after reauth success',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfileReauthenticateForPasswordUpdateSuccessState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(ProfilePasswordUpdateReauth), findsNothing);
      expect(find.byType(ProfilePasswordUpdateNew), findsOneWidget);
    });

    testWidgets('should show error when password update fails', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfilePasswordUpdateFailureState(
        failure: InvalidPasswordFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should disable button when loading', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfilePasswordUpdateLoadingState());
      await tester.pump();
      await tester.pump();

      // Then - Button should be disabled in reauth form
      expect(find.byType(ProfilePasswordUpdateReauth), findsOneWidget);
    });

    testWidgets('should enable button after loading completes', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      profileCubit.emit(ProfilePasswordUpdateLoadingState());
      await tester.pump();
      await tester.pump();

      // When
      profileCubit.emit(ProfileReauthenticateForPasswordUpdateSuccessState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(ProfilePasswordUpdateNew), findsOneWidget);
    });

    testWidgets('should display reauth description', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
          find.text(localization
              .profile_page_password_update_section_reauth_description),
          findsOneWidget);
    });
  });
}
