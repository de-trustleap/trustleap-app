import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderAnchorButtonProperties extends Equatable
    implements PageBuilderProperties {
  final String? sectionID;
  final PageBuilderButtonProperties? buttonProperties;

  const PagebuilderAnchorButtonProperties({
    required this.sectionID,
    required this.buttonProperties,
  });

  PagebuilderAnchorButtonProperties copyWith({
    String? sectionID,
    PageBuilderButtonProperties? buttonProperties,
  }) {
    return PagebuilderAnchorButtonProperties(
      sectionID: sectionID ?? this.sectionID,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PagebuilderAnchorButtonProperties deepCopy() {
    return PagebuilderAnchorButtonProperties(
      sectionID: sectionID,
      buttonProperties: buttonProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [sectionID, buttonProperties];
}
