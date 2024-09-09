// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;

  const PageBuilderImagePropertiesModel({
    required this.url,
    required this.borderRadius,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    return map;
  }

  factory PageBuilderImagePropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderImagePropertiesModel(
        url: map['url'] != null ? map['url'] as String : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null);
  }

  PageBuilderImagePropertiesModel copyWith({
    String? url,
    double? borderRadius,
  }) {
    return PageBuilderImagePropertiesModel(
      url: url ?? this.url,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  factory PageBuilderImagePropertiesModel.fromFirestore(
      Map<String, dynamic> doc) {
    return PageBuilderImagePropertiesModel.fromMap(doc);
  }

  PageBuilderImageProperties toDomain() {
    return PageBuilderImageProperties(url: url, borderRadius: borderRadius);
  }

  factory PageBuilderImagePropertiesModel.fromDomain(
      PageBuilderImageProperties properties) {
    return PageBuilderImagePropertiesModel(
        url: properties.url, borderRadius: properties.borderRadius);
  }

  @override
  List<Object?> get props => [url, borderRadius];
}
