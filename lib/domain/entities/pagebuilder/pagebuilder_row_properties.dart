import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderRowProperties extends Equatable
    implements PageBuilderProperties {
  final bool? equalWidths;

  const PagebuilderRowProperties({required this.equalWidths});

  PagebuilderRowProperties copyWith({bool? equalWidths}) {
    return PagebuilderRowProperties(
        equalWidths: equalWidths ?? this.equalWidths);
  }

  @override
  List<Object?> get props => [equalWidths];
}
