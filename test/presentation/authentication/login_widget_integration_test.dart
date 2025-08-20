import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../widget_test_wrapper.dart';

void main() {
  group('Login Widget Integration Tests', () {
    testWidgets('CustomNavigator.of(context) should work in widget tree',
        (tester) async {
      // Given
      bool navigatorFound = false;
      String? errorMessage;

      final testWidget = WidgetTestWrapper.createApp(
        child: Builder(
          builder: (context) {
            try {
              final navigator = CustomNavigator.of(context);
              navigatorFound = navigator != null;
            } catch (e) {
              errorMessage = e.toString();
            }
            return const Center(
              child: Text('Test Widget'),
            );
          },
        ),
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Then
      expect(navigatorFound, true);
      expect(errorMessage, isNull);
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('CustomNavigator should provide navigation functionality',
        (tester) async {
      // Given
      bool navigationCalled = false;
      String? navigatedRoute;

      final testWidget = WidgetTestWrapper.createApp(
        child: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                key: const Key('testButton'),
                onPressed: () {
                  try {
                    final navigator = CustomNavigator.of(context);
                    final currentPath = navigator.currentPath;
                    navigatedRoute = currentPath;
                    navigationCalled = true;
                  } catch (e) {
                    // Navigation call failed
                  }
                },
                child: const Text('Test Navigation'),
              ),
            );
          },
        ),
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('testButton')));
      await tester.pumpAndSettle();

      // Then
      expect(navigationCalled, true);
      expect(navigatedRoute, isNotNull);
    });

    testWidgets('Should render basic login form elements', (tester) async {
      // Given
      final testWidget = WidgetTestWrapper.createApp(
        child: Form(
          child: Column(
            children: [
              const TextField(
                key: Key('emailField'),
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const TextField(
                key: Key('passwordField'),
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    key: const Key('loginButton'),
                    onPressed: () {
                      CustomNavigator.of(context);
                    },
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(Form), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Should handle form input', (tester) async {
      // Given
      final testWidget = WidgetTestWrapper.createApp(
        child: Form(
          child: Column(
            children: [
              const TextField(
                key: Key('emailInput'),
              ),
              const TextField(
                key: Key('passwordInput'),
                obscureText: true,
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    key: const Key('submitButton'),
                    onPressed: () {
                      CustomNavigator.of(context);
                    },
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      // When
      await tester.pumpWidget(testWidget);
      await tester.enterText(
          find.byKey(const Key('emailInput')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordInput')), 'password123');
      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
