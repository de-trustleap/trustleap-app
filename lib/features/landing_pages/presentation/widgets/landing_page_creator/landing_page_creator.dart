import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_creator_multi_page_form.dart';
import 'package:flutter/material.dart';

class LandingPageCreator extends StatelessWidget {
  final LandingPage? landingPage;
  final bool createDefaultPage;
  const LandingPageCreator(
      {super.key, this.landingPage, this.createDefaultPage = false});

  @override
  Widget build(BuildContext context) {
    return LandingPageCreatorMultiPageForm(
        landingPage: landingPage, createDefaultPage: createDefaultPage);
  }
}
