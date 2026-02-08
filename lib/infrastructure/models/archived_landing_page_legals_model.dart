import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/domain/entities/legal_version.dart';

class ArchivedLandingPageLegalsModel extends Equatable {
  final String id;
  final List<LegalVersion> privacyPolicyVersions;
  final List<LegalVersion> initialInformationVersions;
  final List<LegalVersion> termsAndConditionsVersions;

  const ArchivedLandingPageLegalsModel({
    required this.id,
    this.privacyPolicyVersions = const [],
    this.initialInformationVersions = const [],
    this.termsAndConditionsVersions = const [],
  });

  factory ArchivedLandingPageLegalsModel.fromMap(Map<String, dynamic> map) {
    return ArchivedLandingPageLegalsModel(
      id: map['id'] as String? ?? '',
      privacyPolicyVersions:
          _parseVersions(map['privacyPolicyVersions'] as List?),
      initialInformationVersions:
          _parseVersions(map['initialInformationVersions'] as List?),
      termsAndConditionsVersions:
          _parseVersions(map['termsAndConditionsVersions'] as List?),
    );
  }

  static List<LegalVersion> _parseVersions(List? versions) {
    if (versions == null || versions.isEmpty) return [];

    return versions
        .whereType<Map<String, dynamic>>()
        .where((v) => v['archivedAt'] is Timestamp)
        .map((v) => LegalVersion(
              content: v['content'] as String? ?? '',
              archivedAt: (v['archivedAt'] as Timestamp).toDate(),
              version: v['version'] as int? ?? 0,
            ))
        .toList();
  }

  ArchivedLandingPageLegals toDomain() {
    return ArchivedLandingPageLegals(
      id: id,
      privacyPolicyVersions: privacyPolicyVersions,
      initialInformationVersions: initialInformationVersions,
      termsAndConditionsVersions: termsAndConditionsVersions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        privacyPolicyVersions,
        initialInformationVersions,
        termsAndConditionsVersions,
      ];
}
