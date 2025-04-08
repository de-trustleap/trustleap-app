import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_icon.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/landingpage_checkbox_item.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoter_no_landingpage_view.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterEditForm extends StatefulWidget {
  final String promoterID;
  const PromoterEditForm({super.key, required this.promoterID});

  @override
  State<PromoterEditForm> createState() => _PromoterEditFormState();
}

class _PromoterEditFormState extends State<PromoterEditForm> {
  List<LandingPageCheckboxItem> landingPageItems = [];
  CustomUser? currentUser;
  Promoter? promoter;
  bool buttonDisabled = false;

  @override
  void initState() {
    Modular.get<PromoterCubit>().getCurrentUser();
    super.initState();
  }

  void submit() {
    if (currentUser != null &&
        landingPageItems.isNotEmpty &&
        promoter?.registered != null) {
      Modular.get<PromoterCubit>().editPromoter(promoter!.registered!,
          getSelectedLandingPagesIDs(), promoter!.id.value);
    }
  }

  List<String> getSelectedLandingPagesIDs() {
    return landingPageItems
        .map((e) {
          if (e.isSelected) {
            return e.landingPage.id.value;
          }
        })
        .whereType<String>()
        .toList();
  }

  List<Widget> createCheckboxes(AppLocalizations localization) {
    List<Widget> checkboxes = [];
    landingPageItems.sort((a, b) =>
        (a.landingPage.name ?? "").compareTo(b.landingPage.name ?? ""));
    landingPageItems.asMap().forEach((index, _) {
      checkboxes.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Checkbox(
            value: landingPageItems[index].isSelected,
            onChanged: ((value) {
              if (value != null) {
                setState(() {
                  landingPageItems[index].isSelected = value;
                  if (getSelectedLandingPagesIDs().isEmpty) {
                    buttonDisabled = true;
                  } else {
                    buttonDisabled = false;
                  }
                });
              }
            })),
        const SizedBox(width: 12),
        SelectableText(landingPageItems[index].landingPage.name ?? ""),
        if ((landingPageItems[index].landingPage.isActive != null &&
                !landingPageItems[index].landingPage.isActive!) ||
            landingPageItems[index].landingPage.isActive == null) ...[
          TooltipIcon(
              icon: Icons.warning,
              text: localization.edit_promoter_inactive_landingpage_tooltip,
              buttonText: localization
                  .edit_promoter_inactive_landingpage_tooltip_activate_action,
              onPressed: () => {
                    Modular.get<LandingPageCubit>().toggleLandingPageActivity(
                        landingPageItems[index].landingPage.id.value,
                        true,
                        currentUser?.id.value ?? "")
                  })
        ]
      ]));
    });
    return checkboxes;
  }

  @override
  Widget build(BuildContext context) {
    final promoterCubit = Modular.get<PromoterCubit>();
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const spacing = 20.0;
    return MultiBlocListener(
        listeners: [
          BlocListener<PromoterCubit, PromoterState>(
              bloc: promoterCubit,
              listener: (context, state) {
                if (state is PromoterGetCurrentUserSuccessState) {
                  currentUser = state.user;
                  Modular.get<PromoterCubit>().getPromoter(widget.promoterID);
                } else if (state is PromoterGetLandingPagesSuccessState) {
                  setState(() {
                    landingPageItems.clear();
                    for (var landingPage in state.landingPages) {
                      landingPageItems.add(LandingPageCheckboxItem(
                          landingPage: landingPage,
                          isSelected: landingPage.associatedUsersIDs
                                  ?.contains(widget.promoterID) ??
                              false));
                    }
                  });
                } else if (state is PromoterGetSuccessState) {
                  setState(() {
                    promoter = state.promoter;
                  });
                  Modular.get<PromoterCubit>().getPromotingLandingPages(
                      currentUser?.landingPageIDs ?? []);
                } else if (state is PromoterEditSuccessState) {
                  const params = "?editedPromoter=true";
                  CustomNavigator.pushAndReplace(
                      RoutePaths.homePath + RoutePaths.promotersPath, params);
                }
              }),
          BlocListener<LandingPageCubit, LandingPageState>(
              bloc: landingPageCubit,
              listener: (context, state) {
                if (state is ToggleLandingPageActivitySuccessState) {
                  CustomSnackBar.of(context).showCustomSnackBar(localization
                      .landingpage_snackbar_success_toggled_enabled);
                  Modular.get<PromoterCubit>().getPromotingLandingPages(
                      currentUser?.landingPageIDs ?? []);
                }
              })
        ],
        child: BlocBuilder<PromoterCubit, PromoterState>(
            bloc: promoterCubit,
            builder: (context, promoterState) {
              return BlocBuilder<LandingPageCubit, LandingPageState>(
                bloc: landingPageCubit,
                builder: (context, landingPageState) {
                  return CardContainer(
                      child: LayoutBuilder(builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    if (promoterState is PromoterLoadingState ||
                        landingPageState
                            is ToggleLandingPageActivityLoadingState) {
                      return const LoadingIndicator();
                    } else if (promoterState
                        is PromoterGetCurrentUserFailureState) {
                      return ErrorView(
                          title: localization
                              .landingpage_overview_error_view_title,
                          message: DatabaseFailureMapper.mapFailureMessage(
                              promoterState.failure, localization),
                          callback: () =>
                              {Modular.get<PromoterCubit>().getCurrentUser()});
                    } else if (promoterState
                        is PromoterGetLandingPagesFailureState) {
                      return ErrorView(
                          title: localization
                              .landingpage_overview_error_view_title,
                          message: DatabaseFailureMapper.mapFailureMessage(
                              promoterState.failure, localization),
                          callback: () => {
                                Modular.get<PromoterCubit>()
                                    .getPromotingLandingPages(
                                        currentUser?.landingPageIDs ?? [])
                              });
                    } else if (promoterState is PromoterNoLandingPagesState) {
                      return const RegisterPromoterNoLandingPageView();
                    } else {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                                localization.edit_promoter_title(
                                    promoter?.firstName ?? "",
                                    promoter?.lastName ?? ""),
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: spacing),
                            SelectableText(localization.edit_promoter_subtitle,
                                style: themeData.textTheme.bodyMedium),
                            const SizedBox(height: spacing + 4),
                            Column(children: createCheckboxes(localization)),
                            const SizedBox(height: spacing * 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryButton(
                                    title: localization
                                        .edit_promoter_save_button_title,
                                    width: responsiveValue.isMobile
                                        ? maxWidth - spacing
                                        : maxWidth / 2 - spacing,
                                    disabled: buttonDisabled,
                                    isLoading: promoterState
                                        is PromoterRegisterLoadingState,
                                    onTap: () {
                                      submit();
                                    })
                              ],
                            ),
                            if (promoterState is PromoterEditFailureState) ...[
                              const SizedBox(height: 20),
                              FormErrorView(
                                  message:
                                      DatabaseFailureMapper.mapFailureMessage(
                                          promoterState.failure, localization))
                            ],
                            if (landingPageState
                                is ToggleLandingPageActivityFailureState) ...[
                              const SizedBox(height: 20),
                              FormErrorView(
                                  message:
                                      DatabaseFailureMapper.mapFailureMessage(
                                          landingPageState.failure,
                                          localization))
                            ]
                          ]);
                    }
                  }));
                },
              );
            }));
  }
}
