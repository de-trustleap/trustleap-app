// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddNewLandingPageGridTile extends StatelessWidget {
  final Function onPressed;

  const AddNewLandingPageGridTile({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return InkWell(
      onTap: () => onPressed(),
      child: Container(
          width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
          height: responsiveValue.largerThan(MOBILE) ? 300 : 300,
          decoration: BoxDecoration(
              color: themeData.colorScheme.background,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add,
                      size: responsiveValue.isMobile ? 30 : 50,
                      color: themeData.colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text(localization.landingpage_create_txt,
                      style: themeData.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.secondary),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)
                ],
              ))),
    );
  }
}
