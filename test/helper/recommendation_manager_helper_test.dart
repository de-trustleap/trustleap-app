import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_helper.dart';
import 'package:flutter/material.dart';
import '../mocks.mocks.dart';

void main() {
  late RecommendationManagerHelper helper;
  late AppLocalizations mockLocalization;

  setUp(() {
    mockLocalization = MockAppLocalizations();
    helper = RecommendationManagerHelper(localization: mockLocalization);
  });

  group('getExpiresInDaysCount', () {
    test('returns "1 Tag" when expiresAt is tomorrow', () {
      final helper =
          RecommendationManagerHelper(localization: mockLocalization);

      final now = DateTime(2024, 1, 1, 10, 0);
      final tomorrow = now.add(Duration(days: 1));

      final result = helper.getExpiresInDaysCount(tomorrow, now: now);
      expect(result, '1 Tag');
    });

    test('returns "5 Tagen" when expiresAt is in 5 days', () {
      final helper =
          RecommendationManagerHelper(localization: mockLocalization);

      final now = DateTime(2024, 1, 1);
      final inFiveDays = now.add(Duration(days: 5));

      final result = helper.getExpiresInDaysCount(inFiveDays, now: now);
      expect(result, '5 Tagen');
    });
  });

  group('getStringFromStatusLevel', () {
    test('returns correct string for each status level', () {
      expect(helper.getStringFromStatusLevel(0), 'Empfehlung ausgesprochen');
      expect(helper.getStringFromStatusLevel(1), 'Link geklickt');
      expect(helper.getStringFromStatusLevel(2), 'Kontakt aufgenommen');
      expect(helper.getStringFromStatusLevel(3), 'Empfehlung terminiert');
      expect(helper.getStringFromStatusLevel(4), 'Abgeschlossen');
      expect(helper.getStringFromStatusLevel(5), 'Nicht abgeschlossen');
    });

    test('returns null for unknown status level', () {
      expect(helper.getStringFromStatusLevel(99), null);
      expect(helper.getStringFromStatusLevel(null), null);
    });
  });
}
