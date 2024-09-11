// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;

  const PageBuilderImagePropertiesModel(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    return map;
  }

  factory PageBuilderImagePropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderImagePropertiesModel(
        url: map['url'] != null ? map['url'] as String : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null);
  }

  PageBuilderImagePropertiesModel copyWith(
      {String? url, double? borderRadius, double? width, double? height}) {
    return PageBuilderImagePropertiesModel(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height);
  }

  factory PageBuilderImagePropertiesModel.fromFirestore(
      Map<String, dynamic> doc) {
    return PageBuilderImagePropertiesModel.fromMap(doc);
  }

  PageBuilderImageProperties toDomain() {
    return PageBuilderImageProperties(
        url: url, borderRadius: borderRadius, width: width, height: height);
  }

  factory PageBuilderImagePropertiesModel.fromDomain(
      PageBuilderImageProperties properties) {
    return PageBuilderImagePropertiesModel(
        url: properties.url,
        borderRadius: properties.borderRadius,
        width: properties.width,
        height: properties.height);
  }

  @override
  List<Object?> get props => [url, borderRadius, width, height];
}
