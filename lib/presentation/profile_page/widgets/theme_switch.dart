import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
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
    return SegmentedButton<ThemeStatus>(
      segments: const [
        ButtonSegment<ThemeStatus>(
            value: ThemeStatus.light, icon: Icon(Icons.wb_sunny)),
        ButtonSegment<ThemeStatus>(
            value: ThemeStatus.dark, icon: Icon(Icons.wb_cloudy))
      ],
      showSelectedIcon: false,
      selected: selected,
      onSelectionChanged: (Set<ThemeStatus> newSelectedValue) {
        setState(() {
          selected = newSelectedValue;
        });
        print("PRESSED!");
        BlocProvider.of<ThemeCubit>(context).changeTheme(selected.first);
      },
    );
  }
}
