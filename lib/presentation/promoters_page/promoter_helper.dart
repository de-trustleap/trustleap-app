import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:flutter/material.dart';

class PromoterHelper {

    String? getPromoterDateText(BuildContext context, Promoter promoter) {
    if (promoter.expiresAt != null && promoter.registered == false) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.expiresAt!);
      return "Läuft am $date ab";
    } else if (promoter.createdAt != null && promoter.registered == true) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.createdAt!);
      return "Mitglied seit $date";
    } else {
      return null;
    }
  }

}