@TestOn('chrome')
library;

import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_preview.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/tab_bar/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

class RecommendationPreviewTestModule extends Module {
  final RecommendationsAlertCubit recommendationsAlertCubit;

  RecommendationPreviewTestModule({
    required this.recommendationsAlertCubit,
  });

  @override
  void binds(i) {
    i.addSingleton<RecommendationsAlertCubit>(() => recommendationsAlertCubit);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const Scaffold());
  }
}

void main() {
  late MockRecommendationRepository mockRecommendationRepository;
  late RecommendationsAlertCubit recommendationsAlertCubit;

  setUp(() {
    ResponsiveHelper.enableTestMode();
    mockRecommendationRepository = MockRecommendationRepository();
    recommendationsAlertCubit = RecommendationsAlertCubit(mockRecommendationRepository);
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    Modular.destroy();
    recommendationsAlertCubit.close();
  });

  RecommendationItem createTestRecommendation({
    String? id,
    String? name,
    String? promoterName,
    String? serviceProviderName,
    String? reason,
    String? promotionTemplate,
    String? landingPageID,
    String? defaultLandingPageID,
  }) {
    return PersonalizedRecommendationItem(
      id: id ?? 'test-id-1',
      name: name ?? 'Max Mustermann',
      promoterName: promoterName ?? 'Hans Schmidt',
      serviceProviderName: serviceProviderName ?? 'Anna Müller',
      reason: reason ?? 'Test Reason',
      promotionTemplate: promotionTemplate ?? 'Hello [receiverName]!',
      landingPageID: landingPageID ?? 'test-landing-page-id',
      defaultLandingPageID: defaultLandingPageID ?? 'default-landing-page-id',
      statusLevel: null,
      statusTimestamps: null,
      userID: null,
      promoterImageDownloadURL: null,
    );
  }

  Widget createWidgetUnderTest({
    required List<RecommendationItem> leads,
    String? userID,
    bool disabled = false,
    Function(RecommendationItem)? onSaveSuccess,
  }) {
    Modular.destroy();

    final module = RecommendationPreviewTestModule(
      recommendationsAlertCubit: recommendationsAlertCubit,
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
            body: BlocProvider<RecommendationsAlertCubit>.value(
              value: recommendationsAlertCubit,
              child: RecommendationPreview(
                userID: userID ?? 'test-user-id',
                leads: leads,
                disabled: disabled,
                onSaveSuccess: onSaveSuccess ?? (_) {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('RecommendationPreview Widget Tests', () {
    testWidgets('should display single RecommendationTextField when one lead is provided',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(RecommendationTextField), findsOneWidget);
      expect(find.byType(TabBar), findsNothing);
    });

    testWidgets('should display TabBar when multiple leads are provided',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(id: '1', name: 'Person 1'),
        createTestRecommendation(id: '2', name: 'Person 2'),
        createTestRecommendation(id: '3', name: 'Person 3'),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(CustomTab), findsNWidgets(3));
      // Person 1 is selected by default, so it appears in the tab and the detail card
      expect(find.text('Person 1'), findsNWidgets(2));
      expect(find.text('Person 2'), findsOneWidget);
      expect(find.text('Person 3'), findsOneWidget);
    });

    testWidgets('should create RecommendationTextField for selected lead with multiple leads',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(id: '1', name: 'Person 1'),
        createTestRecommendation(id: '2', name: 'Person 2'),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Then
      // AnimatedSwitcher shows only the selected lead's content at a time
      expect(find.byType(RecommendationTextField), findsOneWidget);
    });

    testWidgets('should show empty widget when no leads are provided',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: []));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(RecommendationTextField), findsNothing);
      expect(find.byType(TabBar), findsNothing);
    });

    testWidgets('should pass disabled state to RecommendationTextField',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(
          createWidgetUnderTest(leads: [lead], disabled: true));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.disabled, isTrue);
    });

    testWidgets('should pass enabled state to RecommendationTextField by default',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.disabled, isFalse);
    });

    testWidgets('should display correct lead name in single recommendation view',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(name: 'John Doe');

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.leadName, equals('John Doe'));
    });

    testWidgets('should switch between tabs when tapping on different tabs',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(id: '1', name: 'Person 1'),
        createTestRecommendation(id: '2', name: 'Person 2'),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Tap on second tab
      await tester.tap(find.text('Person 2'));
      await tester.pumpAndSettle();

      // Then - verify tab is selected (TabBar should still be visible)
      expect(find.byType(TabBar), findsOneWidget);
      // Person 2 is now selected, so it appears in both the tab and the detail card
      expect(find.text('Person 2'), findsNWidgets(2));
    });

    testWidgets('should initialize text controller with template containing [LINK]',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        name: 'Max Mustermann',
        promotionTemplate: 'Hello [receiverName]!',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      // Template should parse [receiverName] and add [LINK]
      expect(textFieldWidget.controller.text, contains('Hello Max Mustermann!'));
      expect(textFieldWidget.controller.text, contains('[LINK]'));
    });

    testWidgets('should parse template with provider placeholders',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        name: 'Max Mustermann',
        serviceProviderName: 'Anna Müller',
        promotionTemplate: 'Contact [providerFirstName] [providerLastName]',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.controller.text, contains('Contact Anna Müller'));
    });

    testWidgets('should parse template with promoter placeholders',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        name: 'Max Mustermann',
        promoterName: 'Hans Schmidt',
        promotionTemplate: 'Recommended by [promoterFirstName] [promoterLastName]',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.controller.text, contains('Recommended by Hans Schmidt'));
    });

    testWidgets('should handle template with all placeholders',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        name: 'Max Mustermann',
        serviceProviderName: 'Anna Müller',
        promoterName: 'Hans Schmidt',
        promotionTemplate:
            'Hi [receiverName], [promoterName] recommends [providerName]',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textFieldWidget.controller.text,
          contains('Hi Max Mustermann, Hans Schmidt recommends Anna Müller'));
    });

    testWidgets('should handle empty promotion template',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        name: 'Max Mustermann',
        promotionTemplate: '',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textFieldWidget = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      // Should still have [LINK] appended
      expect(textFieldWidget.controller.text, equals('\n[LINK]'));
    });

    testWidgets('should create separate text controllers for multiple leads',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(
          id: '1',
          name: 'Person 1',
          promotionTemplate: 'Template for [receiverName]',
        ),
        createTestRecommendation(
          id: '2',
          name: 'Person 2',
          promotionTemplate: 'Different template for [receiverName]',
        ),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Then
      // AnimatedSwitcher only shows the selected lead's RecommendationTextField
      final firstTextField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(firstTextField.controller.text, contains('Template for Person 1'));

      // Tap on second tab to switch to second lead
      await tester.tap(find.text('Person 2'));
      await tester.pumpAndSettle();

      // Now check the second TextField is visible with correct template
      final secondTextField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(secondTextField.controller.text, contains('Different template for Person 2'));
    });

    testWidgets('should display email send button', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textField.onEmailSendPressed, isNotNull);
    });

    testWidgets('should have both WhatsApp and Email send callbacks',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textField.onSendPressed, isNotNull);
      expect(textField.onEmailSendPressed, isNotNull);
    });

    testWidgets('should pass email callback for multiple leads', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(id: '1', name: 'Person 1'),
        createTestRecommendation(id: '2', name: 'Person 2'),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Then
      final textFields = tester
          .widgetList<RecommendationTextField>(find.byType(RecommendationTextField))
          .toList();

      for (final textField in textFields) {
        expect(textField.onSendPressed, isNotNull);
        expect(textField.onEmailSendPressed, isNotNull);
      }
    });

    testWidgets('should create email callback with correct recommendation data',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation(
        id: 'test-email-id',
        name: 'Email Test Person',
        promoterName: 'Email Promoter',
      );

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: [lead]));
      await tester.pumpAndSettle();

      // Then
      final textField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textField.onEmailSendPressed, isNotNull);
      expect(textField.leadName, equals('Email Test Person'));
    });

    testWidgets('should maintain email functionality when switching tabs',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final leads = [
        createTestRecommendation(id: '1', name: 'Person 1'),
        createTestRecommendation(id: '2', name: 'Person 2'),
      ];

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: leads));
      await tester.pumpAndSettle();

      // Verify first tab has email callback
      final textFieldsBefore = tester
          .widgetList<RecommendationTextField>(find.byType(RecommendationTextField))
          .toList();
      expect(textFieldsBefore.first.onEmailSendPressed, isNotNull);

      // Switch to second tab
      await tester.tap(find.text('Person 2'));
      await tester.pumpAndSettle();

      // Then - verify second tab also has email callback
      final textFieldsAfter = tester
          .widgetList<RecommendationTextField>(find.byType(RecommendationTextField))
          .toList();

      for (final textField in textFieldsAfter) {
        expect(textField.onEmailSendPressed, isNotNull);
      }
    });

    testWidgets('should pass disabled state to email button', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final lead = createTestRecommendation();

      // When
      await tester.pumpWidget(
          createWidgetUnderTest(leads: [lead], disabled: true));
      await tester.pumpAndSettle();

      // Then
      final textField = tester.widget<RecommendationTextField>(
          find.byType(RecommendationTextField));
      expect(textField.disabled, isTrue);
      expect(textField.onEmailSendPressed, isNotNull);
    });

    testWidgets('should handle empty leads list without email callback errors',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(leads: []));
      await tester.pumpAndSettle();

      // Then - should not crash
      expect(find.byType(RecommendationTextField), findsNothing);
    });
  });
}
