import 'package:finanzbegleiter/features/images/application/company/company_image_bloc.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/profile/domain/company.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_section.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/company_image_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

class CompanyImageSectionTestModule extends Module {
  final CompanyImageBloc companyImageBloc;

  CompanyImageSectionTestModule({required this.companyImageBloc});

  @override
  void binds(i) {
    i.addSingleton<CompanyImageBloc>(() => companyImageBloc);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockImageRepository mockImageRepository;
  late CompanyImageBloc companyImageBloc;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockImageRepository = MockImageRepository();
    companyImageBloc = CompanyImageBloc(mockImageRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    companyImageBloc.close();
  });

  Company createTestCompany({
    String? companyImageDownloadURL,
    String? thumbnailDownloadURL,
  }) {
    return Company(
      id: UniqueID.fromUniqueString('test-company-123'),
      name: 'Test Company',
      industry: 'Technology',
      address: 'Test Street 123',
      postCode: '12345',
      place: 'Test City',
      companyImageDownloadURL: companyImageDownloadURL,
      thumbnailDownloadURL: thumbnailDownloadURL,
    );
  }

  Widget createWidgetUnderTest({
    required Company company,
    Function? imageUploadSuccessful,
  }) {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = CompanyImageSectionTestModule(
      companyImageBloc: companyImageBloc,
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
          body: BlocProvider<CompanyImageBloc>.value(
            value: companyImageBloc,
            child: CompanyImageSection(
              company: company,
              imageUploadSuccessful: imageUploadSuccessful ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  group('CompanyImageSection Widget Tests', () {
    testWidgets('should display ImageSection', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // Then
      expect(find.byType(ImageSection), findsOneWidget);
    });

    testWidgets('should not show error initially', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should show loading state when uploading', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageUploadLoadingState());
      await tester.pump();
      await tester.pump();

      // Then
      final imageSection =
          tester.widget<ImageSection>(find.byType(ImageSection));
      expect(imageSection.isLoading, true);
    });

    testWidgets('should call imageUploadSuccessful callback on success',
        (tester) async {
      // Given
      final testCompany = createTestCompany();
      bool callbackCalled = false;

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(
        company: testCompany,
        imageUploadSuccessful: () {
          callbackCalled = true;
        },
      ));
      await tester.pump();

      // When
      companyImageBloc.emit(const CompanyImageUploadSuccessState(
        imageURL: 'https://example.com/image.jpg',
      ));
      await tester.pump();

      // Then
      expect(callbackCalled, true);
    });

    testWidgets('should show error when upload fails', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageUploadFailureState(
        failure: UnknownFailure(),
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should show error when file size exceeds limit',
        (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageExceedsFileSizeLimitFailureState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization
            .profile_page_image_section_validation_exceededFileSize),
        findsOneWidget,
      );
    });

    testWidgets('should show error when image is not valid', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageIsNotValidFailureState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_validation_not_valid),
        findsOneWidget,
      );
    });

    testWidgets('should show error when only one image allowed',
        (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageOnlyOneAllowedFailureState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_only_one_allowed),
        findsOneWidget,
      );
    });

    testWidgets('should show error when upload not found', (tester) async {
      // Given
      final testCompany = createTestCompany();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(CompanyImageUploadNotFoundFailureState());
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_upload_not_found),
        findsOneWidget,
      );
    });

    testWidgets('should update thumbnail URL when upload succeeds',
        (tester) async {
      // Given
      final testCompany = createTestCompany(
        thumbnailDownloadURL: 'https://example.com/old-thumbnail.jpg',
      );

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(company: testCompany));
      await tester.pump();

      // When
      companyImageBloc.emit(const CompanyImageUploadSuccessState(
        imageURL: 'https://example.com/new-image.jpg',
      ));
      await tester.pump();
      await tester.pump();

      // Then
      final imageSection =
          tester.widget<ImageSection>(find.byType(ImageSection));
      expect(imageSection.thumbnailDownloadURL,
          'https://example.com/new-image.jpg');
    });
  });
}
