import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/auth/presentation/password_forgotten_page.dart';
import 'package:finanzbegleiter/features/auth/presentation/widgets/password_forgotten_form.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/auth_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';
import '../../utils/test_module.dart';
import '../../widget_test_wrapper.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.observeAuthState())
        .thenAnswer((_) => Stream.empty());
  });

  tearDown(() {
    Modular.destroy();
  });

  Widget createWidgetUnderTest() {
    return WidgetTestWrapper.createTestWidget(
      child: const PasswordForgottenPage(),
      withNavigation: true,
      navigationModule: TestModule(
        mockAuthRepository: mockAuthRepository,
        testWidget: const PasswordForgottenPage(),
      ),
    );
  }

  group('PasswordForgottenPage Widget Tests', () {
    testWidgets('should display AuthPageTemplate', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(AuthPageTemplate), findsOneWidget);
    });

    testWidgets('should display PasswordForgottenForm', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(PasswordForgottenForm), findsOneWidget);
    });

    testWidgets('should display Center widget wrapping the form', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('should provide AuthCubit through TestModule', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Then - AuthCubit should be available through Modular
      expect(() => Modular.get<AuthCubit>(), isNot(throwsA(anything)));
    });
  });
}