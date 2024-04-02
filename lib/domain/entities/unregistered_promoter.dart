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
  final UniqueID? parentUserID;
  final UniqueID? code;
  final DateTime expiresAt;

  UnregisteredPromoter(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.email,
      this.parentUserID,
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
  List<Object?> get props =>
      [id, gender, firstName, lastName, birthDate, email, parentUserID, code];

  UnregisteredPromoter copyWith({
    UniqueID? id,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? email,
    UniqueID? parentUserID,
    UniqueID? code,
  }) {
    return UnregisteredPromoter(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        email: email ?? this.email,
        parentUserID: parentUserID ?? this.parentUserID,
        code: code ?? this.code,
        expiresAt: expiresAt);
  }
}
