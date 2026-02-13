// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/legals/domain/avv.dart';
import 'package:finanzbegleiter/core/id.dart';

class Company extends Equatable {
  final UniqueID id;
  final String? name;
  final String? industry;
  final String? address;
  final String? postCode;
  final String? place;
  final String? phoneNumber;
  final String? websiteURL;
  final String? companyImageDownloadURL;
  final String? thumbnailDownloadURL;
  final String? ownerID;
  final String? defaultLandingPageID;
  final List<String>? employeeIDs;
  final DateTime? createdAt;
  final AVV? avv;

  const Company(
      {required this.id,
      this.name,
      this.industry,
      this.address,
      this.postCode,
      this.place,
      this.phoneNumber,
      this.websiteURL,
      this.companyImageDownloadURL,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.defaultLandingPageID,
      this.employeeIDs,
      this.createdAt,
      this.avv});

  Company copyWith(
      {UniqueID? id,
      String? name,
      String? industry,
      String? address,
      String? postCode,
      String? place,
      String? phoneNumber,
      String? websiteURL,
      String? companyImageDownloadURL,
      String? thumbnailDownloadURL,
      String? ownerID,
      String? defaultLandingPageID,
      List<String>? employeeIDs,
      DateTime? createdAt,
      AVV? avv}) {
    return Company(
        id: id ?? this.id,
        name: name ?? this.name,
        industry: industry ?? this.industry,
        address: address ?? this.address,
        postCode: postCode ?? this.postCode,
        place: place ?? this.place,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        websiteURL: websiteURL ?? this.websiteURL,
        companyImageDownloadURL:
            companyImageDownloadURL ?? this.companyImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        defaultLandingPageID: defaultLandingPageID ?? this.defaultLandingPageID,
        employeeIDs: employeeIDs ?? this.employeeIDs,
        createdAt: createdAt ?? this.createdAt,
        avv: avv ?? this.avv);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        industry,
        address,
        postCode,
        place,
        phoneNumber,
        websiteURL,
        companyImageDownloadURL,
        thumbnailDownloadURL,
        employeeIDs,
        ownerID,
        defaultLandingPageID,
        avv
      ];
}
