import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/domain/entities/last_edit.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManagerListTileHelper {
  static double getOverlayOpacity(
    UserRecommendation recommendation,
    String currentUserID,
    bool shouldAnimateToSurface,
  ) {
    final hasUnseenChanges = recommendation.hasUnseenChanges(currentUserID);

    if (shouldAnimateToSurface) {
      return 0.0;
    }

    if (hasUnseenChanges) {
      return 0.1;
    }
    return 0.0;
  }

  static Future<String?> buildLastEditMessage(
    UserRecommendation recommendation,
    String currentUserID,
    AppLocalizations localizations,
  ) async {
    final lastViewed = recommendation.viewedByUsers
        .where((view) => view.userID == currentUserID)
        .firstOrNull;

    // Filter nur Änderungen von anderen Usern
    final changesFromOthers = recommendation.lastEdits
        .where((edit) => edit.editedBy != currentUserID);

    List<LastEdit> relevantEdits;
    if (lastViewed == null) {
      relevantEdits = changesFromOthers.toList();
    } else {
      relevantEdits = changesFromOthers
          .where((edit) => edit.editedAt.isAfter(lastViewed.viewedAt))
          .toList();
    }

    if (relevantEdits.isEmpty) return null;

    // Gruppiere nach Benutzer und sortiere nach neuester Bearbeitung
    final editsByUser = <String, List<LastEdit>>{};
    for (final edit in relevantEdits) {
      editsByUser.putIfAbsent(edit.editedBy, () => []).add(edit);
    }

    final userWithMostRecentEdit = editsByUser.entries
        .map((entry) => MapEntry(
            entry.key,
            entry.value
                .map((e) => e.editedAt)
                .reduce((a, b) => a.isAfter(b) ? a : b)))
        .reduce((a, b) => a.value.isAfter(b.value) ? a : b);

    final userEdits = editsByUser[userWithMostRecentEdit.key]!;
    final editedFields = <String>{};

    for (final edit in userEdits) {
      switch (edit.fieldName) {
        case "priority":
          editedFields.add(localizations.recommendation_manager_field_priority);
          break;
        case "notes":
          editedFields.add(localizations.recommendation_manager_field_notes);
          break;
        default:
          editedFields.add(edit.fieldName);
      }
    }

    final cubit = Modular.get<RecommendationManagerTileCubit>();
    final userName = await cubit.getUserDisplayName(userWithMostRecentEdit.key);
    if (userName.isEmpty) return null;

    final fieldsText = editedFields.toList().join(localizations.recommendation_manager_field_connector);

    return localizations.recommendation_manager_edit_message(userName, fieldsText);
  }
}