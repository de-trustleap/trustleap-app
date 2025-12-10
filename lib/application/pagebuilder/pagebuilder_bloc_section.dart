part of 'pagebuilder_bloc.dart';

extension PagebuilderBlocSection on PagebuilderBloc {
  Future<void> onAddSection(
      AddSectionEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final currentPageBuilderContent = currentState.content;

      final List<PageBuilderWidget> sectionWidgets = [];

      if (event.columnCount == 1) {
        // Column with single placeholder for 1 column
        sectionWidgets.add(
          PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.column,
            properties: null,
            hoverProperties: null,
            children: [
              PageBuilderWidget(
                id: UniqueID(),
                elementType: PageBuilderWidgetType.placeholder,
                properties: null,
                hoverProperties: null,
                children: null,
                containerChild: null,
                widthPercentage: null,
                background: null,
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: null,
                alignment: null,
                customCSS: null,
              ),
            ],
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          ),
        );
      } else {
        // Column with Row containing multiple placeholders
        final rowChildren = List.generate(
          event.columnCount,
          (index) => PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.placeholder,
            properties: null,
            hoverProperties: null,
            children: null,
            containerChild: null,
            widthPercentage: PagebuilderResponsiveOrConstant.constant(
              100.0 / event.columnCount,
            ),
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          ),
        );

        sectionWidgets.add(
          PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.column,
            properties: null,
            hoverProperties: null,
            children: [
              PageBuilderWidget(
                id: UniqueID(),
                elementType: PageBuilderWidgetType.row,
                properties: null,
                hoverProperties: null,
                children: rowChildren,
                containerChild: null,
                widthPercentage: null,
                background: null,
                hoverBackground: null,
                padding: null,
                margin: null,
                maxWidth: null,
                alignment: null,
                customCSS: null,
              ),
            ],
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          ),
        );
      }

      final newSection = PageBuilderSection(
        id: UniqueID(),
        name: "Neue Section",
        layout: PageBuilderSectionLayout.column,
        widgets: sectionWidgets,
        background: null,
        maxWidth: null,
        backgroundConstrained: false,
        customCSS: null,
        fullHeight: null,
        visibleOn: null,
      );

      final updatedSections = [
        ...?currentPageBuilderContent.content?.sections,
        newSection,
      ];

      final updatedPage = currentPageBuilderContent.content?.copyWith(
        sections: updatedSections,
      );

      final updatedPageBuilderContent = currentPageBuilderContent.copyWith(
        content: updatedPage,
      );

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

  Future<void> onUpdateSection(
      UpdateSectionEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final updatedSections = currentState.content.content?.sections
          ?.map<PageBuilderSection>((section) {
        if (section.id == event.updatedSection.id) {
          return event.updatedSection;
        } else {
          return section;
        }
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

  Future<void> onUpdatePage(
      UpdatePageEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;

      final updatedPageBuilderContent =
          currentState.content.copyWith(content: event.updatedPage);

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

  Future<void> onDeleteSection(
      DeleteSectionEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections
          .where((section) => section.id.value != event.sectionId)
          .toList();

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

  Future<void> onReorderSections(
      ReorderSectionsEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = PagebuilderReorderHelper.reorderSections(
          sections, event.oldIndex, event.newIndex);

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

  Future<void> onDuplicateSection(
      DuplicateSectionEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      // Find the section to duplicate and its index
      final sectionIndex = sections.indexWhere(
        (section) => section.id.value == event.sectionId,
      );

      if (sectionIndex == -1) return;

      final sectionToDuplicate = sections[sectionIndex];

      // Create a deep copy with new IDs
      final duplicatedSection = _duplicateSectionWithNewIds(sectionToDuplicate);

      // Insert duplicated section right after the original
      final updatedSections = List<PageBuilderSection>.from(sections);
      updatedSections.insert(sectionIndex + 1, duplicatedSection);

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

  PageBuilderSection _duplicateSectionWithNewIds(PageBuilderSection section) {
    return section.copyWith(
      id: UniqueID(),
      name: "${section.name} (Kopie)",
      widgets: section.widgets
          ?.map((widget) => _duplicateWidgetWithNewIds(widget))
          .toList(),
    );
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
