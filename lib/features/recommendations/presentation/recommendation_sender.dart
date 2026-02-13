import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

class RecommendationSender {
  String _createRecommendationLink(RecommendationItem recommendation) {
    final baseURL = Environment().getLandingpageBaseURL();
    return "$baseURL?p=${recommendation.promoterName}&id=${recommendation.id}";
  }

  String _prepareMessage(String message, String link) {
    return message.replaceAll("[LINK]", link);
  }

  Future<bool> sendViaWhatsApp({
    required BuildContext context,
    required RecommendationItem recommendation,
    required String message,
    Function()? onWebOpen,
  }) async {
    final link = _createRecommendationLink(recommendation);
    final adaptedMessage = _prepareMessage(message, link);
    final localization = AppLocalizations.of(context);

    final whatsappURL =
        "https://api.whatsapp.com/send/?text=${Uri.encodeComponent(adaptedMessage)}";
    final convertedURL = Uri.parse(whatsappURL);

    if (kIsWeb) {
      web.window.open(whatsappURL, '_blank');
      onWebOpen?.call();
      return true;
    } else {
      if (await canLaunchUrl(convertedURL)) {
        await launchUrl(convertedURL, mode: LaunchMode.externalApplication);
        return true;
      } else {
        if (context.mounted) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.recommendation_page_send_whatsapp_error);
        }
        return false;
      }
    }
  }

  Future<bool> sendViaEmail({
    required BuildContext context,
    required RecommendationItem recommendation,
    required String message,
    Function()? onWebOpen,
  }) async {
    final link = _createRecommendationLink(recommendation);
    final adaptedMessage = _prepareMessage(message, link);
    final localization = AppLocalizations.of(context);

    final body = Uri.encodeComponent(adaptedMessage);
    final emailURL = "mailto:?body=$body";
    final convertedURL = Uri.parse(emailURL);

    if (kIsWeb) {
      web.window.open(emailURL, '_blank');
      onWebOpen?.call();
      return true;
    } else {
      if (await canLaunchUrl(convertedURL)) {
        await launchUrl(convertedURL, mode: LaunchMode.externalApplication);
        return true;
      } else {
        if (context.mounted) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.recommendation_page_send_email_error);
        }
        return false;
      }
    }
  }
}
