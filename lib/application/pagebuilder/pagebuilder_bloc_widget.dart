part of 'pagebuilder_bloc.dart';

extension PagebuilderBlocWidget on PagebuilderBloc {
  Future<void> onUpdateWidget(
      UpdateWidgetEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;

      final updatedSections = currentState.content.content?.sections?.map(
        (section) {
          final updatedWidgets = section.widgets
              ?.map(
                (widget) => PagebuilderWidgetTreeManipulator.updateWidget(
                  widget,
                  event.updatedWidget.id.value,
                  (_) => event.updatedWidget,
                ),
              )
              .toList();
          return section.copyWith(widgets: updatedWidgets);
        },
      ).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);

      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);

      if (!isUndoRedoOperation) {
        localHistory.saveToHistory(updatedPageBuilderContent);
      }

      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> onAddWidgetAtPosition(
      AddWidgetAtPositionEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections.map((section) {
        if (section.widgets == null || section.widgets!.isEmpty) {
          return section;
        }

        final updatedWidgets =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          section.widgets!,
          event.targetWidgetId,
          event.newWidget,
          event.position,
        );
        return section.copyWith(widgets: updatedWidgets);
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);

      if (!isUndoRedoOperation) {
        localHistory.saveToHistory(updatedPageBuilderContent);
      }

      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> onReplacePlaceholder(
      ReplacePlaceholderEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      // Update all sections and replace the placeholder with the new widget
      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets?.map((widget) {
          return PagebuilderWidgetTreeManipulator.updateWidget(
            widget,
            event.placeholderId,
            (placeholder) {
              final newWidget = PagebuilderWidgetFactory.createDefaultWidget(
                  event.widgetType);
              return newWidget.copyWith(
                widthPercentage: placeholder.widthPercentage,
              );
            },
          );
        }).toList();
        return section.copyWith(widgets: updatedWidgets);
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);

      if (!isUndoRedoOperation) {
        localHistory.saveToHistory(updatedPageBuilderContent);
      }

      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> onReorderWidget(
      ReorderWidgetEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets?.map((widget) {
          return PagebuilderWidgetTreeManipulator.reorderChildren(
              widget, event.parentWidgetId, event.oldIndex, event.newIndex);
        }).toList();
        return section.copyWith(widgets: updatedWidgets);
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);

      if (!isUndoRedoOperation) {
        localHistory.saveToHistory(updatedPageBuilderContent);
      }

      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }

  Future<void> onDeleteWidget(
      DeleteWidgetEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets
            ?.map((widget) =>
                PagebuilderWidgetTreeManipulator.deleteWidget(widget, event.widgetId))
            .where((widget) => widget != null)
            .cast<PageBuilderWidget>()
            .toList();
        return section.copyWith(widgets: updatedWidgets);
      }).toList();

      final updatedContent =
          currentState.content.content?.copyWith(sections: updatedSections);
      final updatedPageBuilderContent =
          currentState.content.copyWith(content: updatedContent);

      if (!isUndoRedoOperation) {
        localHistory.saveToHistory(updatedPageBuilderContent);
      }

      emit(GetLandingPageAndUserSuccessState(
        content: updatedPageBuilderContent,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: null,
        isUpdated: true,
      ));
    }
  }
}
