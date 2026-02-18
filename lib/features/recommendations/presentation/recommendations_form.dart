import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/radio_option_tile.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_form_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_preview.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_reason_picker.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_sender.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_validator.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationsForm extends StatefulWidget {
  const RecommendationsForm({super.key});

  @override
  State<RecommendationsForm> createState() => _RecommendationsFormState();
}

class _RecommendationsFormState extends State<RecommendationsForm> {
  final promoterTextController = TextEditingController();
  final leadTextController = TextEditingController();
  final serviceProviderTextController = TextEditingController();
  final campaignLinkController = TextEditingController();
  final campaignNameController = TextEditingController();
  final campaignDurationController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showRecommendation = false;
  RecommendationReason? selectedReason;
  FocusNode? focusNode;
  CustomUser? currentUser;
  CustomUser? parentUser;

  List<RecommendationItem> leads = [];

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? reasonValid;
  bool promoterTextFieldDisabled = false;
  List<RecommendationReason> reasons = [];
  final helper = RecommendationFormHelper();
  RecommendationType selectedType = RecommendationType.personalized;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final userState = BlocProvider.of<UserObserverCubit>(context).state;
    if (userState is UserObserverSuccess) {
      _loadRecommendationData(userState.user);
    }
  }

  void _loadRecommendationData(CustomUser user) {
    setUser(user);
    Modular.get<RecommendationsCubit>()
        .getRecommendationReasons(user.landingPageIDs ?? []);
    if (user.role == Role.promoter && user.parentUserID != null) {
      Modular.get<RecommendationsCubit>().getParentUser(user.parentUserID!);
    }
  }

  @override
  void dispose() {
    promoterTextController.dispose();
    leadTextController.dispose();
    serviceProviderTextController.dispose();
    campaignLinkController.dispose();
    campaignNameController.dispose();
    campaignDurationController.dispose();
    focusNode!.dispose();
    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void addLead(RecommendationValidator validator) {
    final localization = AppLocalizations.of(context);
    if (leads.length < 6) {
      if (formKey.currentState!.validate() &&
          validator.validateReason(selectedReason?.reason) == null &&
          selectedReason?.id != null) {
        setState(() {
          validationHasError = false;
          reasonValid = null;
          leads.add(helper.createRecommendationItem(
            leadName: leadTextController.text,
            promoterName: promoterTextController.text,
            serviceProviderName: serviceProviderTextController.text,
            selectedReason: selectedReason!,
            reasons: reasons,
            currentUser: currentUser,
            parentUser: parentUser,
          ));
          leadTextController.clear();
          generateRecommendation();
        });
      } else {
        setState(() {
          validationHasError = true;
          reasonValid = validator.validateReason(selectedReason?.reason);
        });
      }
    } else {
      CustomSnackBar.of(context).showCustomSnackBar(
          localization.recommendation_page_max_item_Message);
    }
  }

  void setUser(CustomUser user) {
    if (user.firstName != null && user.lastName != null) {
      if (user.role == Role.promoter) {
        setState(() {
          currentUser = user;
          promoterTextFieldDisabled = true;
          promoterTextController.text =
              "${currentUser!.firstName} ${currentUser!.lastName}";
        });
      } else {
        setState(() {
          parentUser = user;
          serviceProviderTextController.text =
              "${parentUser!.firstName} ${parentUser!.lastName}";
        });
      }
    }
  }

  void setParentUser(CustomUser user) {
    parentUser = user;
    if (parentUser != null &&
        parentUser!.firstName != null &&
        parentUser!.lastName != null) {
      setState(() {
        serviceProviderTextController.text =
            "${parentUser!.firstName} ${parentUser!.lastName}";
      });
    }
  }

  String getReasonValues() {
    selectedReason = selectedReason ??
        reasons.firstWhere(
          (e) => e.isActive == true,
          orElse: () => const RecommendationReason(
            id: null,
            reason: "null",
            isActive: null,
            promotionTemplate: null,
          ),
        );
    return helper.getReasonValues(reasons, selectedReason);
  }

  void generateRecommendation() {
    setState(() {
      showRecommendation = true;
    });
  }

  bool isRecommendationLimitReached() {
    return helper.isRecommendationLimitReached(currentUser);
  }

  bool hasActiveReasons() {
    return helper.hasActiveReasons(reasons);
  }

  String? getRecommendationLimitResetText() {
    return helper.getRecommendationLimitResetText(
        context, currentUser, parentUser);
  }

  Widget _buildSectionHeader(
    ThemeData themeData,
    int number,
    String title, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing],
      ],
    );
  }

  Widget _buildTypeSection(ThemeData themeData, AppLocalizations localization) {
    final isMobile = ResponsiveHelper.of(context).isMobile;
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            themeData,
            1,
            localization.recommendation_section_type_title,
          ),
          const SizedBox(height: 16),
          RadioGroup<RecommendationType>(
            groupValue: selectedType,
            onChanged: (RecommendationType? value) {
              if (value != null && value != selectedType) {
                setState(() {
                  selectedType = value;
                  leads.clear();
                  campaignLinkController.clear();
                  campaignNameController.clear();
                  campaignDurationController.clear();
                  showRecommendation = false;
                  validationHasError = false;
                  reasonValid = null;
                });
              }
            },
            child: ResponsiveRowColumn(
              layout: isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowSpacing: 12,
              columnSpacing: 12,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: RadioOptionTile<RecommendationType>(
                    icon: Icons.people,
                    label: localization.recommendation_type_personalized,
                    description:
                        localization.recommendation_type_personalized_desc,
                    value: RecommendationType.personalized,
                    isSelected: selectedType == RecommendationType.personalized,
                    onTap: () {
                      if (selectedType != RecommendationType.personalized) {
                        setState(() {
                          selectedType = RecommendationType.personalized;
                          leads.clear();
                          campaignLinkController.clear();
                          campaignNameController.clear();
                          campaignDurationController.clear();
                          showRecommendation = false;
                          validationHasError = false;
                          reasonValid = null;
                        });
                      }
                    },
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: RadioOptionTile<RecommendationType>(
                    icon: Icons.campaign,
                    label: localization.recommendation_type_campaign,
                    description: localization.recommendation_type_campaign_desc,
                    value: RecommendationType.campaign,
                    isSelected: selectedType == RecommendationType.campaign,
                    onTap: () {
                      if (selectedType != RecommendationType.campaign) {
                        setState(() {
                          selectedType = RecommendationType.campaign;
                          leads.clear();
                          campaignLinkController.clear();
                          campaignNameController.clear();
                          campaignDurationController.clear();
                          showRecommendation = false;
                          validationHasError = false;
                          reasonValid = null;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateSection(
    ThemeData themeData,
    AppLocalizations localization,
    RecommendationValidator validator,
    double maxWidth,
  ) {
    final responsiveValue = ResponsiveHelper.of(context);
    final isPersonalized = selectedType == RecommendationType.personalized;
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            themeData,
            2,
            localization.recommendation_section_create_title,
          ),
          const SizedBox(height: 16),
          if (isPersonalized) ...[
            if (responsiveValue.isMobile)
              Column(
                children: [
                  _buildPromoterNameField(localization, validator),
                  const SizedBox(height: 16),
                  _buildCustomerNameField(localization, validator),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPromoterNameField(localization, validator),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCustomerNameField(localization, validator),
                  ),
                ],
              ),
          ] else ...[
            if (responsiveValue.isMobile)
              Column(
                children: [
                  _buildPromoterNameField(localization, validator),
                  const SizedBox(height: 16),
                  _buildCampaignNameField(localization, validator),
                  const SizedBox(height: 16),
                  _buildCampaignDurationField(localization, validator),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildPromoterNameField(localization, validator),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCampaignNameField(localization, validator),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCampaignDurationField(
                            localization, validator),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
          ],
          const SizedBox(height: 16),
          if (!hasActiveReasons()) ...[
            FormErrorView(
              message:
                  localization.recommendations_no_active_landingpage_warning,
            ),
            const SizedBox(height: 16),
          ],
          if (reasons.isNotEmpty) ...[
            RecommendationReasonPicker(
              width: maxWidth,
              validate: reasonValid,
              reasons: reasons,
              initialValue: getReasonValues(),
              onSelected: (reason) {
                setState(() {
                  reasonValid = validator.validateReason(reason?.reason);
                  selectedReason = reason;
                });
                resetError();
              },
            ),
            if (isPersonalized && currentUser?.role == Role.promoter) ...[
              const SizedBox(height: 8),
              _buildLimitInfoBox(themeData, localization),
            ],
          ],
          const SizedBox(height: 20),
          Center(
            child: PrimaryButton(
              title: isPersonalized
                  ? localization.recommendation_add_button
                  : localization.recommendation_generate_link_button,
              icon: isPersonalized ? Icons.add : Icons.link,
              width: responsiveValue.isMobile ? maxWidth : maxWidth / 2,
              disabled: isPersonalized
                  ? (isRecommendationLimitReached() || !hasActiveReasons())
                  : !hasActiveReasons(),
              onTap: isPersonalized
                  ? () => addLead(validator)
                  : () => _generateCampaignLink(validator),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoterNameField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: promoterTextController,
      disabled: promoterTextFieldDisabled,
      placeholder: localization.recommendation_promoter_name_placeholder,
      prefixIcon: Icons.person,
      onChanged: resetError,
      validator: validator.validatePromotersName,
    );
  }

  Widget _buildCustomerNameField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: leadTextController,
      disabled: false,
      placeholder: localization.recommendation_customer_name_placeholder,
      prefixIcon: Icons.person,
      onChanged: resetError,
      onFieldSubmitted: () {
        addLead(RecommendationValidator(
            localization: AppLocalizations.of(context)));
        focusNode!.requestFocus();
      },
      focusNode: focusNode,
      validator: validator.validateLeadsName,
    );
  }

  Widget _buildCampaignNameField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: campaignNameController,
      disabled: false,
      placeholder: localization.recommendation_campaign_name_placeholder,
      prefixIcon: Icons.campaign,
      onChanged: resetError,
      validator: validator.validateCampaignName,
    );
  }

  Widget _buildCampaignDurationField(
    AppLocalizations localization,
    RecommendationValidator validator,
  ) {
    return FormTextfield(
      controller: campaignDurationController,
      disabled: false,
      placeholder: localization.recommendation_campaign_duration_placeholder,
      prefixIcon: Icons.timer,
      onChanged: resetError,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator.validateCampaignDuration,
    );
  }

  Widget _buildLimitInfoBox(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
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
              (currentUser ?? parentUser)?.recommendationCountLast30Days ?? 0,
              6,
            ),
            style: themeData.textTheme.bodySmall?.copyWith(
              color:
                  ((currentUser ?? parentUser)?.recommendationCountLast30Days ??
                              0) >=
                          6
                      ? themeData.colorScheme.error
                      : themeData.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (getRecommendationLimitResetText() != null) ...[
            const SizedBox(height: 4),
            Text(
              getRecommendationLimitResetText()!,
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

  void _generateCampaignLink(RecommendationValidator validator) {
    if (formKey.currentState!.validate() &&
        validator.validateReason(selectedReason?.reason) == null &&
        selectedReason?.id != null) {
      setState(() {
        validationHasError = false;
        reasonValid = null;
      });

      final duration = int.parse(campaignDurationController.text);
      final item = helper.createCampaignRecommendationItem(
        campaignName: campaignNameController.text,
        campaignDurationDays: duration,
        promoterName: promoterTextController.text,
        serviceProviderName: serviceProviderTextController.text,
        selectedReason: selectedReason!,
        reasons: reasons,
        currentUser: currentUser,
        parentUser: parentUser,
      );

      final sender = RecommendationSender();
      final link = sender.createRecommendationLink(item);
      final template = item.promotionTemplate ?? '';
      final text = template.replaceAll('[LINK]', link);

      setState(() {
        campaignLinkController.text = text;
        showRecommendation = true;
      });
    } else {
      setState(() {
        validationHasError = true;
        reasonValid = validator.validateReason(selectedReason?.reason);
      });
    }
  }

  Widget _buildCampaignLinkPreview(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            themeData,
            3,
            localization.recommendation_campaign_link_title,
          ),
          const SizedBox(height: 16),
          FormTextfield(
            controller: campaignLinkController,
            disabled: false,
            placeholder: '',
            minLines: 6,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 8),
          SubtleButton(
            title: localization.recommendation_copy_template_button,
            icon: Icons.copy,
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: campaignLinkController.text));
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_copied_to_clipboard);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedSection(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            themeData,
            3,
            localization.recommendation_section_created_title,
            trailing: Text(
              localization.recommendation_count(leads.length),
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          RecommendationPreview(
            leads: leads,
            userID: currentUser != null
                ? currentUser?.id.value ?? ""
                : parentUser?.id.value ?? "",
            disabled: isRecommendationLimitReached(),
            onSaveSuccess: (recommendation) {
              setState(() {
                leads.removeWhere((lead) => lead.id == recommendation.id);
                if (leads.isEmpty) {
                  showRecommendation = false;
                }
              });
              final name = recommendation.displayName;
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendations_sent_success(name ?? ""));
            },
            onDelete: (lead) {
              setState(() {
                leads.remove(lead);
                if (leads.isEmpty) {
                  showRecommendation = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final recoCubit = Modular.get<RecommendationsCubit>();
    final validator = RecommendationValidator(localization: localization);

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocListener<UserObserverCubit, UserObserverState>(
        listener: (context, state) {
          if (state is UserObserverSuccess) {
            _loadRecommendationData(state.user);
          }
        },
        child: BlocBuilder<UserObserverCubit, UserObserverState>(
          builder: (context, userState) {
            if (userState is UserObserverLoading ||
                userState is UserObserverInitial) {
              return const LoadingIndicator();
            }
            return BlocConsumer<RecommendationsCubit, RecommendationsState>(
              bloc: recoCubit,
              listener: (context, state) {
                if (state is RecommendationGetParentUserSuccessState) {
                  setParentUser(state.user);
                } else if (state is RecommendationGetReasonsSuccessState) {
                  setState(() {
                    reasons = state.reasons;
                  });
                }
              },
              builder: (context, state) {
                if (state is RecommendationsInitial ||
                    state is RecommendationLoadingState) {
                  return const LoadingIndicator();
                }
                if (state is RecommendationNoReasonsState) {
                  return EmptyPage(
                      icon: Icons.person_add,
                      title:
                          localization.recommendation_missing_landingpage_title,
                      subTitle:
                          localization.recommendation_missing_landingpage_text,
                      buttonTitle: localization
                          .recommendation_missing_landingpage_button,
                      onTap: () {
                        navigator.navigate(
                            RoutePaths.homePath + RoutePaths.landingPagePath);
                      });
                }
                if (currentUser != null || parentUser != null) {
                  return Form(
                    key: formKey,
                    autovalidateMode: validationHasError
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        _buildTypeSection(themeData, localization),
                        const SizedBox(height: 24),
                        _buildCreateSection(
                          themeData,
                          localization,
                          validator,
                          maxWidth,
                        ),
                        if (showRecommendation) ...[
                          if (selectedType == RecommendationType.personalized &&
                              leads.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildCreatedSection(themeData, localization),
                          ],
                          if (selectedType == RecommendationType.campaign) ...[
                            const SizedBox(height: 24),
                            _buildCampaignLinkPreview(themeData, localization),
                          ],
                        ],
                      ],
                    ),
                  );
                } else if (state is RecommendationGetUserFailureState) {
                  return CenteredConstrainedWrapper(
                      child: ErrorView(
                          title: localization.recommendations_error_view_title,
                          message: DatabaseFailureMapper.mapFailureMessage(
                              state.failure, localization),
                          callback: _initializeUserData));
                } else {
                  return const LoadingIndicator();
                }
              },
            );
          },
        ),
      );
    });
  }
}
