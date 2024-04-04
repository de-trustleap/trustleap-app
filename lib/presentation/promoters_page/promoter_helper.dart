// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';

class PromoterHelper {
  final AppLocalizations localization;

  PromoterHelper({
    required this.localization,
  });

  String? getPromoterDateText(BuildContext context, Promoter promoter) {
    if (promoter.expiresAt != null && promoter.registered == false) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.expiresAt!);
      return localization.promoter_overview_expiration_date(date);
    } else if (promoter.createdAt != null && promoter.registered == true) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.createdAt!);
      return localization.promoter_overview_creation_date(date);
    } else {
      return null;
    }
  }
}
