import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/delete_account/profile_delete_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../../../mocks.mocks.dart';

class ProfileDeleteAccountFormTestModule extends Module {
  final ProfileCubit profileCubit;
  final AuthCubit authCubit;

  ProfileDeleteAccountFormTestModule({
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

    final module = ProfileDeleteAccountFormTestModule(
      profileCubit: profileCubit,
      authCubit: authCubit,
    );

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
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
              child: const ProfileDeleteAccountForm(),
            ),
          ),
        ),
      ),
    );
  }

  group('ProfileDeleteAccountForm Widget Tests', () {
    testWidgets('should display form fields', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(FormTextfield), findsOneWidget);
      expect(find.byType(SecondaryButton), findsOneWidget);
    });

    testWidgets('should display title and subtitle', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      // Title and button both have "Delete account" text
      expect(find.text(localization.delete_account_title), findsWidgets);
      expect(find.text(localization.delete_account_subtitle), findsOneWidget);
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

    testWidgets('should show loading indicator when deleting account',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfileAccountDeletionLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('should disable button when loading', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfileAccountDeletionLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      final button =
          tester.widget<SecondaryButton>(find.byType(SecondaryButton));
      expect(button.disabled, true);
    });

    testWidgets('should show error when deletion fails', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfileAccountDeletionFailureState(
        failure: InvalidPasswordFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should enable button after loading completes', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      profileCubit.emit(ProfileAccountDeletionLoadingState());
      await tester.pump();
      await tester.pump();

      // When
      profileCubit.emit(ProfileReauthenticateForAccountDeletionSuccessState());
      await tester.pump();
      await tester.pump();

      // Then
      final button =
          tester.widget<SecondaryButton>(find.byType(SecondaryButton));
      expect(button.disabled, false);
    });

    testWidgets('should show confirmation dialog on reauth success',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      profileCubit.emit(ProfileReauthenticateForAccountDeletionSuccessState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(CustomAlertDialog), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.delete_account_confirmation_alert_title),
        findsOneWidget,
      );
    });

    testWidgets('should display password placeholder', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.delete_account_password_placeholder),
        findsOneWidget,
      );
    });

    testWidgets('should display delete button title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      // Title and button both have "Delete account" text
      expect(
        find.text(localization.delete_account_button_title),
        findsWidgets,
      );
    });
  });
}
