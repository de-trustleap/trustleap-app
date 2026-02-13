import 'dart:typed_data';

import 'package:finanzbegleiter/features/landing_pages/application/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_ai_generation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_ai_generator_form.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_creator_fourth_step_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorFourthStep extends StatefulWidget {
  final LandingPage? landingPage;
  final Uint8List? image;
  final bool imageHasChanged;
  final bool buttonsDisabled;
  final bool isLoading;
  final Function(LandingPage) onBack;
  final Function(LandingPage, Uint8List?, bool, String) onSaveTapped;
  final Function(LandingPage, Uint8List?, bool, PagebuilderAiGeneration)?
      onAISaveTapped;
  const LandingPageCreatorFourthStep(
      {super.key,
      required this.landingPage,
      required this.image,
      required this.imageHasChanged,
      required this.buttonsDisabled,
      required this.isLoading,
      required this.onBack,
      required this.onSaveTapped,
      this.onAISaveTapped});

  @override
  State<LandingPageCreatorFourthStep> createState() =>
      _LandingPageCreatorFourthStepState();
}

class _LandingPageCreatorFourthStepState
    extends State<LandingPageCreatorFourthStep> {
  int? selectedTemplateIndex;
  bool isAIGeneratorSelected = false;
  late List<LandingPageTemplate> templates;
  PagebuilderAiGeneration? _aiData;

  @override
  void initState() {
    Modular.get<LandingPageCubit>().getAllLandingPageTemplates();
    templates = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return BlocConsumer<LandingPageCubit, LandingPageState>(
      bloc: landingPageCubit,
      listener: (context, state) {
        if (state is GetLandingPageTemplatesSuccessState) {
          setState(() {
            templates = state.templates;
          });
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              CenteredConstrainedWrapper(
              child: CardContainer(
                  maxWidth: 800,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    return Column(children: [
                      SelectableText(
                          localization.landingpage_creator_select_template_title,
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      if (state is GetLandingPageTemplatesLoadingState) ...[
                        const LoadingIndicator()
                      ] else if (templates.isNotEmpty) ...[
                        LandingPageCreatorFourthStepGrid(
                            landingpageTemplates: templates,
                            selectedIndex: selectedTemplateIndex,
                            isAIGeneratorSelected: isAIGeneratorSelected,
                            disabled: false,
                            onSelectIndex: (index) {
                              setState(() {
                                if (selectedTemplateIndex == index) {
                                  selectedTemplateIndex = null;
                                } else {
                                  selectedTemplateIndex = index;
                                  isAIGeneratorSelected = false;
                                  _aiData = null;
                                }
                              });
                            },
                            onAIGeneratorTap: () {
                              setState(() {
                                if (isAIGeneratorSelected) {
                                  isAIGeneratorSelected = false;
                                  _aiData = null;
                                } else {
                                  isAIGeneratorSelected = true;
                                  selectedTemplateIndex = null;
                                }
                              });
                            }),
                      ],
                      if (isAIGeneratorSelected) ...[
                        const SizedBox(height: 48),
                        SelectableText(
                          localization.landingpage_creator_ai_form_section_title,
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        LandingPageAIGenerationForm(
                          disabled: false,
                          onAIDataChanged: (aiData) {
                            setState(() {
                              _aiData = aiData;
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      ResponsiveRowColumn(
                          rowMainAxisAlignment: MainAxisAlignment.center,
                          layout: responsiveValue.largerThan(MOBILE)
                              ? ResponsiveRowColumnType.ROW
                              : ResponsiveRowColumnType.COLUMN,
                          children: [
                            ResponsiveRowColumnItem(
                              child: SecondaryButton(
                                  title: localization
                                      .landingpage_creation_back_button_text,
                                  disabled: widget.buttonsDisabled,
                                  width: responsiveValue.isMobile
                                      ? maxWidth - 20
                                      : maxWidth / 2 - 20,
                                  onTap: () {
                                    widget.onBack(widget.landingPage!);
                                  }),
                            ),
                            const ResponsiveRowColumnItem(
                                child: SizedBox(width: 20, height: 20)),
                            ResponsiveRowColumnItem(
                                child: PrimaryButton(
                                    title: localization.landingpage_create_txt,
                                    disabled: widget.buttonsDisabled ||
                                        (selectedTemplateIndex == null &&
                                            !(_aiData?.hasContent ?? false)),
                                    isLoading: widget.isLoading,
                                    width: responsiveValue.isMobile
                                        ? maxWidth - 20
                                        : maxWidth / 2 - 20,
                                    onTap: () {
                                      if (_aiData?.hasContent ?? false) {
                                        // AI Generation
                                        if (widget.onAISaveTapped != null) {
                                          widget.onAISaveTapped!(
                                              widget.landingPage!,
                                              widget.image,
                                              widget.imageHasChanged,
                                              _aiData!);
                                        }
                                      } else if (selectedTemplateIndex != null) {
                                        // Template Selection
                                        widget.onSaveTapped(
                                            widget.landingPage!,
                                            widget.image,
                                            widget.imageHasChanged,
                                            templates[selectedTemplateIndex!]
                                                .id
                                                .value);
                                      }
                                    }))
                          ]),
                    ]);
                  })),
            ),
          ],
        ),
        );
      },
    );
  }
}
