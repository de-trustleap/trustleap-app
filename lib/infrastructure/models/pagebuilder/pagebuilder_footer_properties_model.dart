import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PagebuilderFooterPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final Map<String, dynamic>? privacyPolicyTextProperties;
  final Map<String, dynamic>? impressumTextProperties;
  final Map<String, dynamic>? initialInformationTextProperties;
  final Map<String, dynamic>? termsAndConditionsTextProperties;

  const PagebuilderFooterPropertiesModel(
      {required this.privacyPolicyTextProperties,
      required this.impressumTextProperties,
      required this.initialInformationTextProperties,
      required this.termsAndConditionsTextProperties});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (privacyPolicyTextProperties != null) {
      map['privacyPolicyTextProperties'] = privacyPolicyTextProperties;
    }
    if (impressumTextProperties != null) {
      map['impressumTextProperties'] = impressumTextProperties;
    }
    if (initialInformationTextProperties != null) {
      map['initialInformationTextProperties'] =
          initialInformationTextProperties;
    }
    if (termsAndConditionsTextProperties != null) {
      map['termsAndConditionsTextProperties'] =
          termsAndConditionsTextProperties;
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
        initialInformationTextProperties:
            map['initialInformationTextProperties'] != null
                ? map['initialInformationTextProperties']
                    as Map<String, dynamic>
                : null,
        termsAndConditionsTextProperties:
            map['termsAndConditionsTextProperties'] != null
                ? map['termsAndConditionsTextProperties']
                    as Map<String, dynamic>
                : null);
  }

  PagebuilderFooterPropertiesModel copyWith(
      {Map<String, dynamic>? privacyPolicyTextProperties,
      Map<String, dynamic>? impressumTextProperties,
      Map<String, dynamic>? initialInformationTextProperties,
      Map<String, dynamic>? termsAndConditionsTextProperties}) {
    return PagebuilderFooterPropertiesModel(
        privacyPolicyTextProperties:
            privacyPolicyTextProperties ?? this.privacyPolicyTextProperties,
        impressumTextProperties:
            impressumTextProperties ?? this.impressumTextProperties,
        initialInformationTextProperties: initialInformationTextProperties ??
            this.initialInformationTextProperties,
        termsAndConditionsTextProperties: termsAndConditionsTextProperties ??
            this.termsAndConditionsTextProperties);
  }

  PagebuilderFooterProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PagebuilderFooterProperties(
        privacyPolicyTextProperties: privacyPolicyTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(
                    privacyPolicyTextProperties!)
                .toDomain(globalStyles)
            : null,
        impressumTextProperties: impressumTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(impressumTextProperties!)
                .toDomain(globalStyles)
            : null,
        initialInformationTextProperties: initialInformationTextProperties !=
                null
            ? PageBuilderTextPropertiesModel.fromMap(
                    initialInformationTextProperties!)
                .toDomain(globalStyles)
            : null,
        termsAndConditionsTextProperties: termsAndConditionsTextProperties !=
                null
            ? PageBuilderTextPropertiesModel.fromMap(
                    termsAndConditionsTextProperties!)
                .toDomain(globalStyles)
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
            : null,
        initialInformationTextProperties:
            properties.initialInformationTextProperties != null
                ? PageBuilderTextPropertiesModel.fromDomain(
                        properties.initialInformationTextProperties!)
                    .toMap()
                : null,
        termsAndConditionsTextProperties:
            properties.termsAndConditionsTextProperties != null
                ? PageBuilderTextPropertiesModel.fromDomain(
                        properties.termsAndConditionsTextProperties!)
                    .toMap()
                : null);
  }

  @override
  List<Object?> get props => [
        privacyPolicyTextProperties,
        impressumTextProperties,
        initialInformationTextProperties,
        termsAndConditionsTextProperties
      ];
}
