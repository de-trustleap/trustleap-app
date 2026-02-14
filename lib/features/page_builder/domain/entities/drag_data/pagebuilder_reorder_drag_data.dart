import 'package:finanzbegleiter/features/page_builder/domain/entities/drag_data/pagebuilder_drag_data.dart';

class PagebuilderReorderDragData<T> extends PagebuilderDragData {
  final String containerId;
  final int index;

  const PagebuilderReorderDragData(this.containerId, this.index);

  @override
  List<Object?> get props => [containerId, index];
}
