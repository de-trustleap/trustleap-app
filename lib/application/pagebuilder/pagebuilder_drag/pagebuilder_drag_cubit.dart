import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'pagebuilder_drag_state.dart';

class PagebuilderDragCubit extends Cubit<PagebuilderDragCubitState> {
  PagebuilderDragCubit()
      : super(const PagebuilderDragCubitState(isDragging: false));

  void setDragging(bool isDragging,
      {String? containerId, GlobalKey? containerKey}) {
    if (isDragging) {
      emit(state.copyWith(
        isDragging: true,
        activeContainerId: containerId,
        activeContainerKey: containerKey,
      ));
    } else {
      emit(state.copyWith(
        isDragging: false,
        clearActiveContainer: true,
        clearLibraryDragTarget: true,
      ));
    }
  }

  void setLibraryDragTarget({String? containerId, GlobalKey? containerKey}) {
    emit(state.copyWith(
      libraryDragTargetContainerId: containerId,
      libraryDragTargetContainerKey: containerKey,
    ));
  }

  void clearLibraryDragTarget() {
    emit(state.copyWith(clearLibraryDragTarget: true));
  }
}
