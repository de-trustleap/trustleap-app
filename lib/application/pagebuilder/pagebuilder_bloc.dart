import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_local_history.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/helpers/pagebuilder_widget_tree_manipulator.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_reorder_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_factory.dart';
import 'package:rxdart/rxdart.dart';

part 'pagebuilder_event.dart';
part 'pagebuilder_state.dart';

class PagebuilderBloc extends Bloc<PagebuilderEvent, PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final PagebuilderRepository pageBuilderRepo;
  final UserRepository userRepo;

  final PagebuilderLocalHistory _localHistory = PagebuilderLocalHistory();
  bool _isUndoRedoOperation = false;

  static const _updateDebounceTime = Duration(milliseconds: 100);

  PagebuilderBloc({
    required this.landingPageRepo,
    required this.pageBuilderRepo,
    required this.userRepo,
  }) : super(PagebuilderInitial()) {
    on<GetLandingPageEvent>(_onGetLandingPage);
    on<GetLandingPageContentEvent>(_onGetLandingPageContent);
    on<UpdateWidgetEvent>(_onUpdateWidget,
        transformer: (events, mapper) =>
            events.debounceTime(_updateDebounceTime).switchMap(mapper));
    on<UpdateSectionEvent>(_onUpdateSection,
        transformer: (events, mapper) =>
            events.debounceTime(_updateDebounceTime).switchMap(mapper));
    on<ReorderSectionsEvent>(_onReorderSections);
    on<ReorderWidgetEvent>(_onReorderWidget);
    on<SaveLandingPageContentEvent>(_onSaveLandingPageContent);
    on<UndoPagebuilderEvent>(_onUndo);
    on<RedoPagebuilderEvent>(_onRedo);
    on<AddWidgetAtPositionEvent>(_onAddWidgetAtPosition);
    on<AddSectionEvent>(_onAddSection);
    on<ReplacePlaceholderEvent>(_onReplacePlaceholder);
  }

  bool canUndo() => _localHistory.canUndo();
  bool canRedo() => _localHistory.canRedo();

  void _onUndo(
      UndoPagebuilderEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState && canUndo()) {
      final content = _localHistory.undo();
      if (content != null) {
        _isUndoRedoOperation = true;
        emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: true,
        ));
        // Wait for debounced events to be processed before resetting flag
        await Future.delayed(_updateDebounceTime * 2);
        _isUndoRedoOperation = false;
      }
    }
  }

  void _onRedo(
      RedoPagebuilderEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState && canRedo()) {
      final content = _localHistory.redo();
      if (content != null) {
        _isUndoRedoOperation = true;
        emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: true,
        ));
        // Wait for debounced events to be processed before resetting flag
        await Future.delayed(_updateDebounceTime * 2);
        _isUndoRedoOperation = false;
      }
    }
  }

  void _onReorderSections(
      ReorderSectionsEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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

  void _onReorderWidget(
      ReorderWidgetEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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

  Future<void> _onGetLandingPage(
      GetLandingPageEvent event, Emitter<PagebuilderState> emit) async {
    if (event.id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
      return;
    }

    emit(GetLandingPageLoadingState());

    final failureOrSuccess = await landingPageRepo.getLandingPage(event.id);
    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageFailureState(failure: failure)),
      (landingPage) async {
        final failureOrSuccess = await userRepo.getUser();
        failureOrSuccess.fold(
          (failure) => emit(GetLandingPageFailureState(failure: failure)),
          (user) => add(GetLandingPageContentEvent(
            landingPage.contentID?.value ?? "",
            PagebuilderContent(
              landingPage: landingPage,
              content: null,
              user: user,
            ),
          )),
        );
      },
    );
  }

  Future<void> _onGetLandingPageContent(
      GetLandingPageContentEvent event, Emitter<PagebuilderState> emit) async {
    if (event.id.isEmpty) {
      emit(GetLandingPageFailureState(failure: NotFoundFailure()));
      return;
    }

    final failureOrSuccess =
        await pageBuilderRepo.getLandingPageContent(event.id);

    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageFailureState(failure: failure)),
      (content) {
        final pageBuilderContent = event.pageContent.copyWith(content: content);

        _localHistory.saveToHistory(pageBuilderContent);

        emit(GetLandingPageAndUserSuccessState(
          content: pageBuilderContent,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: null,
        ));
      },
    );
  }

  void _onUpdateSection(
      UpdateSectionEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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

  void _onUpdateWidget(
      UpdateWidgetEvent event, Emitter<PagebuilderState> emit) {
    print('🔵 _onUpdateWidget called');
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

      print('🔵 _onUpdateWidget: _isUndoRedoOperation=$_isUndoRedoOperation');
      if (!_isUndoRedoOperation) {
        print('🔵 _onUpdateWidget: calling saveToHistory');
        _localHistory.saveToHistory(updatedPageBuilderContent);
      } else {
        print(
            '🔵 _onUpdateWidget: SKIPPED saveToHistory because _isUndoRedoOperation=true');
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

  Future<void> _onSaveLandingPageContent(
      SaveLandingPageContentEvent event, Emitter<PagebuilderState> emit) async {
    if (event.content?.content == null) {
      emit(PageBuilderUnexpectedFailureState());
      return;
    }

    emit(GetLandingPageAndUserSuccessState(
      content: event.content!,
      saveLoading: true,
      saveFailure: null,
      saveSuccessful: null,
      isUpdated: null,
    ));

    final contentWithoutPlaceholders =
        PagebuilderWidgetTreeManipulator.removePlaceholders(
            event.content!.content!);

    final failureOrSuccess = await pageBuilderRepo
        .saveLandingPageContent(contentWithoutPlaceholders);

    failureOrSuccess.fold(
      (failure) => emit(GetLandingPageAndUserSuccessState(
        content: event.content!,
        saveLoading: false,
        saveFailure: failure,
        saveSuccessful: null,
        isUpdated: null,
      )),
      (_) => emit(GetLandingPageAndUserSuccessState(
        content: event.content!,
        saveLoading: false,
        saveFailure: null,
        saveSuccessful: true,
        isUpdated: false,
      )),
    );
  }

  void _onAddWidgetAtPosition(
      AddWidgetAtPositionEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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

  void _onAddSection(AddSectionEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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

  void _onReplacePlaceholder(
      ReplacePlaceholderEvent event, Emitter<PagebuilderState> emit) {
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

      if (!_isUndoRedoOperation) {
        _localHistory.saveToHistory(updatedPageBuilderContent);
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
