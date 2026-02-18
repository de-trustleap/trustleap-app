import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_preview.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_reason_picker.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_validator.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendations_form_scope.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PersonalizedRecommendationSection extends StatefulWidget {
  const PersonalizedRecommendationSection({super.key});

  @override
  State<PersonalizedRecommendationSection> createState() =>
      _PersonalizedRecommendationSectionState();
}

class _PersonalizedRecommendationSectionState
    extends State<PersonalizedRecommendationSection> {
  final _leadTextController = TextEditingController();
  final _focusNode = FocusNode();

  final List<RecommendationItem> _leads = [];
  bool _showRecommendation = false;

  @override
  void dispose() {
    _leadTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addLead(RecommendationValidator validator) {
    final scope = RecommendationsFormScope.of(context);
    final localization = AppLocalizations.of(context);

    if (_leads.length < 6) {
      if (scope.formKey.currentState!.validate() &&
          validator.validateReason(scope.selectedReason?.reason) == null &&
          scope.selectedReason?.id != null) {
        scope.onValidationHasErrorChanged(false);
        scope.onReasonValidChanged(null);
        setState(() {
          _leads.add(scope.helper.createRecommendationItem(
            leadName: _leadTextController.text,
            promoterName: scope.promoterTextController.text,
            serviceProviderName: scope.serviceProviderTextController.text,
            selectedReason: scope.selectedReason!,
            reasons: scope.reasons,
            currentUser: scope.currentUser,
            parentUser: scope.parentUser,
          ));
          _leadTextController.clear();
          _showRecommendation = true;
        });
      } else {
        scope.onValidationHasErrorChanged(true);
        scope.onReasonValidChanged(
            validator.validateReason(scope.selectedReason?.reason));
      }
    } else {
      CustomSnackBar.of(context).showCustomSnackBar(
          localization.recommendation_page_max_item_Message);
    }
  }

  Widget _buildCustomerNameField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: _leadTextController,
      disabled: false,
      placeholder: localization.recommendation_customer_name_placeholder,
      prefixIcon: Icons.person,
      onChanged: RecommendationsFormScope.of(context).onResetError,
      onFieldSubmitted: () {
        _addLead(RecommendationValidator(
            localization: AppLocalizations.of(context)));
        _focusNode.requestFocus();
      },
      focusNode: _focusNode,
      validator: validator.validateLeadsName,
    );
  }

  Widget _buildLimitInfoBox(ThemeData themeData, AppLocalizations localization) {
    final scope = RecommendationsFormScope.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.recommendations_limit_title,
            style: themeData.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: themeData.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localization.recommendations_limit_description,
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localization.recommendations_limit_status(
              (scope.currentUser ?? scope.parentUser)
                      ?.recommendationCountLast30Days ??
                  0,
              6,
            ),
            style: themeData.textTheme.bodySmall?.copyWith(
              color: ((scope.currentUser ?? scope.parentUser)
                              ?.recommendationCountLast30Days ??
                          0) >=
                      6
                  ? themeData.colorScheme.error
                  : themeData.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (scope.getRecommendationLimitResetText() != null) ...[
            const SizedBox(height: 4),
            Text(
              scope.getRecommendationLimitResetText()!,
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
                if (responsiveValue.isMobile)
                  Column(
                    children: [
                      const PromoterNameField(),
                      const SizedBox(height: 16),
                      _buildCustomerNameField(localization, validator),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildPromoterNameField(
                            scope, localization, validator),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child:
                            _buildCustomerNameField(localization, validator),
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
                  if (scope.currentUser?.role == Role.promoter) ...[
                    const SizedBox(height: 8),
                    _buildLimitInfoBox(themeData, localization),
                  ],
                ],
                const SizedBox(height: 20),
                Center(
                  child: PrimaryButton(
                    title: localization.recommendation_add_button,
                    icon: Icons.add,
                    width: responsiveValue.isMobile ? maxWidth : maxWidth / 2,
                    disabled: scope.isRecommendationLimitReached() ||
                        !scope.hasActiveReasons(),
                    onTap: () => _addLead(validator),
                  ),
                ),
              ],
            ),
          ),
          if (_showRecommendation && _leads.isNotEmpty) ...[
            const SizedBox(height: 24),
            CardContainer(
              maxWidth: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    number: 3,
                    title: localization.recommendation_section_created_title,
                    trailing: Text(
                      localization.recommendation_count(_leads.length),
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: themeData.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecommendationPreview(
                    leads: _leads,
                    userID: scope.currentUser != null
                        ? scope.currentUser?.id.value ?? ""
                        : scope.parentUser?.id.value ?? "",
                    disabled: scope.isRecommendationLimitReached(),
                    onSaveSuccess: (recommendation) {
                      setState(() {
                        _leads.removeWhere(
                            (lead) => lead.id == recommendation.id);
                        if (_leads.isEmpty) {
                          _showRecommendation = false;
                        }
                      });
                      final name = recommendation.displayName;
                      CustomSnackBar.of(context).showCustomSnackBar(
                          localization.recommendations_sent_success(
                              name ?? ""));
                    },
                    onDelete: (lead) {
                      setState(() {
                        _leads.remove(lead);
                        if (_leads.isEmpty) {
                          _showRecommendation = false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}
