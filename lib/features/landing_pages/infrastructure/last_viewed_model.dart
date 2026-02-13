import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';

class LastViewedModel extends Equatable {
  final String userID;
  final DateTime viewedAt;

  const LastViewedModel({
    required this.userID,
    required this.viewedAt,
  });

  LastViewedModel copyWith({
    String? userID,
    DateTime? viewedAt,
  }) {
    return LastViewedModel(
      userID: userID ?? this.userID,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userID": userID,
      "viewedAt": viewedAt.toIso8601String(),
    };
  }

  factory LastViewedModel.fromMap(Map<String, dynamic> map) {
    return LastViewedModel(
      userID: map["userID"] as String,
      viewedAt: DateTime.parse(map["viewedAt"] as String),
    );
  }

  LastViewed toDomain() {
    return LastViewed(
      userID: userID,
      viewedAt: viewedAt,
    );
  }

  factory LastViewedModel.fromDomain(LastViewed lastViewed) {
    return LastViewedModel(
      userID: lastViewed.userID,
      viewedAt: lastViewed.viewedAt,
    );
  }

  @override
  List<Object?> get props => [userID, viewedAt];
}