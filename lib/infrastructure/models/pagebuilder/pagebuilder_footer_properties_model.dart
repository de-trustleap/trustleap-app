import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PagebuilderFooterPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final Map<String, dynamic>? privacyPolicyTextProperties;
  final Map<String, dynamic>? impressumTextProperties;

  const PagebuilderFooterPropertiesModel(
      {required this.privacyPolicyTextProperties,
      required this.impressumTextProperties});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (privacyPolicyTextProperties != null) {
      map['privacyPolicyTextProperties'] = privacyPolicyTextProperties;
    }
    if (impressumTextProperties != null) {
      map['impressumTextProperties'] = impressumTextProperties;
    }
    return map;
  }

  factory PagebuilderFooterPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderFooterPropertiesModel(
      privacyPolicyTextProperties: map['privacyPolicyTextProperties'] != null
          ? map['privacyPolicyTextProperties'] as Map<String, dynamic>
          : null,
      impressumTextProperties: map['impressumTextProperties'] != null
          ? map['impressumTextProperties'] as Map<String, dynamic>
          : null,
    );
  }

  PagebuilderFooterPropertiesModel copyWith({
    Map<String, dynamic>? privacyPolicyTextProperties,
    Map<String, dynamic>? impressumTextProperties,
  }) {
    return PagebuilderFooterPropertiesModel(
      privacyPolicyTextProperties:
          privacyPolicyTextProperties ?? this.privacyPolicyTextProperties,
      impressumTextProperties:
          impressumTextProperties ?? this.impressumTextProperties,
    );
  }

  PagebuilderFooterProperties toDomain() {
    return PagebuilderFooterProperties(
        privacyPolicyTextProperties: privacyPolicyTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(
                    privacyPolicyTextProperties!)
                .toDomain()
            : null,
        impressumTextProperties: impressumTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(impressumTextProperties!)
                .toDomain()
            : null);
  }

  factory PagebuilderFooterPropertiesModel.fromDomain(
      PagebuilderFooterProperties properties) {
    return PagebuilderFooterPropertiesModel(
        privacyPolicyTextProperties:
            properties.privacyPolicyTextProperties != null
                ? PageBuilderTextPropertiesModel.fromDomain(
                        properties.privacyPolicyTextProperties!)
                    .toMap()
                : null,
        impressumTextProperties: properties.impressumTextProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.impressumTextProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props =>
      [privacyPolicyTextProperties, impressumTextProperties];
}
// TODO: Da wo zB ContactForm überall benutzt wird jetzt auch Footer nutzen