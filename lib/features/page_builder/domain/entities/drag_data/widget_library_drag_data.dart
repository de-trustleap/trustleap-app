import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/drag_data/pagebuilder_drag_data.dart';

class WidgetLibraryDragData extends PagebuilderDragData {
  final PageBuilderWidgetType widgetType;

  const WidgetLibraryDragData(this.widgetType);

  @override
  List<Object?> get props => [widgetType];
}
