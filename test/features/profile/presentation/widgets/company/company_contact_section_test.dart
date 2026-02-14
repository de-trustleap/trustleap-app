@TestOn('chrome')
library;

import 'package:finanzbegleiter/features/images/application/company/company_image_bloc.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company/company_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/legals/domain/avv.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/company_contact_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks.mocks.dart';

class CompanyContactSectionTestModule extends Module {
  final CompanyCubit companyCubit;
  final PermissionCubit permissionCubit;
  final CompanyImageBloc companyImageBloc;

  CompanyContactSectionTestModule({
    required this.companyCubit,
    required this.permissionCubit,
    required this.companyImageBloc,
  });

  @override
  void binds(i) {
    i.addSingleton<CompanyCubit>(() => companyCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
    i.addSingleton<CompanyImageBloc>(() => companyImageBloc);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockCompanyRepository mockCompanyRepository;
  late MockAuthRepository mockAuthRepository;
  late MockPermissionRepository mockPermissionRepository;
  late MockImageRepository mockImageRepository;
  late CompanyCubit companyCubit;
  late PermissionCubit permissionCubit;
  late CompanyImageBloc companyImageBloc;

  // Helper to ignore overflow errors in tests
  void Function(FlutterErrorDetails)? originalOnError;

  void ignoreOverflowErrors() {
    originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.toString().contains('RenderFlex overflowed')) {
        originalOnError?.call(details);
      }
    };
  }

  void restoreErrorHandler() {
    FlutterError.onError = originalOnError;
  }

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockCompanyRepository = MockCompanyRepository();
    mockAuthRepository = MockAuthRepository();
    mockPermissionRepository = MockPermissionRepository();
    mockImageRepository = MockImageRepository();
    companyCubit = CompanyCubit(mockCompanyRepository, mockAuthRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
    companyImageBloc = CompanyImageBloc(mockImageRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    companyCubit.close();
    permissionCubit.close();
    companyImageBloc.close();
  });

