// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Legals extends Equatable {
  final String? avv;
  final String? privacyPolicy;
  final String? termsAndCondition;
  final String? imprint;

  const Legals(
      {this.avv, this.privacyPolicy, this.termsAndCondition, this.imprint});

  Legals copyWith(
      {String? avv,
      String? privacyPolicy,
      String? termsAndCondition,
      String? imprint}) {
    return Legals(
        avv: avv ?? this.avv,
        privacyPolicy: privacyPolicy ?? this.privacyPolicy,
        termsAndCondition: termsAndCondition ?? this.termsAndCondition,
        imprint: imprint ?? this.imprint);
  }

  @override
  List<Object?> get props => [avv, privacyPolicy, termsAndCondition, imprint];
}

// TODO: FÜGE FOOTER BEI LOGIN HINZU
