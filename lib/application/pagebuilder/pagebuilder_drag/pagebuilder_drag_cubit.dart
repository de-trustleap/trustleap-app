import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class PagebuilderDragCubit extends Cubit<bool> {
  PagebuilderDragCubit() : super(false);

  String? activeContainerId;
  GlobalKey? activeContainerKey;

  String? libraryDragTargetContainerId;
  GlobalKey? libraryDragTargetContainerKey;

  void setDragging(bool isDragging,
      {String? containerId, GlobalKey? containerKey}) {
    if (isDragging) {
      activeContainerId = containerId;
      activeContainerKey = containerKey;
    } else {
      activeContainerId = null;
      activeContainerKey = null;
      libraryDragTargetContainerId = null;
      libraryDragTargetContainerKey = null;
    }

    if (state != isDragging) {
      emit(isDragging);
    }
  }

  void setLibraryDragTarget({String? containerId, GlobalKey? containerKey}) {
    libraryDragTargetContainerId = containerId;
    libraryDragTargetContainerKey = containerKey;
    emit(state);
  }

  void clearLibraryDragTarget() {
    libraryDragTargetContainerId = null;
    libraryDragTargetContainerKey = null;
    emit(state);
  }
}
