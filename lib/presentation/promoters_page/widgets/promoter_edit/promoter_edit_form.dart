import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/landingpage_checkbox_item.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoter_no_landingpage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterEditForm extends StatefulWidget {
  final Promoter promoter;
  final Function changesSaved;
  const PromoterEditForm(
      {super.key, required this.promoter, required this.changesSaved});

  @override
  State<PromoterEditForm> createState() => _PromoterEditFormState();
}

class _PromoterEditFormState extends State<PromoterEditForm> {
  List<LandingPageCheckboxItem> landingPageItems = [];
  CustomUser? currentUser;
  bool buttonDisabled = false;

  @override
  void initState() {
    Modular.get<PromoterCubit>().getCurrentUser();
    super.initState();
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

  List<Widget> createCheckboxes() {
    List<Widget> checkboxes = [];
    landingPageItems.asMap().forEach((index, _) {
      checkboxes.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Checkbox(
            value: landingPageItems[index].isSelected,
            onChanged: ((value) {
              if (value != null) {
                setState(() {
                  landingPageItems[index].isSelected = value;
                });
              }
            })),
        const SizedBox(width: 8),
        SelectableText(landingPageItems[index].landingPage.name ?? "")
      ]));
    });
    return checkboxes;
  }

  @override
  Widget build(BuildContext context) {
    final promoterCubit = Modular.get<PromoterCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const spacing = 20;

    return BlocConsumer<PromoterCubit, PromoterState>(
        bloc: promoterCubit,
        listener: (context, state) {
          if (state is PromoterGetCurrentUserSuccessState) {
            currentUser = state.user;
            Modular.get<PromoterCubit>()
                .getPromotingLandingPages(currentUser?.landingPageIDs ?? []);
          } else if (state is PromoterGetLandingPagesSuccessState) {
            setState(() {
              for (var landingPage in state.landingPages) {
                landingPageItems.add(LandingPageCheckboxItem(
                    landingPage: landingPage, isSelected: false));
              }
            });
          }
        },
        builder: (context, state) {
          return CardContainer(
              child: LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            if (state is PromoterLoadingState) {
              return const LoadingIndicator();
            } else if (state is PromoterGetCurrentUserFailureState) {
              return ErrorView(
                  title: localization.landingpage_overview_error_view_title,
                  message: DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization),
                  callback: () =>
                      {Modular.get<PromoterCubit>().getCurrentUser()});
            } else if (state is PromoterGetLandingPagesFailureState) {
              return ErrorView(
                  title: localization.landingpage_overview_error_view_title,
                  message: DatabaseFailureMapper.mapFailureMessage(
                      state.failure, localization),
                  callback: () => {
                        Modular.get<PromoterCubit>().getPromotingLandingPages(
                            currentUser?.landingPageIDs ?? [])
                      });
            } else if (state is PromoterNoLandingPagesState) {
              return const RegisterPromoterNoLandingPageView();
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText("Promoter bearbeiten",
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: spacing + 4),
                    Column(children: createCheckboxes()),
                    const SizedBox(height: spacing * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrimaryButton(
                            title:
                                localization.register_promoter_register_button,
                            width: responsiveValue.isMobile
                                ? maxWidth - spacing
                                : maxWidth / 2 - spacing,
                            disabled: buttonDisabled,
                            isLoading: state is PromoterRegisterLoadingState,
                            onTap: () {
                              // submit(validator);
                            })
                      ],
                    ),
                  ]);
            }
          }));
        });
  }
}
// TODO: Landingpages Checkboxes und Speichern Button einfügen (FERTIG)
// TODO: Edit Button mit neuer URL zu neuer Page führen (FERTIG)
// TODO: Die Checkboxen werden nicht angezeigt. Beheben!
// TODO: Backend Funktion erstellen. Abschauen bei registerPromoter
// TODO: Backend Funktion Tests schreiben
// TODO: Edit Promoter Cubit Function einfügen
// TODO: Edit Promoter Repo Call einfügen
// TODO: Bloc in Seite einbinden und auf Fehler etc reagieren
// TODO: Snackbar in Overview anzeigen
// TODO: Localizations
// TODO: Tests schreiben