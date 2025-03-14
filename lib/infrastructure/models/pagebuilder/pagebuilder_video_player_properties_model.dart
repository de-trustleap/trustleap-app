import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderVideoPlayerPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final String? link;

  const PagebuilderVideoPlayerPropertiesModel(
      {required this.width, required this.height, required this.link});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (link != null) map['link'] = link;
    return map;
  }

  factory PagebuilderVideoPlayerPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PagebuilderVideoPlayerPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        link: map['link'] != null ? map['link'] as String : null);
  }

  PagebuilderVideoPlayerPropertiesModel copyWith(
      {double? width, double? height, String? link}) {
    return PagebuilderVideoPlayerPropertiesModel(
        width: width ?? this.width,
        height: height ?? this.height,
        link: link ?? this.link);
  }

  PagebuilderVideoPlayerProperties toDomain() {
    return PagebuilderVideoPlayerProperties(
        width: width, height: height, link: link);
  }

  factory PagebuilderVideoPlayerPropertiesModel.fromDomain(
      PagebuilderVideoPlayerProperties properties) {
    return PagebuilderVideoPlayerPropertiesModel(
      width: properties.width,
      height: properties.height,
      link: properties.link,
    );
  }

  @override
  List<Object?> get props => [width, height, link];
}
