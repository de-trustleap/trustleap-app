import 'package:finanzbegleiter/features/images/application/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_section.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/profile_image_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockImageRepository mockImageRepository;
  late ProfileImageBloc profileImageBloc;

  setUp(() {
    ResponsiveHelper.enableTestMode();
    mockImageRepository = MockImageRepository();
    profileImageBloc = ProfileImageBloc(mockImageRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    profileImageBloc.close();
  });

  CustomUser createTestUser({
    String? profileImageURL,
    String? thumbnailURL,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      profileImageDownloadURL: profileImageURL,
      thumbnailDownloadURL: thumbnailURL,
      role: Role.promoter,
    );
  }

  Widget createWidgetUnderTest({
    required CustomUser user,
    Function? imageUploadSuccessful,
  }) {
    return MaterialApp(
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
          child: ProfileImageSection(
            user: user,
            imageUploadSuccessful: imageUploadSuccessful ?? () {},
          ),
        ),
      ),
    );
  }

  group('ProfileImageSection Widget Tests', () {
    testWidgets('should display ImageSection', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      expect(find.byType(ImageSection), findsOneWidget);
    });

    testWidgets('should not show error initially', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsNothing);
    });

    testWidgets('should show error when upload fails', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileImageBloc.emit(ProfileImageIsNotValidFailureState());
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
    });

    testWidgets('should show exceeds file size error', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileImageBloc.emit(ProfileImageExceedsFileSizeLimitFailureState());
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_validation_exceededFileSize),
        findsOneWidget,
      );
    });

    testWidgets('should show only one allowed error', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileImageBloc.emit(ProfileImageOnlyOneAllowedFailureState());
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_only_one_allowed),
        findsOneWidget,
      );
    });

    testWidgets('should show upload not found error', (tester) async {
      // Given
      final testUser = createTestUser();

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(user: testUser));
      await tester.pump();

      // When
      profileImageBloc.emit(ProfileImageUploadNotFoundFailureState());
      await tester.pump();

      // Then
      expect(find.byType(FormErrorView), findsOneWidget);
      final localization = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(localization.profile_page_image_section_upload_not_found),
        findsOneWidget,
      );
    });

    testWidgets('should call imageUploadSuccessful callback on success', (tester) async {
      // Given
      final testUser = createTestUser();
      bool callbackCalled = false;

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest(
        user: testUser,
        imageUploadSuccessful: () {
          callbackCalled = true;
        },
      ));
      await tester.pump();

      // When
      profileImageBloc.emit(ProfileImageUploadSuccessState(imageURL: 'https://example.com/image.jpg'));
      await tester.pump();

      // Then
      expect(callbackCalled, true);
    });
  });
}
