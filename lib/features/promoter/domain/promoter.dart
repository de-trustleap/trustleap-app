// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/promoter/domain/unregistered_promoter.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';

class Promoter extends Equatable {
  final UniqueID id;
  final Gender? gender;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? email;
  final String? thumbnailDownloadURL;
  final List<String>? landingPageIDs;
  final List<LandingPage>? landingPages;
  final bool? registered;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const Promoter(
      {required this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.email,
      this.thumbnailDownloadURL,
      this.landingPageIDs,
      this.landingPages,
      this.registered,
      this.expiresAt,
      this.createdAt});

  Promoter copyWith(
      {UniqueID? id,
      Gender? gender,
      String? firstName,
      String? lastName,
      String? birthDate,
      String? email,
      String? thumbnailDownloadURL,
      List<String>? landingPageIDs,
      List<LandingPage>? landingPages,
      bool? registered,
      DateTime? expiresAt,
      DateTime? createdAt}) {
    return Promoter(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        email: email ?? this.email,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        landingPageIDs: landingPageIDs ?? this.landingPageIDs,
        landingPages: landingPages ?? this.landingPages,
        registered: registered ?? this.registered,
        expiresAt: expiresAt ?? this.expiresAt,
        createdAt: createdAt ?? this.createdAt);
  }

  factory Promoter.fromUser(CustomUser user) {
    return Promoter(
        id: user.id,
        gender: user.gender,
        firstName: user.firstName,
        lastName: user.lastName,
        birthDate: user.birthDate,
        email: user.email,
        thumbnailDownloadURL: user.thumbnailDownloadURL,
        landingPageIDs: user.landingPageIDs,
        registered: true,
        expiresAt: null,
        createdAt: user.createdAt);
  }

  factory Promoter.fromUnregisteredPromoter(UnregisteredPromoter promoter) {
    return Promoter(
        id: promoter.id,
        gender: promoter.gender,
        firstName: promoter.firstName,
        lastName: promoter.lastName,
        email: promoter.email,
        thumbnailDownloadURL: null,
        landingPageIDs: promoter.landingPageIDs,
        registered: false,
        expiresAt: promoter.expiresAt);
  }

  @override
  List<Object?> get props => [
        id,
        gender,
        firstName,
        lastName,
        birthDate,
        email,
        thumbnailDownloadURL,
        landingPageIDs,
        landingPages,
        registered
      ];
}
