// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final Function callback;

  const ErrorView({
    Key? key,
    required this.title,
    required this.message,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
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
            Text(title,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: responsiveValue.isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(message, style: themeData.textTheme.headlineLarge),
            const SizedBox(height: 32),
            PrimaryButton(
                title: localization.general_error_view_refresh_button_title,
                onTap: callback,
                width: 300)
          ]),
    );
  }
}
