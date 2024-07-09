import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegisterPromoterNoLandingPageView extends StatelessWidget {
  const RegisterPromoterNoLandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning,
                size: responsiveValue.isMobile ? 40 : 60,
                color: themeData.colorScheme.error),
            const SizedBox(height: 16),
            Text("Du kannst noch keine Landingpage erstellt",
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: responsiveValue.isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
                "Um einen neuen Promoter erstellen zu können ist es nötig, eine aktive Landingpage zu haben.",
                style: themeData.textTheme.headlineLarge),
          ]),
    );
  }
}
