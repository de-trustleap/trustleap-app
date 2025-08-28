// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';

class LandingPageModel extends Equatable {
  final String id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final String? ownerID;
  final String? contentID;
  final String? description;
  final String? promotionTemplate;
  final List<String>? associatedUsersIDs;
  final DateTime? lastUpdatedAt;
  final dynamic createdAt;
  final bool? isDefaultPage;
  final bool? isActive;
  final String? impressum;
  final String? privacyPolicy;
  final String? initialInformation;
  final String? termsAndConditions;
  final String? scriptTags;
  final String? contactEmailAddress;
  final String? businessModel;
  final String? contactOption;
  final String? calendlyEventURL;
  final Map<String, dynamic>? companyData;

  const LandingPageModel(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.contentID,
      this.description,
      this.promotionTemplate,
      this.associatedUsersIDs,
      this.lastUpdatedAt,
      required this.createdAt,
      this.isDefaultPage,
      this.isActive,
      this.impressum,
      this.privacyPolicy,
      this.initialInformation,
      this.termsAndConditions,
      this.scriptTags,
      this.contactEmailAddress,
      this.businessModel,
      this.contactOption,
      this.calendlyEventURL,
      this.companyData});

  LandingPageModel copyWith(
      {String? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      String? ownerID,
      String? contentID,
      String? description,
      String? promotionTemplate,
      List<String>? associatedUsersIDs,
      DateTime? lastUpdatedAt,
      dynamic createdAt,
      bool? isDefaultPage,
      bool? isActive,
      String? impressum,
      String? privacyPolicy,
      String? initialInformation,
      String? termsAndConditions,
      String? scriptTags,
      String? contactEmailAddress,
      String? businessModel,
      String? contactOption,
      String? calendlyEventURL,
      Map<String, dynamic>? companyData}) {
    return LandingPageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        contentID: contentID ?? this.contentID,
        description: description ?? this.description,
        promotionTemplate: promotionTemplate ?? this.promotionTemplate,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        createdAt: createdAt ?? this.createdAt,
        isDefaultPage: isDefaultPage ?? this.isDefaultPage,
        isActive: isActive ?? this.isActive,
        impressum: impressum ?? this.impressum,
        privacyPolicy: privacyPolicy ?? this.privacyPolicy,
        initialInformation: initialInformation ?? this.initialInformation,
        termsAndConditions: termsAndConditions ?? this.termsAndConditions,
        scriptTags: scriptTags ?? this.scriptTags,
        contactEmailAddress: contactEmailAddress ?? this.contactEmailAddress,
        businessModel: businessModel ?? this.businessModel,
        contactOption: contactOption ?? this.contactOption,
        calendlyEventURL: calendlyEventURL ?? this.calendlyEventURL,
        companyData: companyData ?? this.companyData);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'downloadImageUrl': downloadImageUrl,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'ownerID': ownerID,
      'contentID': contentID,
      'description': description,
      'promotionTemplate': promotionTemplate,
      'associatedUsersIDs': associatedUsersIDs,
      'lastUpdatedAt': lastUpdatedAt,
      'createdAt': createdAt,
      'isDefaultPage': isDefaultPage,
      'isActive': isActive,
      'impressum': impressum,
      'privacyPolicy': privacyPolicy,
      'initialInformation': initialInformation,
      'termsAndConditions': termsAndConditions,
      'scripts': scriptTags,
      'contactEmailAddress': contactEmailAddress,
      'businessModel': businessModel,
      'contactOption': contactOption,
      'calendlyEventURL': calendlyEventURL,
      'companyData': companyData
    };
  }

  factory LandingPageModel.fromMap(Map<String, dynamic> map) {
    return LandingPageModel(
        id: "",
        name: map['name'] != null ? map['name'] as String : null,
        downloadImageUrl: map['downloadImageUrl'] != null
            ? map['downloadImageUrl'] as String
            : null,
        thumbnailDownloadURL: (map['thumbnailDownloadURL'] != null
                ? map['thumbnailDownloadURL'] as String
                : null)
            ?.replaceAll(RegExp(r'\s+'), ''),
        ownerID: map['ownerID'] != null ? map['ownerID'] as String : null,
        contentID: map['contentID'] != null ? map['contentID'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        promotionTemplate: map['promotionTemplate'] != null
            ? map['promotionTemplate'] as String
            : null,
        associatedUsersIDs: map['associatedUsersIDs'] != null
            ? List<String>.from(map['associatedUsersIDs'])
            : null,
        lastUpdatedAt: map['lastUpdatedAt'] != null
            ? (map['lastUpdatedAt'] as Timestamp).toDate()
            : null,
        createdAt: map['createdAt'] as dynamic,
        isDefaultPage:
            map['isDefaultPage'] != null ? map['isDefaultPage'] as bool : false,
        isActive: map['isActive'] != null ? map['isActive'] as bool : null,
        impressum: map['impressum'] != null ? map['impressum'] as String : null,
        privacyPolicy: map['privacyPolicy'] != null
            ? map['privacyPolicy'] as String
            : null,
        initialInformation: map['initialInformation'] != null
            ? map['initialInformation'] as String
            : null,
        termsAndConditions: map['termsAndConditions'] != null
            ? map['termsAndConditions'] as String
            : null,
        scriptTags: map['scripts'] != null ? map['scripts'] as String : null,
        contactEmailAddress: map['contactEmailAddress'] != null
            ? map['contactEmailAddress'] as String
            : null,
        businessModel: map['businessModel'] != null
            ? map['businessModel'] as String
            : null,
        contactOption: map['contactOption'] != null
            ? map['contactOption'] as String
            : null,
        calendlyEventURL: map['calendlyEventURL'] != null
            ? map['calendlyEventURL'] as String
            : null,
        companyData: map['companyData'] != null
            ? map['companyData'] as Map<String, dynamic>
            : null);
  }

  factory LandingPageModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return LandingPageModel.fromMap(doc).copyWith(id: id);
  }

  LandingPage toDomain() {
    return LandingPage(
        id: UniqueID.fromUniqueString(id),
        name: name,
        downloadImageUrl: downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL,
        ownerID: ownerID != null ? UniqueID.fromUniqueString(ownerID!) : null,
        contentID:
            contentID != null ? UniqueID.fromUniqueString(contentID!) : null,
        description: description,
        promotionTemplate: promotionTemplate,
        associatedUsersIDs: associatedUsersIDs,
        lastUpdatedAt: lastUpdatedAt,
        createdAt: (createdAt as Timestamp).toDate(),
        isDefaultPage: isDefaultPage ?? false,
        isActive: isActive,
        impressum: impressum,
        privacyPolicy: privacyPolicy,
        initialInformation: initialInformation,
        termsAndConditions: termsAndConditions,
        scriptTags: scriptTags,
        contactEmailAddress: contactEmailAddress,
        businessModel: _getBusinessModelFromString(businessModel),
        contactOption: _getContactOptionFromString(contactOption),
        calendlyEventURL: calendlyEventURL,
        companyData: companyData);
  }

  factory LandingPageModel.fromDomain(LandingPage landingPage) {
    return LandingPageModel(
        id: landingPage.id.value,
        name: landingPage.name,
        downloadImageUrl: landingPage.downloadImageUrl,
        thumbnailDownloadURL: landingPage.thumbnailDownloadURL,
        ownerID: landingPage.ownerID?.value,
        contentID: landingPage.contentID?.value,
        description: landingPage.description,
        promotionTemplate: landingPage.promotionTemplate,
        associatedUsersIDs: landingPage.associatedUsersIDs,
        lastUpdatedAt: landingPage.lastUpdatedAt,
        createdAt: FieldValue.serverTimestamp(),
        isDefaultPage: landingPage.isDefaultPage,
        isActive: landingPage.isActive,
        impressum: landingPage.impressum,
        privacyPolicy: landingPage.privacyPolicy,
        initialInformation: landingPage.initialInformation,
        termsAndConditions: landingPage.termsAndConditions,
        scriptTags: landingPage.scriptTags,
        contactEmailAddress: landingPage.contactEmailAddress,
        businessModel: landingPage.businessModel?.name,
        contactOption: landingPage.contactOption?.name,
        calendlyEventURL: landingPage.calendlyEventURL,
        companyData: landingPage.companyData);
  }

  BusinessModel? _getBusinessModelFromString(String? businessModel) {
    if (businessModel == null) {
      return null;
    }
    switch (businessModel) {
      case "b2b":
        return BusinessModel.b2b;
      case "b2c":
        return BusinessModel.b2c;
      default:
        return null;
    }
  }

  ContactOption? _getContactOptionFromString(String? contactOption) {
    if (contactOption == null) {
      return null;
    }
    switch (contactOption) {
      case "calendly":
        return ContactOption.calendly;
      case "contactForm":
        return ContactOption.constactForm;
      case "both":
        return ContactOption.both;
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        downloadImageUrl,
        thumbnailDownloadURL,
        ownerID,
        contentID,
        description,
        promotionTemplate,
        isDefaultPage,
        isActive,
        impressum,
        privacyPolicy,
        initialInformation,
        termsAndConditions,
        scriptTags,
        contactEmailAddress,
        businessModel,
        contactOption,
        calendlyEventURL,
        companyData
      ];
}

// TODO: RADIO BUTTON FÜR CONTACTOPTION EINFÜGEN (DONE)
// TODO: WENN BOTH ODER CONTACTFORM GEWÄHLT WIRD DANN KONTAKT EMAIL FELD ANZEIGEN (DONE)
// TODO: WENN BOTH ODER CALENDLY ANGEZEIGT WIRD DANN CALENDLY URL UND WEBHOOK URL FELDER ANZEIGEN (DONE)
// TODO: CALENDLY ACCOUNT MACHEN UND CLIENTID, CLIENTSECRET UND REDIRECTURI ERHALTEN (DONE)
// TODO: EXCHANGECODEFORTOKEN IN BACKEND IMPLEMENTIEREN (DONE)
// TODO: KONTAKT EMAIL VON SEITE 1 LÖSCHEN (DONE)
// TODO: PROFILE CALENDLY SECTION (DONE)
// TODO: VALIDIERUNG
// TODO: SNACKBAR WIRD ZU OFT ANGEZEIGT
// TODO: BACKEND ANPASSEN FÜR WEBHOOKS
// TODO: LOCALIZATION
