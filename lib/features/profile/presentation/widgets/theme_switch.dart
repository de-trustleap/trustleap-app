import 'package:finanzbegleiter/theme/theme_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      bloc: Modular.get<ThemeCubit>(),
      builder: (context, themeState) {
        final ThemeStatus currentStatus;
        if (themeState is ThemeChanged) {
          currentStatus = themeState.status;
        } else {
          final brightness = MediaQuery.of(context).platformBrightness;
          currentStatus = brightness == Brightness.dark
              ? ThemeStatus.dark
              : ThemeStatus.light;
        }
        return SegmentedButton<ThemeStatus>(
          segments: [
            ButtonSegment<ThemeStatus>(
                value: ThemeStatus.light,
                tooltip: localizations.theme_switch_lightmode_tooltip,
                icon: const Icon(Icons.wb_sunny)),
            ButtonSegment<ThemeStatus>(
                value: ThemeStatus.dark,
                tooltip: localizations.theme_switch_darkmode_tooltip,
                icon: const Icon(Icons.wb_cloudy))
          ],
          showSelectedIcon: false,
          selected: {currentStatus},
          onSelectionChanged: (Set<ThemeStatus> newSelectedValue) {
            Modular.get<ThemeCubit>().changeTheme(newSelectedValue.first);
          },
        );
      },
    );
  }
}
