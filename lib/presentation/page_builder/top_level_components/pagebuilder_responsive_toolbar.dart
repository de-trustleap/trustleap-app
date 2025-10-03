import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderResponsiveToolbar extends StatelessWidget {
  final VoidCallback onClose;

  const PagebuilderResponsiveToolbar({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final breakpointCubit = Modular.get<PagebuilderResponsiveBreakpointCubit>();

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: breakpointCubit,
      builder: (context, currentBreakpoint) {
        return Container(
          width: double.infinity,
          color: const Color(0xFF40464A),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      breakpointCubit.setMobile();
                    },
                    icon: Icon(
                      Icons.phone_android,
                      color: currentBreakpoint ==
                              PagebuilderResponsiveBreakpoint.mobile
                          ? themeData.colorScheme.secondary
                          : Colors.white,
                    ),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      breakpointCubit.setTablet();
                    },
                    icon: Icon(
                      Icons.tablet_mac,
                      color: currentBreakpoint ==
                              PagebuilderResponsiveBreakpoint.tablet
                          ? themeData.colorScheme.secondary
                          : Colors.white,
                    ),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      breakpointCubit.setDesktop();
                    },
                    icon: Icon(
                      Icons.desktop_windows,
                      color: currentBreakpoint ==
                              PagebuilderResponsiveBreakpoint.desktop
                          ? themeData.colorScheme.secondary
                          : Colors.white,
                    ),
                    iconSize: 24,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  breakpointCubit.setDesktop();
                  onClose();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                iconSize: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
