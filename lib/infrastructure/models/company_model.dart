// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class CompanyModel extends Equatable {
  final String id;
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
  final dynamic createdAt;

  const CompanyModel({
    required this.id,
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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'industry': industry,
      'address': address,
      'postCode': postCode,
      'place': place,
      'phoneNumber': phoneNumber,
      'websiteURL': websiteURL,
      'companyImageDownloadURL': companyImageDownloadURL,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'ownerID': ownerID,
      'defaultLandingPageID': defaultLandingPageID,
      'employeeIDs': employeeIDs,
      'createdAt': createdAt,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: "",
      name: map['name'] != null ? map['name'] as String : null,
      industry: map['industry'] != null ? map['industry'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      postCode: map['postCode'] != null ? map['postCode'] as String : null,
      place: map['place'] != null ? map['place'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      websiteURL:
          map['websiteURL'] != null ? map['websiteURL'] as String : null,
      companyImageDownloadURL: map['thumbnailDownloadURL'] != null
          ? map['thumbnailDownloadURL'] as String
          : null,
      thumbnailDownloadURL: map['thumbnailDownloadURL'] != null
          ? map['thumbnailDownloadURL'] as String
          : null,
      ownerID: map['ownerID'] != null ? map['ownerID'] as String : null,
      defaultLandingPageID: map['defaultLandingPageID'] != null
          ? map['defaultLandingPageID'] as String
          : null,
      employeeIDs: map['employeeIDs'] != null
          ? List<String>.from(map['employeeIDs'] as List<String>)
          : null,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  CompanyModel copyWith({
    String? id,
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
    dynamic createdAt,
  }) {
    return CompanyModel(
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
    );
  }

  factory CompanyModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return CompanyModel.fromMap(doc).copyWith(id: id);
  }

  Company toDomain() {
    return Company(
        id: UniqueID.fromUniqueString(id),
        name: name,
        industry: industry,
        address: address,
        postCode: postCode,
        place: place,
        phoneNumber: phoneNumber,
        websiteURL: websiteURL,
        companyImageDownloadURL: companyImageDownloadURL,
        thumbnailDownloadURL: thumbnailDownloadURL,
        ownerID: ownerID,
        defaultLandingPageID: defaultLandingPageID,
        employeeIDs: employeeIDs,
        createdAt: (createdAt as Timestamp).toDate());
  }

  factory CompanyModel.fromDomain(Company company) {
    return CompanyModel(
        id: company.id.value,
        name: company.name,
        industry: company.industry,
        address: company.address,
        postCode: company.postCode,
        place: company.place,
        phoneNumber: company.phoneNumber,
        websiteURL: company.websiteURL,
        companyImageDownloadURL: company.companyImageDownloadURL,
        thumbnailDownloadURL: company.thumbnailDownloadURL,
        ownerID: company.ownerID,
        defaultLandingPageID: company.defaultLandingPageID,
        employeeIDs: company.employeeIDs,
        createdAt: FieldValue.serverTimestamp());
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
        ownerID,
        defaultLandingPageID,
        employeeIDs
      ];
}
