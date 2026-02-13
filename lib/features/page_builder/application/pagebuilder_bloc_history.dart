part of 'pagebuilder_bloc.dart';

extension PagebuilderBlocHistory on PagebuilderBloc {
  Future<void> onUndo(
      UndoPagebuilderEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState && canUndo()) {
      final content = localHistory.undo();
      if (content != null) {
        isUndoRedoOperation = true;
        emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: true,
        ));
        // Wait for debounced events to be processed before resetting flag
        await Future.delayed(PagebuilderBloc.updateDebounceTime * 2);
        isUndoRedoOperation = false;
      }
    }
  }

  Future<void> onRedo(
      RedoPagebuilderEvent event, Emitter<PagebuilderState> emit) async {
    if (state is GetLandingPageAndUserSuccessState && canRedo()) {
      final content = localHistory.redo();
      if (content != null) {
        isUndoRedoOperation = true;
        emit(GetLandingPageAndUserSuccessState(
          content: content,
          saveLoading: false,
          saveFailure: null,
          saveSuccessful: null,
          isUpdated: true,
        ));
        // Wait for debounced events to be processed before resetting flag
        await Future.delayed(PagebuilderBloc.updateDebounceTime * 2);
        isUndoRedoOperation = false;
      }
    }
  }
}
