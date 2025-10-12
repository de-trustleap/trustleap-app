import 'package:flutter_bloc/flutter_bloc.dart';

enum PagebuilderZoomLevel {
  twentyFive(0.25, "25%"),
  fifty(0.5, "50%"),
  seventyFive(0.75, "75%"),
  hundred(1.0, "100%");

  final double scale;
  final String label;

  const PagebuilderZoomLevel(this.scale, this.label);
}

class PagebuilderZoomCubit extends Cubit<PagebuilderZoomLevel> {
  PagebuilderZoomCubit() : super(PagebuilderZoomLevel.hundred);

  void setZoomLevel(PagebuilderZoomLevel level) {
    emit(level);
  }
}
