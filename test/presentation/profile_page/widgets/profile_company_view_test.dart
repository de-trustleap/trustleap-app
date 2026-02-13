@TestOn('chrome')
library;

import 'package:finanzbegleiter/features/images/application/company/company_image_bloc.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company/company_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/cached_image_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/company_contact_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/company_image_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/profile_company_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../../mocks.mocks.dart';

class ProfileCompanyViewTestModule extends Module {
  final CompanyObserverCubit companyObserverCubit;
  final PermissionCubit permissionCubit;
  final CompanyImageBloc companyImageBloc;
  final CompanyCubit companyCubit;

  ProfileCompanyViewTestModule({
    required this.companyObserverCubit,
    required this.permissionCubit,
    required this.companyImageBloc,
    required this.companyCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<CompanyObserverCubit>(() => companyObserverCubit);
    i.addSingleton<PermissionCubit>(() => permissionCubit);
    i.addSingleton<CompanyImageBloc>(() => companyImageBloc);
    i.addSingleton<CompanyCubit>(() => companyCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockCompanyRepository mockCompanyRepository;
  late MockPermissionRepository mockPermissionRepository;
  late MockAuthRepository mockAuthRepository;
  late MockImageRepository mockImageRepository;
  late CompanyObserverCubit companyObserverCubit;
  late PermissionCubit permissionCubit;
  late CompanyImageBloc companyImageBloc;
  late CompanyCubit companyCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockCompanyRepository = MockCompanyRepository();
    mockPermissionRepository = MockPermissionRepository();
    mockAuthRepository = MockAuthRepository();
    mockImageRepository = MockImageRepository();
    companyObserverCubit = CompanyObserverCubit(mockCompanyRepository);
    permissionCubit = PermissionCubit(permissionRepo: mockPermissionRepository);
    companyImageBloc = CompanyImageBloc(mockImageRepository);
    companyCubit = CompanyCubit(mockCompanyRepository, mockAuthRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    companyObserverCubit.close();
    permissionCubit.close();
    companyImageBloc.close();
    companyCubit.close();
  });

  CustomUser createTestUser() {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      companyID: 'test-company-123',
      role: Role.promoter,
    );
  }

  Company createTestCompany() {
    return Company(
      id: UniqueID.fromUniqueString('test-company-123'),
      name: 'Test Company',
      industry: 'Technology',
      address: 'Test Street 123',
      postCode: '12345',
      place: 'Test City',
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
    required String companyID,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = ProfileCompanyViewTestModule(
      companyObserverCubit: companyObserverCubit,
      permissionCubit: permissionCubit,
      companyImageBloc: companyImageBloc,
      companyCubit: companyCubit,
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
          body: MultiBlocProvider(
            providers: [
              BlocProvider<CompanyObserverCubit>.value(
                  value: companyObserverCubit),
              BlocProvider<PermissionCubit>.value(value: permissionCubit),
              BlocProvider<CompanyImageBloc>.value(value: companyImageBloc),
              BlocProvider<CompanyCubit>.value(value: companyCubit),
            ],
            child: ProfileCompanyView(user: user, companyID: companyID),
          ),
        ),
      ),
    );
  }

  group('ProfileCompanyView Widget Tests', () {
    testWidgets('should show loading indicator initially', (tester) async {
      // Given
      final testUser = createTestUser();
      final testCompany = createTestCompany();

      when(mockCompanyRepository.observeCompany(any))
          .thenAnswer((_) => Stream.value(right(testCompany)));

      permissionCubit.emit(PermissionSuccessState(
          permissions: const Permissions(permissions: {"editCompany": true}),
          permissionInitiallyLoaded: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(
          createWidgetUnderTest(user: testUser, companyID: 'test-company-123'));
      await tester.pump();

      // Then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display company info when loaded with edit permission',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testCompany = createTestCompany();

      when(mockCompanyRepository.observeCompany(any))
          .thenAnswer((_) => Stream.value(right(testCompany)));

      permissionCubit.emit(PermissionSuccessState(
          permissions: const Permissions(permissions: {"editCompany": true}),
          permissionInitiallyLoaded: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
          createWidgetUnderTest(user: testUser, companyID: 'test-company-123'));
      await tester.pump();

      // When
      companyObserverCubit.emit(CompanyObserverSuccess(company: testCompany));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(CompanyImageSection), findsOneWidget);
      expect(find.byType(CompanyContactSection), findsOneWidget);
    });

    testWidgets(
        'should display cached image view when loaded without edit permission',
        (tester) async {
      // Given
      final testUser = createTestUser();
      final testCompany = createTestCompany();

      when(mockCompanyRepository.observeCompany(any))
          .thenAnswer((_) => Stream.value(right(testCompany)));

      permissionCubit.emit(PermissionSuccessState(
          permissions: const Permissions(permissions: {"editCompany": false}),
          permissionInitiallyLoaded: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
          createWidgetUnderTest(user: testUser, companyID: 'test-company-123'));
      await tester.pump();

      // When
      companyObserverCubit.emit(CompanyObserverSuccess(company: testCompany));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(CachedImageView), findsOneWidget);
      expect(find.byType(CompanyImageSection), findsNothing);
      expect(find.byType(CompanyContactSection), findsOneWidget);
    });

    testWidgets('should display error view when loading fails', (tester) async {
      // Given
      final testUser = createTestUser();

      when(mockCompanyRepository.observeCompany(any))
          .thenAnswer((_) => Stream.value(left(BackendFailure())));

      permissionCubit.emit(PermissionSuccessState(
          permissions: const Permissions(permissions: {"editCompany": true}),
          permissionInitiallyLoaded: true));

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
          createWidgetUnderTest(user: testUser, companyID: 'test-company-123'));
      await tester.pump();

      // When
      companyObserverCubit.emit(CompanyObserverFailure(failure: BackendFailure()));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(ErrorView), findsOneWidget);
    });
  });
}
