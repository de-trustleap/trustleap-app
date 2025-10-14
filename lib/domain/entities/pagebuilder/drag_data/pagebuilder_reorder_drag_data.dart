import 'package:finanzbegleiter/domain/entities/pagebuilder/drag_data/pagebuilder_drag_data.dart';

class PagebuilderReorderDragData<T> extends PagebuilderDragData {
  final String containerId;
  final int index;

  const PagebuilderReorderDragData(this.containerId, this.index);

  @override
  List<Object?> get props => [containerId, index];
}
