// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';

class LandingPage extends Equatable {
  final UniqueID id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final UniqueID? ownerID;
  final String? description;
  final List<String>? associatedUsersIDs;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final bool? isDefaultPage;

  const LandingPage(
      {required this.id,
      this.name,
      this.downloadImageUrl,
      this.thumbnailDownloadURL,
      this.ownerID,
      this.description,
      this.associatedUsersIDs,
      this.createdAt,
      this.lastUpdatedAt,
      this.isDefaultPage});

  LandingPage copyWith(
      {UniqueID? id,
      String? name,
      String? downloadImageUrl,
      String? thumbnailDownloadURL,
      UniqueID? ownerID,
      String? description,
      List<String>? associatedUsersIDs,
      DateTime? createdAt,
      DateTime? lastUpdatedAt,
      bool? isDefaultPage}) {
    return LandingPage(
        id: id ?? this.id,
        name: name ?? this.name,
        downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
        thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
        ownerID: ownerID ?? this.ownerID,
        description: description ?? this.description,
        associatedUsersIDs: associatedUsersIDs ?? this.associatedUsersIDs,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        isDefaultPage: isDefaultPage ?? this.isDefaultPage);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        downloadImageUrl,
        thumbnailDownloadURL,
        ownerID,
        description,
        isDefaultPage
      ];
}
