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

      _closeConfigMenuIfWidgetDeleted(event.widgetId, sections);

      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets
            ?.map((widget) => PagebuilderWidgetTreeManipulator.deleteWidget(
                widget, event.widgetId))
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

  void _closeConfigMenuIfWidgetDeleted(
      String deletedWidgetId, List<PageBuilderSection> sections) {
    final configMenuCubit = Modular.get<PagebuilderConfigMenuCubit>();
    final configMenuState = configMenuCubit.state;

    if (configMenuState is PageBuilderConfigMenuOpenedState) {
      final openedWidgetId = configMenuState.model.id.value;

      // Quick check: if the opened widget IS the deleted widget
      if (openedWidgetId == deletedWidgetId) {
        configMenuCubit.closeConfigMenu();
        return;
      }

      // Check if the opened widget is a child of the deleted widget (in OLD tree)
      for (final section in sections) {
        if (section.widgets != null) {
          for (final widget in section.widgets!) {
            final deletedWidget = PagebuilderWidgetTreeSearcher.findWidgetById(
                widget, deletedWidgetId);
            if (deletedWidget != null) {
              // Found the widget to be deleted, check if opened widget is inside it
              final openedWidgetInDeletedTree =
                  PagebuilderWidgetTreeSearcher.findWidgetById(
                      deletedWidget, openedWidgetId);
              if (openedWidgetInDeletedTree != null) {
                configMenuCubit.closeConfigMenu();
                return;
              }
            }
          }
        }
      }
    }
  }

  Future<void> onDuplicateWidget(
      DuplicateWidgetEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets?.map((widget) {
          return PagebuilderWidgetTreeManipulator.duplicateWidget(
            widget,
            event.widgetId,
            _duplicateWidgetWithNewIds,
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

  PageBuilderWidget _duplicateWidgetWithNewIds(PageBuilderWidget widget) {
    return widget.copyWith(
      id: UniqueID(),
      children: widget.children
          ?.map((child) => _duplicateWidgetWithNewIds(child))
          .toList(),
      containerChild: widget.containerChild != null
          ? _duplicateWidgetWithNewIds(widget.containerChild!)
          : null,
    );
  }
}
