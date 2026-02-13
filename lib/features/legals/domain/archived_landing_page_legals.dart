import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/legals/domain/legal_version.dart';

class ArchivedLandingPageLegals extends Equatable {
  final String id;
  final List<LegalVersion> privacyPolicyVersions;
  final List<LegalVersion> initialInformationVersions;
  final List<LegalVersion> termsAndConditionsVersions;

  const ArchivedLandingPageLegals({
    required this.id,
    this.privacyPolicyVersions = const [],
    this.initialInformationVersions = const [],
    this.termsAndConditionsVersions = const [],
  });

  DateTime? get privacyPolicyLastUpdated {
    if (privacyPolicyVersions.isEmpty) return null;
    return privacyPolicyVersions
        .reduce((a, b) => a.version > b.version ? a : b)
        .archivedAt;
  }

  DateTime? get initialInformationLastUpdated {
    if (initialInformationVersions.isEmpty) return null;
    return initialInformationVersions
        .reduce((a, b) => a.version > b.version ? a : b)
        .archivedAt;
  }

  DateTime? get termsAndConditionsLastUpdated {
    if (termsAndConditionsVersions.isEmpty) return null;
    return termsAndConditionsVersions
        .reduce((a, b) => a.version > b.version ? a : b)
        .archivedAt;
  }

  @override
  List<Object?> get props => [
        id,
        privacyPolicyVersions,
        initialInformationVersions,
        termsAndConditionsVersions,
      ];
}
