// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class UnregisteredPromoter extends Equatable {
  final UniqueID id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final List<String>? landingPageIDs;
  final UniqueID? defaultLandingPageID;
  final UniqueID? parentUserID;
  final UniqueID? companyID;
  final UniqueID? code;
  final DateTime expiresAt;

  UnregisteredPromoter(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.email,
      this.landingPageIDs,
      this.defaultLandingPageID,
      this.parentUserID,
      this.companyID,
      this.code,
      DateTime? expiresAt})
      : expiresAt = expiresAt ??
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 30,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second);

  @override
  List<Object?> get props => [
        id,
        gender,
        firstName,
        lastName,
        birthDate,
        email,
        parentUserID,
        defaultLandingPageID,
        companyID,
        code,
        landingPageIDs
      ];

  UnregisteredPromoter copyWith({
    UniqueID? id,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? email,
    List<String>? landingPageIDs,
    UniqueID? defaultLandingPageID,
    UniqueID? parentUserID,
    UniqueID? companyID,
    UniqueID? code,
  }) {
    return UnregisteredPromoter(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        email: email ?? this.email,
        landingPageIDs: landingPageIDs ?? this.landingPageIDs,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        parentUserID: parentUserID ?? this.parentUserID,
        companyID: companyID ?? this.companyID,
        code: code ?? this.code,
        expiresAt: expiresAt);
  }
}
