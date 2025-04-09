// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/legals.dart';

class LegalsModel extends Equatable {
  final String? avv;
  final String? privacyPolicy;
  final String? termsAndCondition;

  const LegalsModel({
    this.avv,
    this.privacyPolicy,
    this.termsAndCondition,
  });

  LegalsModel copyWith({
    String? avv,
    String? privacyPolicy,
    String? termsAndCondition,
  }) {
    return LegalsModel(
      avv: avv ?? this.avv,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      termsAndCondition: termsAndCondition ?? this.termsAndCondition,
    );
  }

  factory LegalsModel.fromMap(Map<String, dynamic> map) {
    return LegalsModel(
      avv: map['avv'] != null ? map['avv'] as String : null,
      privacyPolicy:
          map['privacyPolicy'] != null ? map['privacyPolicy'] as String : null,
      termsAndCondition: map['termsAndCondition'] != null
          ? map['termsAndCondition'] as String
          : null,
    );
  }

  Legals toDomain() {
    return Legals(
      avv: avv,
      privacyPolicy: privacyPolicy,
      termsAndCondition: termsAndCondition,
    );
  }

  @override
  List<Object?> get props => [];
}
