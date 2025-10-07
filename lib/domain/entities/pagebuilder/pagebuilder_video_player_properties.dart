import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PagebuilderVideoPlayerProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final String? link;

  const PagebuilderVideoPlayerProperties(
      {required this.link, required this.width, required this.height});

  PagebuilderVideoPlayerProperties copyWith(
      {PagebuilderResponsiveOrConstant<double>? width,
      PagebuilderResponsiveOrConstant<double>? height,
      String? link}) {
    return PagebuilderVideoPlayerProperties(
        width: width ?? this.width,
        height: height ?? this.height,
        link: link ?? this.link);
  }

  @override
  List<Object?> get props => [width, height, link];
}
