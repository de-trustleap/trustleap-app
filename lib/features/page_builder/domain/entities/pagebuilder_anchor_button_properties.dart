import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

class PagebuilderAnchorButtonProperties extends Equatable
    implements PageBuilderProperties {
  final String? sectionName;
  final PageBuilderButtonProperties? buttonProperties;

  const PagebuilderAnchorButtonProperties({
    required this.sectionName,
    required this.buttonProperties,
  });

  PagebuilderAnchorButtonProperties copyWith({
    String? sectionName,
    PageBuilderButtonProperties? buttonProperties,
  }) {
    return PagebuilderAnchorButtonProperties(
      sectionName: sectionName ?? this.sectionName,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PagebuilderAnchorButtonProperties deepCopy() {
    return PagebuilderAnchorButtonProperties(
      sectionName: sectionName,
      buttonProperties: buttonProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [sectionName, buttonProperties];
}
