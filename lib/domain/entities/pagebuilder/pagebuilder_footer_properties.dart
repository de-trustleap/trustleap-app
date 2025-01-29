import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderFooterProperties extends Equatable
    implements PageBuilderProperties {
  final PageBuilderTextProperties? privacyPolicyTextProperties;
  final PageBuilderTextProperties? impressumTextProperties;

  const PagebuilderFooterProperties(
      {required this.privacyPolicyTextProperties,
      required this.impressumTextProperties});

  PagebuilderFooterProperties copyWith(
      {PageBuilderTextProperties? privacyPolicyTextProperties,
      PageBuilderTextProperties? impressumTextProperties}) {
    return PagebuilderFooterProperties(
        privacyPolicyTextProperties:
            privacyPolicyTextProperties ?? this.privacyPolicyTextProperties,
        impressumTextProperties:
            impressumTextProperties ?? this.impressumTextProperties);
  }

  @override
  List<Object?> get props =>
      [privacyPolicyTextProperties, impressumTextProperties];
}
