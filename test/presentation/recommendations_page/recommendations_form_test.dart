@TestOn('chrome')
library;

import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_reason.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendation_reason_picker.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../../mocks.mocks.dart';

class RecommendationsFormTestModule extends Module {
  final RecommendationsCubit recommendationsCubit;
  final UserObserverCubit userObserverCubit;

  RecommendationsFormTestModule({
    required this.recommendationsCubit,
    required this.userObserverCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<RecommendationsCubit>(() => recommendationsCubit);
    i.addSingleton<UserObserverCubit>(() => userObserverCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockUserRepository mockUserRepository;
  late MockLandingPageRepository mockLandingPageRepository;
  late MockAuthRepository mockAuthRepository;
  late RecommendationsCubit recommendationsCubit;
  late UserObserverCubit userObserverCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();

    mockUserRepository = MockUserRepository();
    mockLandingPageRepository = MockLandingPageRepository();
    mockAuthRepository = MockAuthRepository();

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.getSignedInUser()).thenReturn(none());

    // Mock getAllLandingPages to return empty list by default
    when(mockLandingPageRepository.getAllLandingPages(any))
        .thenAnswer((_) async => right([]));

    recommendationsCubit = RecommendationsCubit(
      mockUserRepository,
      mockLandingPageRepository,
    );

    userObserverCubit = UserObserverCubit(mockUserRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    recommendationsCubit.close();
    userObserverCubit.close();
  });

  CustomUser createTestUser({
    Role role = Role.company,
    String? firstName,
    String? lastName,
    List<String>? landingPageIDs,
    String? parentUserID,
    int? recommendationCountLast30Days,
  }) {
    return CustomUser(
      id: UniqueID.fromUniqueString('test-user-123'),
      firstName: firstName ?? 'Test',
      lastName: lastName ?? 'User',
      role: role,
      landingPageIDs: landingPageIDs ?? ['landing-page-1'],
      parentUserID: parentUserID,
      recommendationCountLast30Days: recommendationCountLast30Days ?? 0,
    );
  }

  Widget createWidgetUnderTest() {
    Modular.destroy();
    ResponsiveHelper.enableTestMode();

    final module = RecommendationsFormTestModule(
      recommendationsCubit: recommendationsCubit,
      userObserverCubit: userObserverCubit,
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
                BlocProvider<RecommendationsCubit>.value(
                    value: recommendationsCubit),
                BlocProvider<UserObserverCubit>.value(value: userObserverCubit),
              ],
              child: const RecommendationsForm(),
            ),
          ),
        ),
      ),
    );
  }

  group('RecommendationsForm Widget Tests', () {
    testWidgets('should display loading indicator initially', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('should display empty page when no landing pages configured',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // When - Emit UserObserverSuccess first, then NoReasonsState
      final testUser = createTestUser(role: Role.company, landingPageIDs: []);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      recommendationsCubit.emit(RecommendationNoReasonsState());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(EmptyPage), findsOneWidget);
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.recommendation_missing_landingpage_title),
          findsOneWidget);
    });

    testWidgets('should display form title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(role: Role.company);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.recommendations_title), findsOneWidget);
    });

    testWidgets('should display three form textfields', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(role: Role.company);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(FormTextfield), findsNWidgets(3));
    });

    testWidgets('should display add button', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(role: Role.company);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
    });

    testWidgets('should display reason picker when reasons are available',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(role: Role.company);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.byType(RecommendationReasonPicker), findsOneWidget);
    });

    testWidgets('should prefill promoter name for promoter role',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      final testUser = createTestUser(
        role: Role.promoter,
        firstName: 'John',
        lastName: 'Doe',
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Then
      final promoterField = find.byWidgetPredicate((widget) =>
          widget is FormTextfield && widget.controller.text == 'John Doe');
      expect(promoterField, findsOneWidget);
    });

    testWidgets('should prefill service provider name for company role',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      final testUser = createTestUser(
        role: Role.company,
        firstName: 'Jane',
        lastName: 'Smith',
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pumpAndSettle();

      // Then
      final serviceProviderField = find.byWidgetPredicate((widget) =>
          widget is FormTextfield && widget.controller.text == 'Jane Smith');
      expect(serviceProviderField, findsOneWidget);
    });

    testWidgets('should display field placeholders', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(role: Role.company);
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.recommendations_form_promoter_placeholder),
          findsOneWidget);
      expect(
          find.text(
              localization.recommendations_form_service_provider_placeholder),
          findsOneWidget);
      expect(
          find.text(localization
              .recommendations_form_recommendation_name_placeholder),
          findsOneWidget);
    });

    testWidgets('should display recommendation limit info for promoter role',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(
        role: Role.promoter,
        recommendationCountLast30Days: 3,
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(
          find.text(localization.recommendations_limit_title), findsOneWidget);
      expect(find.text(localization.recommendations_limit_description),
          findsOneWidget);
    });

    testWidgets('should not display recommendation limit info for company role',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final testUser = createTestUser(
        role: Role.company,
        recommendationCountLast30Days: 3,
      );
      userObserverCubit.emit(UserObserverSuccess(user: testUser));
      await tester.pump();

      // When
      recommendationsCubit.emit(RecommendationGetReasonsSuccessState(
        reasons: [
          RecommendationReason(
            id: UniqueID.fromUniqueString('reason-1'),
            reason: 'Test Reason',
            isActive: true,
            promotionTemplate: 'Template',
          ),
        ],
      ));
      await tester.pump();
      await tester.pump();

      // Then
      final localization =
          await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(localization.recommendations_limit_title), findsNothing);
    });
  });
}
