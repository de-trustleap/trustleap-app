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

      final newWidget = _withLandingPageDefaults(
          event.newWidget, currentState.content.landingPage);

      final updatedSections = sections.map((section) {
        if (section.widgets == null || section.widgets!.isEmpty) {
          return section;
        }

        final updatedWidgets =
            PagebuilderWidgetTreeManipulator.addWidgetAtPositionInList(
          section.widgets!,
          event.targetWidgetId,
          newWidget,
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
              final newWidget = _withLandingPageDefaults(
                PagebuilderWidgetFactory.createDefaultWidget(event.widgetType),
                currentState.content.landingPage,
              );
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

  PageBuilderWidget _withLandingPageDefaults(
      PageBuilderWidget widget, LandingPage? landingPage) {
    switch (widget.elementType) {
      case PageBuilderWidgetType.calendly:
        final properties = widget.properties as PagebuilderCalendlyProperties;
        if (properties.calendlyEventURL != null) return widget;
        final url = landingPage?.calendlyEventURL;
        if (url == null) return widget;
        return widget.copyWith(
            properties: properties.copyWith(calendlyEventURL: url));
      case PageBuilderWidgetType.contactForm:
        final properties =
            widget.properties as PageBuilderContactFormProperties;
        if (properties.email != null) return widget;
        final email = landingPage?.contactEmailAddress;
        if (email == null) return widget;
        return widget.copyWith(
            properties: properties.copyWith(email: email));
      default:
        return widget;
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
