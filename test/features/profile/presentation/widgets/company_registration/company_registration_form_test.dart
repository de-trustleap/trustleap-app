@TestOn('chrome')
library;

import 'package:finanzbegleiter/features/profile/application/company/company_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company_registration/company_registration_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../../../mocks.mocks.dart';

class CompanyRegistrationFormTestModule extends Module {
  final CompanyCubit companyCubit;

  CompanyRegistrationFormTestModule({required this.companyCubit});

  @override
  void binds(i) {
    i.addSingleton<CompanyCubit>(() => companyCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
    r.child('/home/profile', child: (_) => const Scaffold());
  }
}

void main() {
  late MockCompanyRepository mockCompanyRepository;
  late MockAuthRepository mockAuthRepository;
  late CompanyCubit companyCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockCompanyRepository = MockCompanyRepository();
    mockAuthRepository = MockAuthRepository();

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());

    companyCubit = CompanyCubit(
      mockCompanyRepository,
      mockAuthRepository,
    );
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    companyCubit.close();
  });

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = CompanyRegistrationFormTestModule(
      companyCubit: companyCubit,
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
            body: BlocProvider<CompanyCubit>.value(
              value: companyCubit,
              child: const CompanyRegistrationForm(),
            ),
          ),
        ),
      ),
    );
  }

  group('CompanyRegistrationForm Widget Tests', () {
    testWidgets('should display form title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.company_registration_form_title),
          findsOneWidget);
    });

    testWidgets('should display all form fields', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(FormTextfield), findsNWidgets(7));
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should display all field placeholders', (tester) async {
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
              .company_registration_form_name_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_industry_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_website_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_address_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_postcode_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_place_textfield_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .company_registration_form_phone_textfield_placeholder),
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

    testWidgets('should disable button initially when AVV not checked',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Then
      final button =
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, true);
    });

    testWidgets('should enable button when AVV checkbox is checked',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Then
      final button =
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, false);
    });

    testWidgets('should disable button when AVV checkbox is unchecked',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // When
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Then
      final button =
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, true);
    });

    testWidgets('should show loading indicator when registering',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      companyCubit.emit(CompanyRegisterLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      final button =
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.isLoading, true);
    });

    testWidgets('should disable button when loading', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      companyCubit.emit(CompanyRegisterLoadingState());
      await tester.pump();

      // Then
      final button =
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.disabled, true);
    });

    testWidgets('should show error when registration fails', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      companyCubit.emit(CompanyRegisterFailureState(
        failure: BackendFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should show AVV checkbox', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(Checkbox), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
          find.text(localization
              .profile_company_contact_section_avv_checkbox_text),
          findsOneWidget);
      expect(
          find.text(
              localization.profile_company_contact_section_avv_checkbox_text_part2),
          findsOneWidget);
    });

    testWidgets('should show loading indicator when generating AVV PDF',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      companyCubit.emit(CompanyGetAVVPDFLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
          find.text(
              localization.profile_company_contact_section_avv_generating),
          findsOneWidget);
    });

    testWidgets('should show error when AVV PDF generation fails',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When
      companyCubit.emit(CompanyGetAVVPDFFailureState(
        failure: BackendFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should display register button title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
          find.text(
              localization.company_registration_form_register_button_title),
          findsOneWidget);
    });
  });
}
