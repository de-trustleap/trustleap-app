import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_content.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

class PagebuilderLocalHistory {
  final List<PagebuilderContent> _history = [];
  int _historyIndex = -1;
  static const int _maxHistorySize = 10;

  bool canUndo() => _historyIndex > 0;
  bool canRedo() => _historyIndex < _history.length - 1;

  void saveToHistory(PagebuilderContent content) {
    // Check if content is actually different from current history entry
    if (_historyIndex >= 0 && _historyIndex < _history.length) {
      final oldContent = _history[_historyIndex];
      final isEqual = oldContent == content;
      if (isEqual) {
        return;
      }
    }

    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(content.copyWith(
      content: content.content?.copyWith(
        sections: content.content?.sections
            ?.map((section) => section.copyWith(
                  widgets: section.widgets
                      ?.map((widget) => _deepCopyWidget(widget))
                      .toList(),
                ))
            .toList(),
      ),
    ));
    _historyIndex++;

    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  PagebuilderContent? undo() {
    if (canUndo()) {
      _historyIndex--;
      return _history[_historyIndex];
    }
    return null;
  }

  PagebuilderContent? redo() {
    if (canRedo()) {
      _historyIndex++;
      return _history[_historyIndex];
    }
    return null;
  }

  PageBuilderWidget _deepCopyWidget(PageBuilderWidget widget) {
    return widget.copyWith(
      children:
          widget.children?.map((child) => _deepCopyWidget(child)).toList(),
      containerChild: widget.containerChild != null
          ? _deepCopyWidget(widget.containerChild!)
          : null,
    );
  }
}
