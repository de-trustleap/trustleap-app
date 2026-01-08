import 'package:finanzbegleiter/application/consent/consent_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/consent/cookie_consent_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CookieConsentBanner extends StatelessWidget {
  final VoidCallback onCustomizePressed;

  const CookieConsentBanner({
    super.key,
    required this.onCustomizePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = CookieConsentTexts(AppLocalizations.of(context));
    final cubit = Modular.get<ConsentCubit>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      texts.bannerTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      texts.bannerDescription,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: () => cubit.rejectAll(),
                    child: Text(texts.bannerRejectAll),
                  ),
                  OutlinedButton(
                    onPressed: onCustomizePressed,
                    child: Text(texts.bannerCustomize),
                  ),
                  ElevatedButton(
                    onPressed: () => cubit.acceptAll(),
                    child: Text(texts.bannerAcceptAll),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
