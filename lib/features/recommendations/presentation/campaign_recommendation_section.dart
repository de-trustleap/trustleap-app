import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_reason_picker.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_sender.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_validator.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendations_form_scope.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CampaignRecommendationSection extends StatefulWidget {
  const CampaignRecommendationSection({super.key});

  @override
  State<CampaignRecommendationSection> createState() =>
      _CampaignRecommendationSectionState();
}

class _CampaignRecommendationSectionState
    extends State<CampaignRecommendationSection> {
  final _campaignNameController = TextEditingController();
  final _campaignDurationController = TextEditingController();
  final _campaignLinkController = TextEditingController();

  RecommendationItem? _campaignItem;
  bool _showLinkPreview = false;

  @override
  void dispose() {
    _campaignNameController.dispose();
    _campaignDurationController.dispose();
    _campaignLinkController.dispose();
    super.dispose();
  }

  void _generateCampaignLink(RecommendationValidator validator) {
    final scope = RecommendationsFormScope.of(context);

    if (scope.formKey.currentState!.validate() &&
        validator.validateReason(scope.selectedReason?.reason) == null &&
        scope.selectedReason?.id != null) {
      scope.onValidationHasErrorChanged(false);
      scope.onReasonValidChanged(null);

      final duration = int.parse(_campaignDurationController.text);
      final item = scope.helper.createCampaignRecommendationItem(
        campaignName: _campaignNameController.text,
        campaignDurationDays: duration,
        promoterName: scope.promoterTextController.text,
        serviceProviderName: scope.serviceProviderTextController.text,
        selectedReason: scope.selectedReason!,
        reasons: scope.reasons,
        currentUser: scope.currentUser,
        parentUser: scope.parentUser,
      );

      final sender = RecommendationSender();
      final link = sender.createRecommendationLink(item);
      final parsed =
          scope.helper.parseTemplate(item, item.promotionTemplate ?? "");
      final text = parsed.replaceAll("[LINK]", link);

      setState(() {
        _campaignItem = item;
        _campaignLinkController.text = text;
        _showLinkPreview = true;
      });
    } else {
      scope.onValidationHasErrorChanged(true);
      scope.onReasonValidChanged(
          validator.validateReason(scope.selectedReason?.reason));
    }
  }

  Widget _buildCampaignNameField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: _campaignNameController,
      disabled: false,
      placeholder: localization.recommendation_campaign_name_placeholder,
      prefixIcon: Icons.campaign,
      onChanged: RecommendationsFormScope.of(context).onResetError,
      validator: validator.validateCampaignName,
    );
  }

  Widget _buildCampaignDurationField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: _campaignDurationController,
      disabled: false,
      placeholder: localization.recommendation_campaign_duration_placeholder,
      prefixIcon: Icons.timer,
      onChanged: RecommendationsFormScope.of(context).onResetError,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator.validateCampaignDuration,
    );
  }

  Widget _buildCampaignLinkPreview(
    ThemeData themeData,
    AppLocalizations localization,
    double maxWidth,
  ) {
    final scope = RecommendationsFormScope.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            number: 3,
            title: localization.recommendation_campaign_link_title,
          ),
          const SizedBox(height: 16),
          FormTextfield(
            controller: _campaignLinkController,
            disabled: false,
            placeholder: '',
            minLines: 6,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          Center(
            child: PrimaryButton(
              title: localization.recommendation_copy_template_button,
              icon: Icons.copy,
              width: responsiveValue.isMobile ? maxWidth : maxWidth / 2,
              onTap: () {
              Clipboard.setData(
                  ClipboardData(text: _campaignLinkController.text));
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_copied_to_clipboard);
              showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                  title: localization
                      .recommendation_campaign_shared_alert_title,
                  message: localization
                      .recommendation_campaign_shared_alert_description,
                  actionButtonTitle: localization
                      .recommendation_campaign_shared_alert_yes_button,
                  cancelButtonTitle: localization
                      .recommendation_campaign_shared_alert_no_button,
                  actionButtonAction: () {
                    CustomNavigator.of(context).pop();
                    if (_campaignItem != null) {
                      final userID = scope.currentUser?.id.value ??
                          scope.parentUser?.id.value ??
                          "";
                      Modular.get<RecommendationsAlertCubit>()
                          .saveRecommendation(_campaignItem!, userID);
                    }
                  },
                  cancelButtonAction: () {
                    CustomNavigator.of(context).pop();
                  },
                ),
              );
            },
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = RecommendationsFormScope.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = RecommendationValidator(localization: localization);
    final responsiveValue = ResponsiveHelper.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Column(
        children: [
          CardContainer(
            maxWidth: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  number: 2,
                  title: localization.recommendation_section_create_title,
                ),
                const SizedBox(height: 16),
                const PromoterNameField(),
                const SizedBox(height: 16),
                if (responsiveValue.isMobile)
                  Column(
                    children: [
                      _buildCampaignNameField(localization, validator),
                      const SizedBox(height: 16),
                      _buildCampaignDurationField(localization, validator),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                            _buildCampaignNameField(localization, validator),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCampaignDurationField(
                            localization, validator),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (!scope.hasActiveReasons()) ...[
                  FormErrorView(
                    message: localization
                        .recommendations_no_active_landingpage_warning,
                  ),
                  const SizedBox(height: 16),
                ],
                if (scope.reasons.isNotEmpty) ...[
                  RecommendationReasonPicker(
                    width: maxWidth,
                    validate: scope.reasonValid,
                    reasons: scope.reasons,
                    initialValue: scope.getReasonValues(),
                    onSelected: (reason) {
                      scope.onReasonValidChanged(
                          validator.validateReason(reason?.reason));
                      scope.onReasonChanged(reason);
                      scope.onResetError();
                    },
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: PrimaryButton(
                    title: localization.recommendation_generate_link_button,
                    icon: Icons.link,
                    width: responsiveValue.isMobile ? maxWidth : maxWidth / 2,
                    disabled: !scope.hasActiveReasons(),
                    onTap: () => _generateCampaignLink(validator),
                  ),
                ),
              ],
            ),
          ),
          if (_showLinkPreview) ...[
            const SizedBox(height: 24),
            _buildCampaignLinkPreview(themeData, localization, maxWidth),
          ],
        ],
      );
    });
  }
}
