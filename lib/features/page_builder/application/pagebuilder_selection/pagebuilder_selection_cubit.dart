import 'package:bloc/bloc.dart';

class PagebuilderSelectionCubit extends Cubit<String?> {
  PagebuilderSelectionCubit() : super(null);

  void selectWidget(String? widgetId) {
    emit(widgetId);
  }
}
