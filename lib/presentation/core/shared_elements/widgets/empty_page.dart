// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmptyPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final String buttonTitle;
  final bool isButtonHidden;
  final Function? onTap;

  const EmptyPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    this.isButtonHidden = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(color: themeData.colorScheme.background),
        child: CenteredConstrainedWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: responsiveValue.isMobile ? 40 : 60,
                color: themeData.colorScheme.secondary),
            const SizedBox(height: 16),
            Text(title,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: responsiveValue.isMobile ? 20 : 24)),
            const SizedBox(height: 16),
            Text(subTitle,
                style: themeData.textTheme.headlineLarge,
                textAlign: TextAlign.center),
            if (!isButtonHidden) ...[
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                      title: buttonTitle,
                      width: responsiveValue.isMobile
                          ? responsiveValue.screenWidth - 20
                          : 300,
                      onTap: () => onTap != null ? onTap!() : {}),
                ],
              )
            ]
          ],
        )));
  }
}
