import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileRegisterCompanySection extends StatelessWidget {
  final bool hasPendingCompanyRequest;
  const ProfileRegisterCompanySection({super.key, required this.hasPendingCompanyRequest });

  @override
  Widget build(BuildContext context) {
    print("HAS PENDING COMPANY REQUEST: $hasPendingCompanyRequest");
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const spacing = 20;

    return CardContainer(child: LayoutBuilder(builder: ((context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Unternehmensregistrierung",
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (!hasPendingCompanyRequest) ... [
          Text("Registriere jetzt dein Unternehmen, um weitere Vorteile der App nutzen zu können.",
            style: responsiveValue.isMobile
                ? themeData.textTheme.bodySmall
                : themeData.textTheme.bodyMedium),
        const SizedBox(height: spacing * 2),
                        Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        title: "Zur Registrierung",
                        width: responsiveValue.isMobile
                            ? maxWidth - spacing
                            : maxWidth / 2 - spacing,
                        disabled: false,
                        onTap: () {
                          Modular.to.navigate(RoutePaths.homePath + RoutePaths.companyRegistration);
                        })
                  ],
                ),
        ] else ... [
                    Text("Deine Anfrage ist in Bearbeitung.\nDie Bearbeitungsdauer liegt bei durchschnittlich 7 Tagen.",
            style: responsiveValue.isMobile
                ? themeData.textTheme.bodySmall
                : themeData.textTheme.bodyMedium), //TODO: Hier auch noch Timestamp von Pending Request anzeigen
        ]
      ]);
    })));
  }
}
