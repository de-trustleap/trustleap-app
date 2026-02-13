import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_content.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_local_history.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PagebuilderLocalHistory history;
  late PagebuilderContent testContent1;
  late PagebuilderContent testContent2;
  late PagebuilderContent testContent3;

  setUp(() {
    history = PagebuilderLocalHistory();

    testContent1 = PagebuilderContent(
      landingPage: null,
      content: PageBuilderPage(
        id: UniqueID.fromUniqueString("page1"),
        sections: const [],
        backgroundColor: null,
        globalStyles: null,
      ),
      user: null,
    );

    testContent2 = PagebuilderContent(
      landingPage: null,
      content: PageBuilderPage(
        id: UniqueID.fromUniqueString("page2"),
        sections: const [],
        backgroundColor: null,
        globalStyles: null,
      ),
      user: null,
    );

    testContent3 = PagebuilderContent(
      landingPage: null,
      content: PageBuilderPage(
        id: UniqueID.fromUniqueString("page3"),
        sections: const [],
        backgroundColor: null,
        globalStyles: null,
      ),
      user: null,
    );
  });

  group("PagebuilderLocalHistory_InitialState", () {
    test("should not be able to undo initially", () {
      expect(history.canUndo(), false);
    });

    test("should not be able to redo initially", () {
      expect(history.canRedo(), false);
    });

    test("undo should return null when no history", () {
      expect(history.undo(), null);
    });

    test("redo should return null when no history", () {
      expect(history.redo(), null);
    });
  });

  group("PagebuilderLocalHistory_SaveToHistory", () {
    test("should be able to undo after saving to history", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      expect(history.canUndo(), true);
    });

    test("should not be able to redo after saving to history", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      expect(history.canRedo(), false);
    });

    test("should save multiple states to history", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);
      history.saveToHistory(testContent3);

      expect(history.canUndo(), true);
      expect(history.canRedo(), false);
    });
  });

  group("PagebuilderLocalHistory_Undo", () {
    test("should return previous state when undo is called", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      final result = history.undo();

      expect(result, testContent1);
    });

    test("should be able to redo after undo", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      history.undo();

      expect(history.canRedo(), true);
    });

    test("should handle multiple undo operations", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);
      history.saveToHistory(testContent3);

      final result1 = history.undo();
      final result2 = history.undo();

      expect(result1, testContent2);
      expect(result2, testContent1);
    });

    test("should not be able to undo when at the beginning", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      history.undo();
      history.undo();

      expect(history.canUndo(), false);
    });
  });

  group("PagebuilderLocalHistory_Redo", () {
    test("should return next state when redo is called", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      history.undo();
      final result = history.redo();

      expect(result, testContent2);
    });

    test("should handle multiple redo operations", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);
      history.saveToHistory(testContent3);

      history.undo();
      history.undo();

      final result1 = history.redo();
      final result2 = history.redo();

      expect(result1, testContent2);
      expect(result2, testContent3);
    });

    test("should not be able to redo when at the end", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);

      history.undo();
      history.redo();

      expect(history.canRedo(), false);
    });
  });

  group("PagebuilderLocalHistory_UndoRedoCombination", () {
    test("should handle undo and redo combination", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);
      history.saveToHistory(testContent3);

      final undo1 = history.undo();
      final undo2 = history.undo();
      final redo1 = history.redo();

      expect(undo1, testContent2);
      expect(undo2, testContent1);
      expect(redo1, testContent2);
    });

    test("should clear redo history when new state is saved after undo", () {
      history.saveToHistory(testContent1);
      history.saveToHistory(testContent2);
      history.saveToHistory(testContent3);

      history.undo();
      history.saveToHistory(PagebuilderContent(
        landingPage: LandingPage(
          id: UniqueID.fromUniqueString("lp1"),
          ownerID: UniqueID.fromUniqueString("user1"),
          name: "New Landing Page",
          contentID: null,
        ),
        content: testContent1.content,
        user: null,
      ));

      expect(history.canRedo(), false);
    });
  });

  group("PagebuilderLocalHistory_MaxHistorySize", () {
    test("should limit history to max size", () {
      // Füge 11 Einträge hinzu (mehr als maxHistorySize von 10)
      for (int i = 0; i < 11; i++) {
        history.saveToHistory(PagebuilderContent(
          landingPage: null,
          content: PageBuilderPage(
            id: UniqueID.fromUniqueString("page$i"),
            sections: const [],
            backgroundColor: null,
            globalStyles: null,
          ),
          user: null,
        ));
      }

      // Zähle wie oft wir undo machen können
      // Bei 11 Einträgen und maxHistorySize 10 sollten wir 9 mal undo können
      // (vom letzten Eintrag zurück zum zweiten, da der erste entfernt wurde)
      int undoCount = 0;
      while (history.canUndo()) {
        history.undo();
        undoCount++;
      }

      expect(undoCount, 9);
    });
  });
}
