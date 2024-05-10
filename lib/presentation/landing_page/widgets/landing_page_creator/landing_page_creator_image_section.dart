// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:flutter/material.dart';

class LandingPageCreatorImageSection extends StatefulWidget {
  final LandingPage? landingPage;
  final Function imageUploadSuccessful;

  const LandingPageCreatorImageSection({
    super.key,
    this.landingPage,
    required this.imageUploadSuccessful,
  });

  @override
  State<LandingPageCreatorImageSection> createState() =>
      _LandingPageCreatorImageSectionState();
}

class _LandingPageCreatorImageSectionState
    extends State<LandingPageCreatorImageSection> {
  final GlobalKey<_LandingPageCreatorImageSectionState> myWidgetKey =
      GlobalKey();
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
