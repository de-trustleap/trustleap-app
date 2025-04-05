// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Legals extends Equatable {
  final String? avv;
  final String? privacyPolicy;
  final String? termsAndCondition;

  const Legals({
    this.avv,
    this.privacyPolicy,
    this.termsAndCondition,
  });

  Legals copyWith({
    String? avv,
    String? privacyPolicy,
    String? termsAndCondition,
  }) {
    return Legals(
      avv: avv ?? this.avv,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      termsAndCondition: termsAndCondition ?? this.termsAndCondition,
    );
  }

  @override
  List<Object?> get props => [avv, privacyPolicy, termsAndCondition];
}
