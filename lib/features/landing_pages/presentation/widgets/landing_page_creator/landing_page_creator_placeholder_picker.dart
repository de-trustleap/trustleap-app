// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_template_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorPlaceholderPicker extends StatefulWidget {
  final Function(String) onSelected;

  const LandingPageCreatorPlaceholderPicker({
    super.key,
    required this.onSelected,
  });

  @override
  State<LandingPageCreatorPlaceholderPicker> createState() =>
      _RecommendationReaseonPickerState();
}

class _RecommendationReaseonPickerState
    extends State<LandingPageCreatorPlaceholderPicker> {
  List<PopupMenuItem<String>> menuItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        menuItems = createDropdownEntries(AppLocalizations.of(context));
      });
    });
  }

  List<PopupMenuItem<String>> createDropdownEntries(
      AppLocalizations localization) {
    List<PopupMenuItem<String>> entries = [
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.providerFirstName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_service_provider_first_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.providerLastName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_service_provider_last_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.providerName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_service_provider_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.promoterFirstName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_promoter_first_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.promoterLastName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_promoter_last_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.promoterName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_promoter_name)),
      PopupMenuItem<String>(
          value: LandingPageTemplatePlaceholder.receiverName,
          child: Text(localization
              .landingpage_create_promotion_placeholder_receiver_name))
    ];
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) {
          return menuItems;
        },
        onSelected: (value) {
          widget.onSelected(value);
        },
        child: Text(localization.landingpage_create_promotion_placeholder_menu,
            style: themeData.textTheme.bodyMedium!.copyWith(
                fontSize: responsiveValue.isMobile ? 14 : 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
