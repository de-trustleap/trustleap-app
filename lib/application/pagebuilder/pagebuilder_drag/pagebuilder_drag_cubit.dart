import 'package:bloc/bloc.dart';

class PagebuilderDragCubit extends Cubit<bool> {
  PagebuilderDragCubit() : super(false);

  void setDragging(bool isDragging) {
    if (state != isDragging) {
      emit(isDragging);
    }
  }
}
