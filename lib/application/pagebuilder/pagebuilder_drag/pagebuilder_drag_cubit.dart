import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class PagebuilderDragCubit extends Cubit<bool> {
  PagebuilderDragCubit() : super(false);

  String? activeContainerId;
  GlobalKey? activeContainerKey;

  void setDragging(bool isDragging, {String? containerId, GlobalKey? containerKey}) {
    if (isDragging) {
      activeContainerId = containerId;
      activeContainerKey = containerKey;
    } else {
      activeContainerId = null;
      activeContainerKey = null;
    }

    if (state != isDragging) {
      emit(isDragging);
    }
  }
}
