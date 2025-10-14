import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_local_history.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_reorder_helper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'pagebuilder_event.dart';
part 'pagebuilder_state.dart';

class PagebuilderBloc extends Bloc<PagebuilderEvent, PagebuilderState> {
  final LandingPageRepository landingPageRepo;
  final PagebuilderRepository pageBuilderRepo;
  final UserRepository userRepo;

  final PagebuilderLocalHistory _localHistory = PagebuilderLocalHistory();
  bool _isUndoRedoOperation = false;

  PagebuilderBloc({
    required this.landingPageRepo,
    required this.pageBuilderRepo,
    required this.userRepo,
  }) : super(PagebuilderInitial()) {
    on<GetLandingPageEvent>(_onGetLandingPage);
    on<GetLandingPageContentEvent>(_onGetLandingPageContent);
    on<UpdateWidgetEvent>(_onUpdateWidget,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap(mapper));
    on<UpdateSectionEvent>(_onUpdateSection,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap(mapper));
    on<ReorderSectionsEvent>(_onReorderSections);
    on<ReorderWidgetEvent>(_onReorderWidget);
    on<SaveLandingPageContentEvent>(_onSaveLandingPageContent);
    on<UndoPagebuilderEvent>(_onUndo);
    on<RedoPagebuilderEvent>(_onRedo);
    on<AddWidgetAtPositionEvent>(_onAddWidgetAtPosition);
  }

  bool canUndo() => _localHistory.canUndo();
  bool canRedo() => _localHistory.canRedo();

