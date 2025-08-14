import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      padding: responsiveValue.isMobile
          ? const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
          : const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Modular.to.pushNamed(RoutePaths.privacyPolicy);
            },
            child: Text(
              'Datenschutzerklärung',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.secondary,
              ),
            ),
          ),
          Text(
            ' | ',
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.secondary,
            ),
          ),
          TextButton(
            onPressed: () {
              Modular.to.pushNamed(RoutePaths.imprint);
            },
            child: Text(
              'Impressum',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.secondary,
              ),
            ),
          ),
          Text(
            ' | ',
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.secondary,
            ),
          ),
          TextButton(
            onPressed: () {
              Modular.to.pushNamed(RoutePaths.termsAndCondition);
            },
            child: Text(
              'AGBs',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
