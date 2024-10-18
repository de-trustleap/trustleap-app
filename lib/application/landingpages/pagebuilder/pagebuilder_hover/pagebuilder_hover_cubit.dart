import 'package:bloc/bloc.dart';

class PagebuilderHoverCubit extends Cubit<String?> {
  PagebuilderHoverCubit() : super(null);

  void setHovered(String? widgetId) {
    emit(widgetId);
  }
}
