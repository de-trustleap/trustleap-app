import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

class PagebuilderVideoPlayerPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final PagebuilderResponsiveOrConstantModel<double>? height;
  final String? link;

  const PagebuilderVideoPlayerPropertiesModel(
      {required this.width, required this.height, required this.link});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width!.toMapValue();
    if (height != null) map['height'] = height!.toMapValue();
    if (link != null) map['link'] = link;
    return map;
  }

  factory PagebuilderVideoPlayerPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PagebuilderVideoPlayerPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['width'], (v) => v as double),
        height: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['height'], (v) => v as double),
        link: map['link'] != null ? map['link'] as String : null);
  }

  PagebuilderVideoPlayerPropertiesModel copyWith(
      {PagebuilderResponsiveOrConstantModel<double>? width,
      PagebuilderResponsiveOrConstantModel<double>? height,
      String? link}) {
    return PagebuilderVideoPlayerPropertiesModel(
        width: width ?? this.width,
        height: height ?? this.height,
        link: link ?? this.link);
  }

  PagebuilderVideoPlayerProperties toDomain() {
    return PagebuilderVideoPlayerProperties(
        width: width?.toDomain(), height: height?.toDomain(), link: link);
  }

  factory PagebuilderVideoPlayerPropertiesModel.fromDomain(
      PagebuilderVideoPlayerProperties properties) {
    return PagebuilderVideoPlayerPropertiesModel(
      width: PagebuilderResponsiveOrConstantModel.fromDomain(properties.width),
      height:
          PagebuilderResponsiveOrConstantModel.fromDomain(properties.height),
      link: properties.link,
    );
  }

  @override
  List<Object?> get props => [width, height, link];
}
