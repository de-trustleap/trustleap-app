// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';

class LegalsModel extends Equatable {
  final String? avv;
  final String? privacyPolicy;
  final String? termsAndCondition;
  final String? imprint;

  const LegalsModel(
      {this.avv, this.privacyPolicy, this.termsAndCondition, this.imprint});

  LegalsModel copyWith(
      {String? avv,
      String? privacyPolicy,
      String? termsAndCondition,
      String? imprint}) {
    return LegalsModel(
        avv: avv ?? this.avv,
        privacyPolicy: privacyPolicy ?? this.privacyPolicy,
        termsAndCondition: termsAndCondition ?? this.termsAndCondition,
        imprint: imprint ?? this.imprint);
  }

  factory LegalsModel.fromMap(Map<String, dynamic> map) {
    return LegalsModel(
        avv: _getLatestVersionContent(map['avvVersions']),
        privacyPolicy: _getLatestVersionContent(map['privacyPolicyVersions']),
        termsAndCondition:
            _getLatestVersionContent(map['termsAndConditionsVersions']),
        imprint: _getLatestVersionContent(map['imprintVersions']));
  }

  static String? _getLatestVersionContent(dynamic versions) {
    if (versions == null || versions is! List || versions.isEmpty) {
      return null;
    }

    if (versions.isEmpty) return null;

    Map<String, dynamic>? latestVersion;
    int highestVersion = 0;

    for (final version in versions) {
      if (version is Map<String, dynamic>) {
        final versionNumber = version['version'] as int? ?? 0;
        if (versionNumber > highestVersion) {
          highestVersion = versionNumber;
          latestVersion = version;
        }
      }
    }

    return latestVersion?['content'] as String?;
  }

  Legals toDomain() {
    return Legals(
        avv: avv,
        privacyPolicy: privacyPolicy,
        termsAndCondition: termsAndCondition,
        imprint: imprint);
  }

  factory LegalsModel.fromDomain(Legals legals) {
    return LegalsModel(
        avv: legals.avv,
        privacyPolicy: legals.privacyPolicy,
        termsAndCondition: legals.termsAndCondition,
        imprint: legals.imprint);
  }

  @override
  List<Object?> get props => [avv, privacyPolicy, termsAndCondition, imprint];
}
