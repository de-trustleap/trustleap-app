import 'dart:convert';

import 'package:finanzbegleiter/core/services/ai_pagebuilder_agent.dart';
import 'package:finanzbegleiter/core/services/ai_service.dart';

/// Test-Datei für den AI PageBuilder
///
/// ANLEITUNG:
/// 1. Gehe zu https://console.anthropic.com
/// 2. Erstelle einen API Key
/// 3. Ersetze 'DEIN_CLAUDE_API_KEY' unten
/// 4. Führe diesen Test aus: dart run lib/test_ai_pagebuilder.dart

Future<void> main() async {
  print('🤖 AI PageBuilder Test startet...\n');

  // HIER DEINEN CLAUDE API KEY EINFÜGEN:
  const apiKey =
      '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';

  if (apiKey == 'DEIN_CLAUDE_API_KEY') {
    print('❌ Bitte ersetze "DEIN_CLAUDE_API_KEY" mit deinem echten API Key!');
    print('   Gehe zu https://console.anthropic.com um einen zu erstellen.');
    return;
  }

  try {
    // AI Service und Agent initialisieren
    final aiService = AIService(apiKey: apiKey);
    final aiAgent = AIPageBuilderAgent(aiService: aiService);

    print('✅ AI Service initialisiert\n');

    // Test 1: Einfache Landing Page generieren
    print('📄 Test 1: Generiere Landing Page für Business...');

    /*final landingPage = await aiAgent.generateLandingPage(
      type: LandingPageType.business,
      parameters: {
        'businessName': 'Bella Vista Restaurant',
        'businessType': 'Italienisches Restaurant und Pizzeria',
      },
    );

    print('✅ Landing Page generiert!');
    print('   Sections: ${landingPage['sections']?.length ?? 0}');
    print('   Page ID: ${landingPage['id']}');

    // JSON schön formatiert ausgeben
    final prettyJson = const JsonEncoder.withIndent('  ').convert(landingPage);
    print('\n📋 Generierte Landing Page:');
    print('=' * 50);
    print(prettyJson);
    print('=' * 50); */

    // Test 3: Business Landing Page mit customDescription
    print(
        '\n📄 Test 3: Generiere Business Landing Page mit customDescription...');

    final businessPageWithDescription = await aiAgent.generateLandingPage(
      type: LandingPageType.business,
      parameters: {
        'businessName': 'Café Sonnenschein',
        'businessType': 'Gemütliches Café und Bäckerei',
      },
      customDescription: '''
Unser Café liegt mitten in der Altstadt in einem historischen Gebäude von 1890.
Wir bieten hausgemachte Kuchen, frisch gerösteten Kaffee und herzliche Atmosphäre.
Familienbetrieb in dritter Generation mit traditionellen Backrezepten.
Die Seite soll warm und gemütlich wirken, mit warmen Braun/Beige/Orange-Tönen.
Bitte eine Hero Section mit gemütlichem Café-Interieur im Hintergrund.
Schwerpunkt auf Handwerk, Tradition und familiäre Atmosphäre legen.
''',
    );

    print('✅ Business Landing Page mit customDescription generiert!');
    print(
        '   Sections: ${businessPageWithDescription['sections']?.length ?? 0}');
    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(businessPageWithDescription);
    print('\n📋 Generierte Landing Page:');
    print('=' * 50);
    print(prettyJson);
    // Test 4: Custom Landing Page
    print('\n📄 Test 4: Generiere Custom Landing Page...');

    final customPage = await aiAgent.generateLandingPage(
      type: LandingPageType.custom,
      customDescription:
          'Erstelle eine moderne Landing Page für ein Tech-Startup, das KI-Tools für kleine Unternehmen entwickelt. Die Seite soll vertrauenswürdig und innovativ wirken.',
    );

    print('✅ Custom Landing Page generiert!');
    print('   Sections: ${customPage['sections']?.length ?? 0}');

    print('\n🎉 Alle Tests erfolgreich abgeschlossen!');
    print(
        '\n💡 Du kannst jetzt das generierte JSON in deinen PageBuilder kopieren und testen.');
  } catch (e) {
    print('❌ Fehler beim Test: $e');

    if (e.toString().contains('401')) {
      print(
          '\n💡 Tipp: Überprüfe deinen API Key. Möglicherweise ist er ungültig.');
    } else if (e.toString().contains('rate_limit')) {
      print(
          '\n💡 Tipp: Du hast das Rate Limit erreicht. Warte einen Moment und versuche es erneut.');
    } else if (e.toString().contains('insufficient_quota')) {
      print(
          '\n💡 Tipp: Dein API Guthaben ist aufgebraucht. Füge Guthaben in der Anthropic Console hinzu.');
    }
  }
}

/// Hilfsfunktion um die Struktur einer Landing Page zu analysieren
void analyzeLandingPageStructure(Map<String, dynamic> page) {
  print('\n🔍 Landing Page Analyse:');
  print('   Page ID: ${page['id']}');
  print('   Background: ${page['backgroundColor']}');
  print('   Sections: ${page['sections']?.length ?? 0}');

  final sections = page['sections'] as List? ?? [];
  for (int i = 0; i < sections.length; i++) {
    final section = sections[i];
    final widgets = section['widgets'] as List? ?? [];
    print('   Section $i: ${section['id']} (${widgets.length} widgets)');

    for (int j = 0; j < widgets.length; j++) {
      final widget = widgets[j];
      print('     Widget $j: ${widget['elementType']} (${widget['id']})');
    }
  }
}
