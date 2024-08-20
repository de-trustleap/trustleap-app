import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  Set<ThemeStatus> selected = {ThemeStatus.light};
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
      selected: selected,
      onSelectionChanged: (Set<ThemeStatus> newSelectedValue) {
        setState(() {
          selected = newSelectedValue;
        });
        BlocProvider.of<ThemeCubit>(context).changeTheme(selected.first);
      },
    );
  }
}
