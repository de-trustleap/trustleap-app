import 'package:finanzbegleiter/application/consent/consent_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/consent/cookie_consent_texts.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/outlined_custom_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
          child: ResponsiveBreakpoints.of(context).isMobile
              ? _buildMobileLayout(context, theme, texts, cubit)
              : _buildDesktopLayout(context, theme, texts, cubit),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ThemeData theme,
    CookieConsentTexts texts,
    ConsentCubit cubit,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.cookie_outlined,
            size: 28,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 20),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedCustomButton(
                    title: texts.bannerCustomize,
                    width: 150,
                    onTap: onCustomizePressed,
                    color: theme.colorScheme.surfaceTint.withValues(alpha: 0.8),
                  ),
                  const Spacer(),
                  OutlinedCustomButton(
                    title: texts.bannerRejectAll,
                    width: 120,
                    onTap: () => cubit.rejectAll(),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    title: texts.bannerAcceptAll,
                    width: 180,
                    onTap: () => cubit.acceptAll(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    CookieConsentTexts texts,
    ConsentCubit cubit,
  ) {
    return Column(
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
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedCustomButton(
                    title: texts.bannerCustomize,
                    onTap: onCustomizePressed,
                    color: theme.colorScheme.surfaceTint.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedCustomButton(
                    title: texts.bannerRejectAll,
                    onTap: () => cubit.rejectAll(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              title: texts.bannerAcceptAll,
              onTap: () => cubit.acceptAll(),
            ),
          ],
        ),
      ],
    );
  }
}
