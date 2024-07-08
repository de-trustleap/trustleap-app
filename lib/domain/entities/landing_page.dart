// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class LandingPage extends Equatable {
  final UniqueID id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final UniqueID? ownerID;
  final String? text;
  final List<String>? associatedUsersIDs;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;

  const LandingPage(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.text,
      this.associatedUsersIDs,
      this.createdAt,
      this.lastUpdatedAt});

  LandingPage copyWith(
      {UniqueID? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      UniqueID? ownerID,
      String? text,
      List<String>? associatedUsersIDs,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return LandingPage(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        text: text ?? this.text,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt);
  }

  @override
  List<Object?> get props =>
      [id, name, downloadImageUrl, thumbnailDownloadURL, ownerID, text];
}
