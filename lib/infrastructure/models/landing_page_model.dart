// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';

class LandingPageModel extends Equatable {
  final String id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final String? parentUserId;
  final String? text;
  final dynamic createdAt;


  const LandingPageModel({
    required this.id,
    this.name,
    this.downloadImageUrl,
    this.thumbnailDownloadURL,
    this.parentUserId,
    this.text,
    required this.createdAt,
  });

  LandingPageModel copyWith({
    String? id,
    String? name,
    String? downloadImageUrl,
    String? thumbnailDownloadURL,
    String? parentUserId,
    String? text,
    dynamic createdAt,
  }) {
    return LandingPageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
      parentUserId: parentUserId ?? this.parentUserId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'downloadImageUrl': downloadImageUrl,
      'thumbnailDownloadURL': thumbnailDownloadURL,
      'parentUserId': parentUserId,
      'text': text,
      'createdAt': createdAt,
    };
  }

  factory LandingPageModel.fromMap(Map<String, dynamic> map) {
    return LandingPageModel(
      id: "",
      name: map['name'] != null ? map['name'] as String : null,
      downloadImageUrl: map['downloadImageUrl'] != null ? map['downloadImageUrl'] as String : null,
      thumbnailDownloadURL: map['thumbnailDownloadURL'] != null ? map['thumbnailDownloadURL'] as String : null,
      parentUserId: map['parentUserId'] != null ? map['parentUserId'] as String : null,
      text: map['text'] != null ? map['text'] as String : null,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  factory LandingPageModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return LandingPageModel.fromMap(doc).copyWith(id: id);
  }

  LandingPage toDomain(){
    return LandingPage(
      id: UniqueID.fromUniqueString(id),
      name: name,
      downloadImageUrl: downloadImageUrl,
      thumbnailDownloadURL: thumbnailDownloadURL,
      parentUserId: UniqueID.fromUniqueString(parentUserId ?? ""),
      text: text,
      createdAt: (createdAt as Timestamp).toDate()
    );
  }

  factory LandingPageModel.fromDomain(LandingPage landingPage) {
    return LandingPageModel(
      id: landingPage.id.value,
      name: landingPage.name,
      downloadImageUrl: landingPage.downloadImageUrl,
      thumbnailDownloadURL: landingPage.thumbnailDownloadURL,
      parentUserId: landingPage.parentUserId?.value ?? "",
      text: landingPage.text,
      createdAt: FieldValue.serverTimestamp()
    );
  }

  @override
  
  List<Object?> get props => [
        id,
        name,
        downloadImageUrl,
        thumbnailDownloadURL,
        parentUserId,
        text
      ];
  }
