import 'package:finanzbegleiter/features/consent/presentation/cookie_settings_dialog.dart';
import 'package:flutter/material.dart';

/// Icon button to open cookie settings dialog.
/// Designed to be placed in menu above ThemeSwitcher.
class CookieSettingsButton extends StatelessWidget {
  const CookieSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showSettingsDialog(context),
      icon: const Icon(Icons.cookie_outlined),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CookieSettingsDialog(),
    );
  }
}
