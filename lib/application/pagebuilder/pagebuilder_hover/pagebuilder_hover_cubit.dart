import 'package:bloc/bloc.dart';

class PagebuilderHoverCubit extends Cubit<String?> {
  PagebuilderHoverCubit() : super(null);

  bool _isDisabled = false;

  void setHovered(String? widgetId) {
    if (_isDisabled) return;
    emit(widgetId);
  }

  void setDisabled(bool disabled) {
    _isDisabled = disabled;
    if (disabled) {
      emit(null); // Clear hover when disabling
    }
  }
}
