import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company_registration/company_registration_form.dart';
import 'package:flutter/material.dart';

class CompanyRegistrationPage extends StatelessWidget {
  const CompanyRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: themeData.colorScheme.surface),
        child: ListView(children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          const CenteredConstrainedWrapper(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [CompanyRegistrationForm()]))
        ]));
  }
}
