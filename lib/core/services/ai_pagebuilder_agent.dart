import 'dart:convert';

import 'package:finanzbegleiter/core/services/ai_pagebuilder_prompts.dart';
import 'package:finanzbegleiter/core/services/ai_service.dart';

enum LandingPageType {
  financialAdvisor,
  business,
  event,
  custom,
}

class AIPageBuilderAgent {
  final AIService _aiService;

  AIPageBuilderAgent({required AIService aiService}) : _aiService = aiService;

  /// Generiert eine komplette Landing Page basierend auf Typ und Parametern
  Future<Map<String, dynamic>> generateLandingPage({
    required LandingPageType type,
    Map<String, String> parameters = const {},
    String? customDescription,
  }) async {
    String userPrompt;

    switch (type) {
      case LandingPageType.financialAdvisor:
        userPrompt = AIPageBuilderPrompts.getFinancialAdvisorPrompt(
          parameters['advisorName'] ?? 'Ihr Name',
          parameters['specialization'] ?? 'Finanzberatung',
        );
        break;
      case LandingPageType.business:
        userPrompt = AIPageBuilderPrompts.getBusinessPrompt(
          parameters['advisorName'] ??
              parameters['businessName'] ??
              'Ihr Unternehmen',
          parameters['specialization'] ??
              parameters['businessType'] ??
              'Ihr Geschäftsbereich',
          customDescription,
        );
        break;
      case LandingPageType.custom:
        userPrompt = AIPageBuilderPrompts.getCustomPrompt(
          customDescription ?? 'Erstelle eine moderne Landing Page',
        );
        break;
      default:
        throw ArgumentError('Landing page type not implemented yet');
    }

    try {
      final result = await _aiService.generateJSON(
        systemPrompt: AIPageBuilderPrompts.systemPrompt,
        userPrompt: userPrompt,
      );

      // Validiere die Grundstruktur
      _validatePageStructure(result);

      return result;
    } catch (e) {
      throw AIPageBuilderException('Failed to generate landing page: $e');
    }
  }

  /// Generiert eine einzelne Section basierend auf Beschreibung
  Future<Map<String, dynamic>> generateSection({
    required String sectionDescription,
    String? targetSectionId,
  }) async {
    final userPrompt = '''
Erstelle eine einzelne Section für eine Landing Page:

BESCHREIBUNG: $sectionDescription

${targetSectionId != null ? 'TARGET_SECTION_ID für anchorButtons: $targetSectionId' : ''}

ANFORDERUNGEN:
- Nur eine Section zurückgeben (nicht die komplette Page)
- Section muss valide JSON Struktur haben
- Passende Widgets für die Beschreibung wählen
- Konsistente Farbgestaltung
''';

    try {
      final result = await _aiService.generateJSON(
        systemPrompt: AIPageBuilderPrompts.systemPrompt,
        userPrompt: userPrompt,
      );

      // Validiere Section Struktur
      _validateSectionStructure(result);

      return result;
    } catch (e) {
      throw AIPageBuilderException('Failed to generate section: $e');
    }
  }

  /// Erweitert eine bestehende Landing Page um eine neue Section
  Future<Map<String, dynamic>> addSectionToPage({
    required Map<String, dynamic> existingPage,
    required String sectionDescription,
  }) async {
    final userPrompt = '''
Erweitere diese bestehende Landing Page um eine neue Section:

BESTEHENDE PAGE:
${jsonEncode(existingPage)}

NEUE SECTION BESCHREIBUNG: $sectionDescription

ANFORDERUNGEN:
- Komplette Page mit neuer Section zurückgeben
- Farbschema der bestehenden Page beibehalten
- IDs müssen eindeutig sein
- Stil konsistent halten
''';

    try {
      final result = await _aiService.generateJSON(
        systemPrompt: AIPageBuilderPrompts.systemPrompt,
        userPrompt: userPrompt,
      );

      _validatePageStructure(result);

      return result;
    } catch (e) {
      throw AIPageBuilderException('Failed to add section to page: $e');
    }
  }

  /// Optimiert eine bestehende Landing Page basierend auf Feedback
  Future<Map<String, dynamic>> optimizePage({
    required Map<String, dynamic> existingPage,
    required String feedback,
  }) async {
    final userPrompt = '''
Optimiere diese Landing Page basierend auf dem Feedback:

BESTEHENDE PAGE:
${jsonEncode(existingPage)}

FEEDBACK: $feedback

ANFORDERUNGEN:
- Komplette optimierte Page zurückgeben
- Nur die angesprochenen Bereiche ändern
- Struktur und IDs beibehalten wo möglich
- Verbesserungen basierend auf Feedback umsetzen
''';

    try {
      final result = await _aiService.generateJSON(
        systemPrompt: AIPageBuilderPrompts.systemPrompt,
        userPrompt: userPrompt,
      );

      _validatePageStructure(result);

      return result;
    } catch (e) {
      throw AIPageBuilderException('Failed to optimize page: $e');
    }
  }

  /// Validiert die Grundstruktur einer Landing Page
  void _validatePageStructure(Map<String, dynamic> page) {
    if (!page.containsKey('id')) {
      throw AIPageBuilderException('Page missing required "id" field');
    }
    if (!page.containsKey('sections')) {
      throw AIPageBuilderException('Page missing required "sections" field');
    }
    if (page['sections'] is! List) {
      throw AIPageBuilderException('Page "sections" must be a list');
    }

    final sections = page['sections'] as List;
    for (int i = 0; i < sections.length; i++) {
      try {
        _validateSectionStructure(sections[i]);
      } catch (e) {
        throw AIPageBuilderException('Section $i validation failed: $e');
      }
    }
  }

  /// Validiert die Struktur einer Section
  void _validateSectionStructure(Map<String, dynamic> section) {
    if (!section.containsKey('id')) {
      throw AIPageBuilderException('Section missing required "id" field');
    }
    if (!section.containsKey('layout')) {
      throw AIPageBuilderException('Section missing required "layout" field');
    }
    if (!section.containsKey('widgets')) {
      throw AIPageBuilderException('Section missing required "widgets" field');
    }
    if (section['widgets'] is! List) {
      throw AIPageBuilderException('Section "widgets" must be a list');
    }

    // Validiere Layout Werte
    final layout = section['layout'];
    if (layout != 'column' && layout != 'row') {
      throw AIPageBuilderException('Section layout must be "column" or "row"');
    }
  }

  /// Erstellt einen Beispiel-Prompt für Benutzer
  static String getExamplePrompt(LandingPageType type) {
    switch (type) {
      case LandingPageType.financialAdvisor:
        return 'Erstelle eine Landing Page für Max Mustermann, Spezialist für Altersvorsorge und Vermögensaufbau';
      case LandingPageType.business:
        return 'Erstelle eine Landing Page für eine IT-Beratung, die sich auf kleine und mittlere Unternehmen spezialisiert';
      case LandingPageType.event:
        return 'Erstelle eine Landing Page für ein Finanz-Webinar am 15. März 2024 in München';
      case LandingPageType.custom:
        return 'Erstelle eine moderne Landing Page für...';
    }
  }
}

class AIPageBuilderException implements Exception {
  final String message;
  AIPageBuilderException(this.message);

  @override
  String toString() => 'AIPageBuilderException: $message';
}

// TODO: LADESCREEN EINFÜGEN
// TODO: CUSTOM DESCRIPTION EINSCHRÄNKEN (FERTIG)
// TODO: JSON IN PROMPT ERWEITERN. ERSTELLT IMMER DAS GLEICHE TEMPLATE (FERTIG)
// TODO: TESTS
// TODO: LOCALIZATION
