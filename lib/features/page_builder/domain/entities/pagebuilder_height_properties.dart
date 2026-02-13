import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

class PageBuilderHeightProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<int>? height;

  const PageBuilderHeightProperties({
    required this.height,
  });

  PageBuilderHeightProperties copyWith({
    PagebuilderResponsiveOrConstant<int>? height,
  }) {
    return PageBuilderHeightProperties(
      height: height ?? this.height,
    );
  }

  PageBuilderHeightProperties deepCopy() {
    return PageBuilderHeightProperties(
      height: height?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [height];
}
