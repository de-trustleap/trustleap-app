import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_register_company_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../mocks.mocks.dart';

class ProfileRegisterCompanySectionTestModule extends Module {
  final CompanyRequestCubit companyRequestCubit;

  ProfileRegisterCompanySectionTestModule({required this.companyRequestCubit});

  @override
  void binds(i) {
    i.addSingleton<CompanyRequestCubit>(() => companyRequestCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockCompanyRepository mockCompanyRepository;
  late MockUserRepository mockUserRepository;
  late CompanyRequestCubit companyRequestCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockCompanyRepository = MockCompanyRepository();
    mockUserRepository = MockUserRepository();

    companyRequestCubit =
        CompanyRequestCubit(mockCompanyRepository, mockUserRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    companyRequestCubit.close();
  });

  CustomUser createTestUser({
    String? pendingCompanyRequestID,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      pendingCompanyRequestID: pendingCompanyRequestID,
      role: Role.promoter,
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module =
        ProfileRegisterCompanySectionTestModule(companyRequestCubit: companyRequestCubit);

    return ModularApp(
      module: module,
      child: CustomNavigator.create(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<CompanyRequestCubit>.value(
              value: companyRequestCubit,
              child: ProfileRegisterCompanySection(user: user),
            ),
          ),
        ),
      ),
    );
  }

  group('ProfileRegisterCompanySection Widget Tests', () {
    testWidgets('should display section title', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_register_company_section_title),
        findsOneWidget,
      );
    });

    testWidgets('should display register button when no pending request',
        (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_register_company_section_button_title),
        findsOneWidget,
      );
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should display subtitle when no pending request',
        (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_register_company_section_subtitle),
        findsOneWidget,
      );
    });
  });

  group('ProfileRegisterCompanySection Pending Request Tests', () {
    testWidgets('should show loading when in loading state',
        (tester) async {
      // Given
      final testUser = createTestUser(pendingCompanyRequestID: 'test-request-123');

      when(mockCompanyRepository.getPendingCompanyRequest(any))
          .thenAnswer((_) async => right(CompanyRequest(
                id: UniqueID.fromUniqueString('test-request-123'),
                createdAt: DateTime(2024, 1, 1),
              )));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When - Emit loading state
      companyRequestCubit.emit(CompanyRequestLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('should show in progress message when request exists',
        (tester) async {
      // Given
      final testUser = createTestUser(pendingCompanyRequestID: 'test-request-123');
      final companyRequest = CompanyRequest(
        id: UniqueID.fromUniqueString('test-request-123'),
        createdAt: DateTime(2024, 1, 1),
      );

      when(mockCompanyRepository.getPendingCompanyRequest(any))
          .thenAnswer((_) async => right(companyRequest));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      companyRequestCubit.emit(PendingCompanyRequestSuccessState(request: companyRequest));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization
            .profile_register_company_section_subtitle_in_progress),
        findsOneWidget,
      );
    });

    testWidgets('should show requested date when request exists',
        (tester) async {
      // Given
      final testUser = createTestUser(pendingCompanyRequestID: 'test-request-123');
      final companyRequest = CompanyRequest(
        id: UniqueID.fromUniqueString('test-request-123'),
        createdAt: DateTime(2024, 1, 15),
      );

      when(mockCompanyRepository.getPendingCompanyRequest(any))
          .thenAnswer((_) async => right(companyRequest));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      companyRequestCubit.emit(PendingCompanyRequestSuccessState(request: companyRequest));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.textContaining(
            localization.profile_register_company_section_subtitle_requested_at),
        findsOneWidget,
      );
    });

    testWidgets('should show error when fetching pending request fails',
        (tester) async {
      // Given
      final testUser = createTestUser(pendingCompanyRequestID: 'test-request-123');

      when(mockCompanyRepository.getPendingCompanyRequest(any))
          .thenAnswer((_) async => left(BackendFailure()));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      companyRequestCubit.emit(PendingCompanyRequestFailureState(failure: BackendFailure()));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should NOT show register button when pending request exists',
        (tester) async {
      // Given
      final testUser = createTestUser(pendingCompanyRequestID: 'test-request-123');
      final companyRequest = CompanyRequest(
        id: UniqueID.fromUniqueString('test-request-123'),
        createdAt: DateTime(2024, 1, 1),
      );

      when(mockCompanyRepository.getPendingCompanyRequest(any))
          .thenAnswer((_) async => right(companyRequest));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      companyRequestCubit.emit(PendingCompanyRequestSuccessState(request: companyRequest));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_register_company_section_button_title),
        findsNothing,
      );
    });
  });
}
