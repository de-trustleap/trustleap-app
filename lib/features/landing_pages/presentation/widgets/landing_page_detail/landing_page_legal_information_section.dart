import 'package:finanzbegleiter/features/landing_pages/application/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_detail/landing_page_detail_legal_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageDetailLegalInformationSection extends StatefulWidget {
  final LandingPage landingPage;

  const LandingPageDetailLegalInformationSection({
    super.key,
    required this.landingPage,
  });

  @override
  State<LandingPageDetailLegalInformationSection> createState() =>
      _LandingPageDetailLegalInformationSectionState();
}

class _LandingPageDetailLegalInformationSectionState
    extends State<LandingPageDetailLegalInformationSection> {
  final LandingPageDetailCubit _cubit = Modular.get<LandingPageDetailCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getArchivedLandingPageLegals(widget.landingPage.id.value);
  }

  bool get _hasAnyLegalContent {
    return (widget.landingPage.privacyPolicy != null &&
            widget.landingPage.privacyPolicy!.isNotEmpty) ||
        (widget.landingPage.impressum != null &&
            widget.landingPage.impressum!.isNotEmpty) ||
        (widget.landingPage.termsAndConditions != null &&
            widget.landingPage.termsAndConditions!.isNotEmpty) ||
        (widget.landingPage.initialInformation != null &&
            widget.landingPage.initialInformation!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    if (!_hasAnyLegalContent) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<LandingPageDetailCubit, LandingPageDetailState>(
      bloc: _cubit,
      builder: (context, state) {
        ArchivedLandingPageLegals? archivedLegals;
        if (state is LandingPageDetailArchivedLegalsSuccess) {
          archivedLegals = state.archivedLegals;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              localization.landing_page_detail_legal_information,
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.landingPage.privacyPolicy != null &&
                widget.landingPage.privacyPolicy!.isNotEmpty) ...[
              LandingPageDetailLegalTile(
                icon: Icons.privacy_tip_outlined,
                title: localization.landing_page_detail_privacy_policy,
                content: widget.landingPage.privacyPolicy!,
                lastUpdated: archivedLegals?.privacyPolicyLastUpdated,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.landingPage.impressum != null &&
                widget.landingPage.impressum!.isNotEmpty) ...[
              LandingPageDetailLegalTile(
                icon: Icons.description_outlined,
                title: localization.landing_page_detail_imprint,
                content: widget.landingPage.impressum!,
                createdAt: widget.landingPage.createdAt,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.landingPage.termsAndConditions != null &&
                widget.landingPage.termsAndConditions!.isNotEmpty) ...[
              LandingPageDetailLegalTile(
                icon: Icons.gavel_outlined,
                title: localization.landing_page_detail_terms_and_conditions,
                content: widget.landingPage.termsAndConditions!,
                lastUpdated: archivedLegals?.termsAndConditionsLastUpdated,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.landingPage.initialInformation != null &&
                widget.landingPage.initialInformation!.isNotEmpty)
              LandingPageDetailLegalTile(
                icon: Icons.info_outlined,
                title: localization.landing_page_detail_initial_information,
                content: widget.landingPage.initialInformation!,
                lastUpdated: archivedLegals?.initialInformationLastUpdated,
              ),
          ],
        );
      },
    );
  }
}
