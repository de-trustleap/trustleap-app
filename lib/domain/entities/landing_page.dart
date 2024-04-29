// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class LandingPage extends Equatable {
  final UniqueID id;
  final String? name;
  final String? downloadImageUrl;
  final String? thumbnailDownloadURL;
  final UniqueID? parentUserId;
  final String? text;
  final DateTime? createdAt;


 const LandingPage({
    required this.id,
    this.name,
    this.downloadImageUrl,
    this.thumbnailDownloadURL,
    this.parentUserId,
    this.text,
    this.createdAt,
  });

  LandingPage copyWith({
    UniqueID? id,
    String? name,
    String? downloadImageUrl,
    String? thumbnailDownloadURL,
    UniqueID? parentUserId,
    String? text,
    DateTime? createdAt,
  }) {
    return LandingPage(
      id: id ?? this.id,
      name: name ?? this.name,
      downloadImageUrl: downloadImageUrl ?? this.downloadImageUrl,
      thumbnailDownloadURL: thumbnailDownloadURL ?? this.thumbnailDownloadURL,
      parentUserId: parentUserId ?? this.parentUserId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
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
