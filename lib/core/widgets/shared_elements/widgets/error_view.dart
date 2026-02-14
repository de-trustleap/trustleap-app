// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final Function callback;

  const ErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning,
                size: responsiveValue.isMobile ? 40 : 60,
                color: themeData.colorScheme.error),
            const SizedBox(height: 16),
            SelectableText(title,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: responsiveValue.isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SelectableText(message, style: themeData.textTheme.headlineLarge),
            const SizedBox(height: 32),
            PrimaryButton(
                title: localization.general_error_view_refresh_button_title,
                onTap: callback,
                width: 300)
          ]),
    );
  }
}