  CustomUser createTestUser() {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      role: Role.promoter,
    );
  }

  Company createTestCompany({
    String? name,
    String? industry,
    String? websiteURL,
    String? address,
    String? postCode,
    String? place,
    String? phoneNumber,
    AVV? avv,
  }) {
    return Company(
      id: UniqueID.fromUniqueString('test-company-123'),
      name: name ?? 'Test Company',
      industry: industry ?? 'Technology',
      websiteURL: websiteURL,
      address: address ?? 'Test Street 123',
      postCode: postCode ?? '12345',
      place: place ?? 'Test City',
      phoneNumber: phoneNumber,
      avv: avv,
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
    required Company company,
    Function? changesSaved,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = CompanyContactSectionTestModule(
      companyCubit: companyCubit,
      permissionCubit: permissionCubit,
      companyImageBloc: companyImageBloc,
    );

    permissionCubit.emit(PermissionSuccessState(
        permissions: const Permissions(permissions: {"editCompany": true}),
        permissionInitiallyLoaded: true));

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
              BlocProvider<CompanyCubit>.value(value: companyCubit),
              BlocProvider<PermissionCubit>.value(value: permissionCubit),
              BlocProvider<CompanyImageBloc>.value(value: companyImageBloc),
            ],
            child: CompanyContactSection(
              user: user,
              company: company,
              changesSaved: changesSaved ?? () {},
              imageUploadSuccessful: () {},
            ),
          ),
        ),
      ),
    );
  }

  group('EmailSection Widget Tests', () {
    testWidgets('should display all form fields', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.byType(FormTextfield), findsNWidgets(7));
        expect(find.byType(PrimaryButton), findsWidgets);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should initialize fields with company data', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany(
          name: 'Tech Corp',
          industry: 'Software',
          websiteURL: 'https://example.com',
          address: 'Main Street 456',
          postCode: '54321',
          place: 'Berlin',
          phoneNumber: '+49123456789',
        );

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.text('Tech Corp'), findsOneWidget);
        expect(find.text('Software'), findsOneWidget);
        expect(find.text('https://example.com'), findsOneWidget);
        expect(find.text('Main Street 456'), findsOneWidget);
        expect(find.text('54321'), findsOneWidget);
        expect(find.text('Berlin'), findsOneWidget);
        expect(find.text('+49123456789'), findsOneWidget);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should not show error initially', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.byType(FormErrorView), findsNothing);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should call changesSaved callback on success', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();
        bool callbackCalled = false;

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(createWidgetUnderTest(
          user: testUser,
          company: testCompany,
          changesSaved: () {
            callbackCalled = true;
          },
        ));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // When
        companyCubit.emit(CompanyUpdateContactInformationSuccessState());
        await tester.pump();
        await tester.pump();

        // Then
        expect(callbackCalled, true);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should show error when update fails', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // When
        companyCubit.emit(CompanyUpdateContactInformationFailureState(
          failure: BackendFailure(),
        ));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.byType(FormErrorView), findsOneWidget);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should disable button when loading', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // When
        companyCubit.emit(CompanyUpdateContactInformationLoadingState());
        await tester.pump();
        await tester.pump();

        // Then
        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.disabled, true);
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should enable button after loading completes', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany(
          avv: AVV(
            approvedAt: DateTime(2024, 1, 1),
            downloadURL: 'https://example.com/avv.pdf',
            path: '/path/to/avv.pdf',
          ),
        );

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        companyCubit.emit(CompanyUpdateContactInformationLoadingState());
        await tester.pump();
        await tester.pump();

        // When
        companyCubit.emit(CompanyUpdateContactInformationSuccessState());
        await tester.pump();
        await tester.pump();

        // Then
        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.disabled, false);

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should display section title', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Then
        final localization =
            await AppLocalizations.delegate.load(const Locale('en'));
        expect(
          find.text(localization.profile_company_contact_section_title),
          findsOneWidget,
        );

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });
  });

  group('CompanyContactSection AVV Tests', () {
    testWidgets('should show AVV checkbox again when field is changed after AVV was approved', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given - Company with approved AVV
        final testUser = createTestUser();
        final testCompany = createTestCompany(
          name: 'Original Company Name',
          avv: AVV(
            approvedAt: DateTime(2024, 1, 1),
            downloadURL: 'https://example.com/avv.pdf',
            path: '/path/to/avv.pdf',
          ),
        );

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then - Checkbox should not be visible initially (AVV already approved)
        expect(find.byType(Checkbox), findsNothing);

        // When - User changes the company name field
        final nameField = find.byType(FormTextfield).first;
        await tester.enterText(nameField, 'New Company Name');
        await tester.pump();
        await tester.pump();

        // Then - AVV checkbox should now be visible
        expect(find.byType(Checkbox), findsOneWidget);

        // And - Button should be disabled until AVV is checked
        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.disabled, true);

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should show AVV checkbox when not approved', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany =
            createTestCompany(); // avv is null, so checkbox should show

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.byType(Checkbox), findsOneWidget);

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should disable save button when AVV not checked',
        (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        // When
        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // Then
        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.disabled, true);

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should show AVV PDF loading state', (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // When
        companyCubit.emit(CompanyGetAVVPDFLoadingState());
        await tester.pump();
        await tester.pump();

        // Then
        final localization =
            await AppLocalizations.delegate.load(const Locale('en'));
        expect(
          find.text(
              localization.profile_company_contact_section_avv_generating),
          findsOneWidget,
        );

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });

    testWidgets('should show error when AVV PDF generation fails',
        (tester) async {
      ignoreOverflowErrors();
      try {
        // Given
        final testUser = createTestUser();
        final testCompany = createTestCompany();

        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
            createWidgetUnderTest(user: testUser, company: testCompany));
        await tester.pump();
        await tester.pump();

        // When
        companyCubit.emit(CompanyGetAVVPDFFailureState(
          failure: BackendFailure(),
        ));
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.byType(FormErrorView), findsOneWidget);

        // Clean up pending timers
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      } finally {
        restoreErrorHandler();
      }
    });
  });
}
