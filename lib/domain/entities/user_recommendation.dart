import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

enum RecommendationPriority {
  low,
  medium,
  high;

  String getLocalizedLabel(AppLocalizations localizations) {
    switch (this) {
      case RecommendationPriority.low:
        return localizations.recommendation_priority_low;
      case RecommendationPriority.medium:
        return localizations.recommendation_priority_medium;
      case RecommendationPriority.high:
        return localizations.recommendation_priority_high;
    }
  }
}

class UserRecommendation extends Equatable {
  final UniqueID id;
  final String? recoID;
  final String? userID;
  final RecommendationPriority? priority;
  final String? notes;
  final DateTime? notesLastEdited;
  final RecommendationItem? recommendation;

  const UserRecommendation(
      {required this.id,
      required this.recoID,
      required this.userID,
      required this.priority,
      required this.notes,
      required this.notesLastEdited,
      required this.recommendation});

  UserRecommendation copyWith(
      {UniqueID? id,
      String? recoID,
      String? userID,
      RecommendationPriority? priority,
      String? notes,
      DateTime? notesLastEdited,
      RecommendationItem? recommendation}) {
    return UserRecommendation(
        id: id ?? this.id,
        recoID: recoID ?? this.recoID,
        userID: userID ?? this.userID,
        priority: priority ?? this.priority,
        notes: notes ?? this.notes,
        notesLastEdited: notesLastEdited ?? this.notesLastEdited,
        recommendation: recommendation ?? this.recommendation);
  }

  @override
  List<Object?> get props =>
      [id, recoID, userID, priority, notes, notesLastEdited, recommendation];
}
