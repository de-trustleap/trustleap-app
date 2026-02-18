import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/radio_option_tile.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/campaign_recommendation_section.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/personalized_recommendation_section.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_form_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendations_form_scope.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationsForm extends StatefulWidget {
  const RecommendationsForm({super.key});

  @override
  State<RecommendationsForm> createState() => _RecommendationsFormState();
}

class _RecommendationsFormState extends State<RecommendationsForm> {
  final _promoterTextController = TextEditingController();
  final _serviceProviderTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _helper = RecommendationFormHelper();

  RecommendationReason? _selectedReason;
  CustomUser? _currentUser;
  CustomUser? _parentUser;
  bool _validationHasError = false;
  String? _reasonValid;
  bool _promoterTextFieldDisabled = false;
  List<RecommendationReason> _reasons = [];
  RecommendationType _selectedType = RecommendationType.personalized;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  @override
  void dispose() {
    _promoterTextController.dispose();
    _serviceProviderTextController.dispose();
    super.dispose();
  }

  void _initializeUserData() {
    final userState = BlocProvider.of<UserObserverCubit>(context).state;
    if (userState is UserObserverSuccess) {
      _loadRecommendationData(userState.user);
    }
  }

  void _loadRecommendationData(CustomUser user) {
    _setUser(user);
    Modular.get<RecommendationsCubit>()
        .getRecommendationReasons(user.landingPageIDs ?? []);
    if (user.role == Role.promoter && user.parentUserID != null) {
      Modular.get<RecommendationsCubit>().getParentUser(user.parentUserID!);
    }
  }

  void _setUser(CustomUser user) {
    if (user.firstName != null && user.lastName != null) {
      if (user.role == Role.promoter) {
        setState(() {
          _currentUser = user;
          _promoterTextFieldDisabled = true;
          _promoterTextController.text =
              "${_currentUser!.firstName} ${_currentUser!.lastName}";
        });
      } else {
        setState(() {
          _parentUser = user;
          _serviceProviderTextController.text =
              "${_parentUser!.firstName} ${_parentUser!.lastName}";
        });
      }
    }
  }

  void _setParentUser(CustomUser user) {
    _parentUser = user;
    if (_parentUser != null &&
        _parentUser!.firstName != null &&
        _parentUser!.lastName != null) {
      setState(() {
        _serviceProviderTextController.text =
            "${_parentUser!.firstName} ${_parentUser!.lastName}";
      });
    }
  }

  void _resetError() {
    setState(() {});
  }

  String _getReasonValues() {
    _selectedReason = _selectedReason ??
        _reasons.firstWhere(
          (e) => e.isActive == true,
          orElse: () => const RecommendationReason(
            id: null,
            reason: "null",
            isActive: null,
            promotionTemplate: null,
          ),
        );
    return _helper.getReasonValues(_reasons, _selectedReason);
  }

  Widget _buildTypeSection(ThemeData themeData, AppLocalizations localization) {
    final isMobile = ResponsiveHelper.of(context).isMobile;
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            number: 1,
            title: localization.recommendation_section_type_title,
          ),
          const SizedBox(height: 16),
          RadioGroup<RecommendationType>(
            groupValue: _selectedType,
            onChanged: (RecommendationType? value) {
              if (value != null && value != _selectedType) {
                setState(() {
                  _selectedType = value;
                  _validationHasError = false;
                  _reasonValid = null;
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
                    isSelected:
                        _selectedType == RecommendationType.personalized,
                    onTap: () {
                      if (_selectedType != RecommendationType.personalized) {
                        setState(() {
                          _selectedType = RecommendationType.personalized;
                          _validationHasError = false;
                          _reasonValid = null;
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
                    isSelected: _selectedType == RecommendationType.campaign,
                    onTap: () {
                      if (_selectedType != RecommendationType.campaign) {
                        setState(() {
                          _selectedType = RecommendationType.campaign;
                          _validationHasError = false;
                          _reasonValid = null;
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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final recoCubit = Modular.get<RecommendationsCubit>();

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
                _setParentUser(state.user);
              } else if (state is RecommendationGetReasonsSuccessState) {
                setState(() {
                  _reasons = state.reasons;
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
              if (_currentUser != null || _parentUser != null) {
                return RecommendationsFormScope(
                  promoterTextController: _promoterTextController,
                  serviceProviderTextController:
                      _serviceProviderTextController,
                  reasons: _reasons,
                  selectedReason: _selectedReason,
                  currentUser: _currentUser,
                  parentUser: _parentUser,
                  helper: _helper,
                  formKey: _formKey,
                  validationHasError: _validationHasError,
                  reasonValid: _reasonValid,
                  promoterTextFieldDisabled: _promoterTextFieldDisabled,
                  onReasonChanged: (reason) {
                    setState(() {
                      _selectedReason = reason;
                    });
                  },
                  onResetError: _resetError,
                  onReasonValidChanged: (value) {
                    setState(() {
                      _reasonValid = value;
                    });
                  },
                  onValidationHasErrorChanged: (value) {
                    setState(() {
                      _validationHasError = value;
                    });
                  },
                  getReasonValues: _getReasonValues,
                  isRecommendationLimitReached: () =>
                      _helper.isRecommendationLimitReached(_currentUser),
                  hasActiveReasons: () =>
                      _helper.hasActiveReasons(_reasons),
                  getRecommendationLimitResetText: () =>
                      _helper.getRecommendationLimitResetText(
                          context, _currentUser, _parentUser),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _validationHasError
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        _buildTypeSection(themeData, localization),
                        const SizedBox(height: 24),
                        if (_selectedType ==
                            RecommendationType.personalized)
                          const PersonalizedRecommendationSection()
                        else
                          const CampaignRecommendationSection(),
                      ],
                    ),
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
  }
}
