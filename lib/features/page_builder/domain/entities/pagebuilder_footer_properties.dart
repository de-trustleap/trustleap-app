import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';

class PagebuilderFooterProperties extends Equatable
    implements PageBuilderProperties {
  final PageBuilderTextProperties? privacyPolicyTextProperties;
  final PageBuilderTextProperties? impressumTextProperties;
  final PageBuilderTextProperties? initialInformationTextProperties;
  final PageBuilderTextProperties? termsAndConditionsTextProperties;

  const PagebuilderFooterProperties(
      {required this.privacyPolicyTextProperties,
      required this.impressumTextProperties,
      required this.initialInformationTextProperties,
      required this.termsAndConditionsTextProperties});

  PagebuilderFooterProperties copyWith(
      {PageBuilderTextProperties? privacyPolicyTextProperties,
      PageBuilderTextProperties? impressumTextProperties,
      PageBuilderTextProperties? initialInformationTextProperties,
      PageBuilderTextProperties? termsAndConditionsTextProperties}) {
    return PagebuilderFooterProperties(
        privacyPolicyTextProperties:
            privacyPolicyTextProperties ?? this.privacyPolicyTextProperties,
        impressumTextProperties:
            impressumTextProperties ?? this.impressumTextProperties,
        initialInformationTextProperties: initialInformationTextProperties ??
            this.initialInformationTextProperties,
        termsAndConditionsTextProperties: termsAndConditionsTextProperties ??
            this.termsAndConditionsTextProperties);
  }

  @override
  List<Object?> get props => [
        privacyPolicyTextProperties,
        impressumTextProperties,
        initialInformationTextProperties,
        termsAndConditionsTextProperties
      ];
}