  void _onUndo(UndoPagebuilderEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
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
        _isUndoRedoOperation = false;
      }
    }
  }

  void _onRedo(RedoPagebuilderEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
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
          return _reorderChildrenInWidget(
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

  PageBuilderWidget _reorderChildrenInWidget(PageBuilderWidget widget,
      String parentWidgetId, int oldIndex, int newIndex) {
    if (widget.id.value == parentWidgetId) {
      if (widget.children != null && widget.children!.isNotEmpty) {
        final reorderedChildren = PagebuilderReorderHelper.reorderWidgets(
            widget.children!, oldIndex, newIndex);
        return widget.copyWith(children: reorderedChildren);
      }
      return widget;
    }

    if (widget.containerChild != null) {
      final updatedContainerChild = _reorderChildrenInWidget(
          widget.containerChild!, parentWidgetId, oldIndex, newIndex);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    if (widget.children != null && widget.children!.isNotEmpty) {
      final updatedChildren = widget.children!
          .map((child) => _reorderChildrenInWidget(
              child, parentWidgetId, oldIndex, newIndex))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
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
      final updatedSections =
          currentState.content.content?.sections?.map((section) {
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
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;

      final updatedSections = currentState.content.content?.sections?.map(
        (section) {
          final updatedWidgets = section.widgets
              ?.map(
                (widget) => _updateChildWidgets(widget, event.updatedWidget),
              )
              .toList();
          return section.copyWith(widgets: updatedWidgets);
        },
      ).toList();

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

    final failureOrSuccess =
        await pageBuilderRepo.saveLandingPageContent(event.content!.content!);

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

  PageBuilderWidget _updateChildWidgets(
      PageBuilderWidget currentWidget, PageBuilderWidget updatedWidget) {
    if (currentWidget.id == updatedWidget.id) {
      return updatedWidget;
    }

    if (currentWidget.containerChild != null) {
      final updatedContainerChild =
          _updateChildWidgets(currentWidget.containerChild!, updatedWidget);
      return currentWidget.copyWith(containerChild: updatedContainerChild);
    }

    if (currentWidget.children != null && currentWidget.children!.isNotEmpty) {
      final updatedChildren = currentWidget.children!
          .map(
            (child) => _updateChildWidgets(child, updatedWidget),
          )
          .toList();

      return currentWidget.copyWith(children: updatedChildren);
    }

    return currentWidget;
  }

  void _onAddWidgetAtPosition(
      AddWidgetAtPositionEvent event, Emitter<PagebuilderState> emit) {
    if (state is GetLandingPageAndUserSuccessState) {
      final currentState = state as GetLandingPageAndUserSuccessState;
      final sections = currentState.content.content?.sections;

      if (sections == null || sections.isEmpty) return;

      final updatedSections = sections.map((section) {
        final updatedWidgets = section.widgets?.map((widget) {
          return _addWidgetAtPosition(
              widget, event.targetWidgetId, event.newWidget, event.position);
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

  PageBuilderWidget _addWidgetAtPosition(
      PageBuilderWidget widget,
      String targetWidgetId,
      PageBuilderWidget newWidget,
      DropPosition position) {
    // Handle "inside" position - add to children if container/row/column
    if (widget.id.value == targetWidgetId && position == DropPosition.inside) {
      if (_canHaveChildren(widget.elementType)) {
        final currentChildren = widget.children ?? [];

        // If adding to a Row, redistribute widthPercentage
        if (widget.elementType == PageBuilderWidgetType.row) {
          final totalChildren = currentChildren.length + 1;
          final equalWidth = 100.0 / totalChildren;
          final equalWidthPercentage =
              PagebuilderResponsiveOrConstant.constant(equalWidth);

          // Update all existing children with new width
          final redistributedChildren = currentChildren
              .map((child) =>
                  child.copyWith(widthPercentage: equalWidthPercentage))
              .toList();

          // Add new widget with same width
          final widgetToAdd =
              newWidget.copyWith(widthPercentage: equalWidthPercentage);
          redistributedChildren.add(widgetToAdd);

          return widget.copyWith(children: redistributedChildren);
        } else {
          // For Column/Container, just add without width changes
          final updatedChildren = List<PageBuilderWidget>.from(currentChildren)
            ..add(newWidget);
          return widget.copyWith(children: updatedChildren);
        }
      }
      return widget;
    }

    // Search in containerChild
    if (widget.containerChild != null) {
      // Check if containerChild is the target
      if (widget.containerChild!.id.value == targetWidgetId &&
          position != DropPosition.inside) {
        // Target found in containerChild - wrap both widgets
        return _wrapContainerChild(widget, newWidget, position);
      }

      // Continue recursive search
      final updatedContainerChild = _addWidgetAtPosition(
          widget.containerChild!, targetWidgetId, newWidget, position);
      return widget.copyWith(containerChild: updatedContainerChild);
    }

    // Search in children
    if (widget.children != null && widget.children!.isNotEmpty) {
      final childIndex = widget.children!
          .indexWhere((child) => child.id.value == targetWidgetId);

      if (childIndex != -1) {
        // Found target widget - check if parent can handle multiple children
        final parentType = widget.elementType;

        // Check if we need to wrap widgets (horizontal placement in Column, or vice versa)
        final isHorizontalPlacement = position == DropPosition.before || position == DropPosition.after;
        final isVerticalPlacement = position == DropPosition.above || position == DropPosition.below;
        final parentIsColumn = parentType == PageBuilderWidgetType.column;
        final parentIsRow = parentType == PageBuilderWidgetType.row;

        // Need to wrap if: horizontal placement in Column OR vertical placement in Row
        final needsWrapping = (isHorizontalPlacement && parentIsColumn) ||
                              (isVerticalPlacement && parentIsRow) ||
                              !_canHaveChildren(parentType);

        if (needsWrapping) {
          // Wrap the widgets in appropriate container (Row or Column)
          return _wrapWidgetsInContainer(
              widget, childIndex, newWidget, position);
        } else if (_canHaveChildren(parentType)) {
          // Parent can handle this placement direction - just insert
          final updatedChildren =
              List<PageBuilderWidget>.from(widget.children!);
          int insertIndex;

          // Determine insert index based on position
          if (position == DropPosition.before ||
              position == DropPosition.above) {
            insertIndex = childIndex;
          } else {
            insertIndex = childIndex + 1;
          }

          // If inserting into a Row, redistribute widthPercentage for all children
          if (parentType == PageBuilderWidgetType.row) {
            // Calculate equal width for all children (including new one)
            final totalChildren = updatedChildren.length + 1;
            final equalWidth = 100.0 / totalChildren;
            final equalWidthPercentage =
                PagebuilderResponsiveOrConstant.constant(equalWidth);

            // Update all existing children with new width
            final redistributedChildren = updatedChildren
                .map((child) =>
                    child.copyWith(widthPercentage: equalWidthPercentage))
                .toList();

            // Insert new widget with same width
            final widgetToInsert =
                newWidget.copyWith(widthPercentage: equalWidthPercentage);
            redistributedChildren.insert(insertIndex, widgetToInsert);

            return widget.copyWith(children: redistributedChildren);
          } else {
            // For Column/Container, just insert without width changes
            updatedChildren.insert(insertIndex, newWidget);
            return widget.copyWith(children: updatedChildren);
          }
        } else {
          // Fallback - should not reach here
          return widget;
        }
      }

      // Recursively search in children
      final updatedChildren = widget.children!
          .map((child) =>
              _addWidgetAtPosition(child, targetWidgetId, newWidget, position))
          .toList();
      return widget.copyWith(children: updatedChildren);
    }

    return widget;
  }

  bool _canHaveChildren(PageBuilderWidgetType? type) {
    return type == PageBuilderWidgetType.row ||
        type == PageBuilderWidgetType.column ||
        type == PageBuilderWidgetType.container;
  }

  PageBuilderWidget _wrapWidgetsInContainer(PageBuilderWidget parentWidget,
      int targetIndex, PageBuilderWidget newWidget, DropPosition position) {
    final targetWidget = parentWidget.children![targetIndex];

    // Determine if we need Row (horizontal) or Column (vertical)
    final isVertical =
        position == DropPosition.above || position == DropPosition.below;

    // Determine child order
    List<PageBuilderWidget> children;

    if (isVertical) {
      // For Column, no widthPercentage needed for children
      children = (position == DropPosition.above)
          ? [newWidget, targetWidget]
          : [targetWidget, newWidget];
    } else {
      // For Row, set equal widthPercentage (50/50) for both children
      const equalWidthPercentage = PagebuilderResponsiveOrConstant.constant(50.0);
      final newWidgetWithWidth = newWidget.copyWith(widthPercentage: equalWidthPercentage);
      final targetWidgetWithWidth = targetWidget.copyWith(widthPercentage: equalWidthPercentage);

      children = (position == DropPosition.before)
          ? [newWidgetWithWidth, targetWidgetWithWidth]
          : [targetWidgetWithWidth, newWidgetWithWidth];
    }

    // Create wrapper widget (Row or Column)
    // IMPORTANT: For Column wrapper in Row, inherit widthPercentage from target widget
    final wrapperWidget = isVertical
        ? PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.column,
            properties: const PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            hoverProperties: null,
            children: children,
            containerChild: null,
            widthPercentage: targetWidget.widthPercentage,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          )
        : PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.row,
            properties: const PagebuilderRowProperties(
              equalHeights: false,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              switchToColumnFor: null,
            ),
            hoverProperties: null,
            children: children,
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          );

    // Replace target widget with wrapper
    final updatedChildren =
        List<PageBuilderWidget>.from(parentWidget.children!);
    updatedChildren[targetIndex] = wrapperWidget;
    return parentWidget.copyWith(children: updatedChildren);
  }

  PageBuilderWidget _wrapContainerChild(PageBuilderWidget containerWidget,
      PageBuilderWidget newWidget, DropPosition position) {
    final targetWidget = containerWidget.containerChild!;

    // Determine if we need Row (horizontal) or Column (vertical)
    final isVertical =
        position == DropPosition.above || position == DropPosition.below;

    // Determine child order
    final children =
        (position == DropPosition.before || position == DropPosition.above)
            ? [newWidget, targetWidget]
            : [targetWidget, newWidget];

    // Create wrapper widget (Row or Column) to replace containerChild
    final wrapperWidget = isVertical
        ? PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.column,
            properties: const PagebuilderColumnProperties(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            hoverProperties: null,
            children: children,
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          )
        : PageBuilderWidget(
            id: UniqueID(),
            elementType: PageBuilderWidgetType.row,
            properties: const PagebuilderRowProperties(
              equalHeights: false,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              switchToColumnFor: null,
            ),
            hoverProperties: null,
            children: children,
            containerChild: null,
            widthPercentage: null,
            background: null,
            hoverBackground: null,
            padding: null,
            margin: null,
            maxWidth: null,
            alignment: null,
            customCSS: null,
          );

    // Replace containerChild with wrapper
    return containerWidget.copyWith(containerChild: wrapperWidget);
  }
}
