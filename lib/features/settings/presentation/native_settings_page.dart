import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NativeSettingsPage extends StatefulWidget {
  const NativeSettingsPage({super.key});

  @override
  State<NativeSettingsPage> createState() => _NativeSettingsPageState();
}

class _NativeSettingsPageState extends State<NativeSettingsPage> {
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState is ThemeChanged
            ? themeState.status == ThemeStatus.dark
            : MediaQuery.of(context).platformBrightness == Brightness.dark;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader(localization.settings_theme_label, theme),
            const SizedBox(height: 8),
            CardContainer(
              maxWidth: double.infinity,
              padding: EdgeInsets.zero,
              child: _toggleRow(
                icon: Icons.dark_mode,
                iconColor: Colors.indigo,
                title: localization.settings_theme_dark,
                subtitle: localization.settings_dark_mode_subtitle,
                value: isDark,
                theme: theme,
                colorScheme: colorScheme,
                onChanged: (value) => context.read<ThemeCubit>().changeTheme(
                      value ? ThemeStatus.dark : ThemeStatus.light,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(localization.settings_legal_section_title, theme),
            const SizedBox(height: 8),
            CardContainer(
              maxWidth: double.infinity,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _navRow(
                    icon: Icons.security,
                    iconColor: Colors.blue.shade700,
                    title: localization.settings_privacy_policy,
                    theme: theme,
                    colorScheme: colorScheme,
                    onTap: () => CustomNavigator.of(context)
                        .pushNamed(RoutePaths.privacyPolicy),
                  ),
                  _divider(theme),
                  _navRow(
                    icon: Icons.business,
                    iconColor: Colors.orange.shade700,
                    title: localization.settings_imprint,
                    theme: theme,
                    colorScheme: colorScheme,
                    onTap: () => CustomNavigator.of(context)
                        .pushNamed(RoutePaths.imprint),
                  ),
                  _divider(theme),
                  _navRow(
                    icon: Icons.article,
                    iconColor: colorScheme.primary,
                    title: localization.settings_terms_and_conditions,
                    theme: theme,
                    colorScheme: colorScheme,
                    onTap: () => CustomNavigator.of(context)
                        .pushNamed(RoutePaths.termsAndCondition),
                  ),
                  _divider(theme),
                  _infoRow(
                    icon: Icons.info_outline,
                    iconColor: Colors.teal,
                    title: localization.settings_app_version,
                    trailing: _version != null ? 'v$_version' : '...',
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CardContainer(
              maxWidth: double.infinity,
              padding: EdgeInsets.zero,
              child: _navRow(
                icon: Icons.logout,
                iconColor: colorScheme.error,
                title: localization.settings_logout,
                titleColor: colorScheme.error,
                theme: theme,
                colorScheme: colorScheme,
                onTap: () => context.read<AuthCubit>().signOut(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) => Divider(
        height: 1,
        thickness: 1,
        indent: 56,
        color: Colors.grey.withValues(alpha: 0.2),
      );

  Widget _iconBox(IconData icon, Color color) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      );

  Widget _toggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          _iconBox(icon, iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _navRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            _iconBox(icon, iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(color: titleColor),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String trailing,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _iconBox(icon, iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          Text(
            trailing,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
