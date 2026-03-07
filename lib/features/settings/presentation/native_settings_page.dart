import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/legals/presentation/legals_page.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/theme_switch.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NativeSettingsPage extends StatelessWidget {
  const NativeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            localization.settings_theme_label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ThemeSwitch(),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            localization.settings_legal_section_title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ),
        ListTile(
          title: Text(localization.settings_privacy_policy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LegalsPage(legalsType: LegalsType.privacyPolicy),
          )),
        ),
        ListTile(
          title: Text(localization.settings_terms_and_conditions),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LegalsPage(legalsType: LegalsType.termsAndCondition),
          )),
        ),
        ListTile(
          title: Text(localization.settings_imprint),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LegalsPage(legalsType: LegalsType.imprint),
          )),
        ),
        const Divider(),
        ListTile(
          title: Text(
            localization.settings_logout,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
          onTap: () => BlocProvider.of<AuthCubit>(context).signOut(),
        ),
      ],
    );
  }
}
