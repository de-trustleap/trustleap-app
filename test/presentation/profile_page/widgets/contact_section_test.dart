import 'package:finanzbegleiter/features/images/application/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/contact_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../mocks.mocks.dart';

class ContactSectionTestModule extends Module {
  final ProfileCubit profileCubit;
  final ProfileImageBloc profileImageBloc;

  ContactSectionTestModule({required this.profileCubit, required this.profileImageBloc});

  @override
  void binds(i) {
    i.addSingleton<ProfileCubit>(() => profileCubit);
    i.addSingleton<ProfileImageBloc>(() => profileImageBloc);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late MockImageRepository mockImageRepository;
  late ProfileCubit profileCubit;
  late ProfileImageBloc profileImageBloc;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
    mockImageRepository = MockImageRepository();

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());

    profileCubit = ProfileCubit(
      authRepo: mockAuthRepository,
      userRepo: mockUserRepository,
    );

    profileImageBloc = ProfileImageBloc(
      mockImageRepository,
    );
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    profileCubit.close();
    profileImageBloc.close();
  });

  CustomUser createTestUser({
    String? firstName,
    String? lastName,
    String? address,
    String? postCode,
    String? place,
    Gender? gender,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      email: 'john.doe@example.com',
      address: address,
      postCode: postCode,
      place: place,
      gender: gender,
      role: Role.promoter,
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
    Function? changesSaved,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = ContactSectionTestModule(
      profileCubit: profileCubit,
      profileImageBloc: profileImageBloc,
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
          body: BlocProvider<ProfileImageBloc>.value(
            value: profileImageBloc,
            child: ContactSection(
              user: user,
              changesSaved: changesSaved ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  group('ContactSection Widget Tests', () {
    testWidgets('should display all form fields', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(GenderPicker), findsOneWidget);
      expect(find.byType(FormTextfield), findsNWidgets(5)); // firstName, lastName, address, postcode, place
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should initialize fields with user data', (tester) async {
      // Given
      final testUser = createTestUser(
        firstName: 'Jane',
        lastName: 'Smith',
        address: 'Main Street 123',
        postCode: '12345',
        place: 'Berlin',
        gender: Gender.female,
      );

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Smith'), findsOneWidget);
      expect(find.text('Main Street 123'), findsOneWidget);
      expect(find.text('12345'), findsOneWidget);
      expect(find.text('Berlin'), findsOneWidget);
    });

    testWidgets('should not show error initially', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should show PrimaryButton', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(PrimaryButton), findsOneWidget);

      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_contact_section_form_save_button_title),
        findsOneWidget,
      );
    });

    testWidgets('should display section title', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_contact_section_title),
        findsOneWidget,
      );
    });

    testWidgets('should call changesSaved callback on success', (tester) async {
      // Given
      final testUser = createTestUser();
      bool callbackCalled = false;

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(
        user: testUser,
        changesSaved: () {
          callbackCalled = true;
        },
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // When
      profileCubit.emit(ProfileUpdateContactInformationSuccessState());
      await tester.pump();

      // Then
      expect(callbackCalled, true);
    });

    testWidgets('should show error when update fails', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // When
      profileCubit.emit(ProfileUpdateContactInformationFailureState(
        failure: BackendFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should enable validation mode when ProfileShowValidationState is emitted', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // When
      profileCubit.emit(ProfileShowValidationState());
      await tester.pump();
      await tester.pump();

      // Then
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.autovalidateMode, AutovalidateMode.always);
    });

    testWidgets('should disable button when loading', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // When
      profileCubit.emit(ProfileUpdateContactInformationLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, true);
      expect(button.isLoading, true);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should enable button after loading completes', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      profileCubit.emit(ProfileUpdateContactInformationLoadingState());
      await tester.pump();
      await tester.pump();

      // When
      profileCubit.emit(ProfileUpdateContactInformationSuccessState());
      await tester.pump();
      await tester.pump();

      // Then
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, false);

      // Clean up pending timers
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    });

    testWidgets('should have proper field labels', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_contact_section_form_firstname),
        findsOneWidget,
      );
      expect(
        find.text(localization.profile_page_contact_section_form_lastname),
        findsOneWidget,
      );
      expect(
        find.text(localization.profile_page_contact_section_form_address),
        findsOneWidget,
      );
      expect(
        find.text(localization.profile_page_contact_section_form_postcode),
        findsOneWidget,
      );
      expect(
        find.text(localization.profile_page_contact_section_form_place),
        findsOneWidget,
      );
    });

    testWidgets('should initialize with empty fields when user has no data', (tester) async {
      // Given
      final testUser = createTestUser(
        firstName: null,
        lastName: null,
        address: null,
        postCode: null,
        place: null,
        gender: null,
      );

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Then
      expect(find.byType(GenderPicker), findsOneWidget);
      expect(find.byType(FormTextfield), findsNWidgets(5));
    });
  });
}
