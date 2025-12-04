import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuSpacerContent extends StatelessWidget {
  final PageBuilderWidget model;

  const PagebuilderConfigMenuSpacerContent({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.height &&
        model.properties is PageBuilderHeightProperties) {
      final properties = model.properties as PageBuilderHeightProperties;

      return CardContainer(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<PagebuilderResponsiveBreakpointCubit,
            PagebuilderResponsiveBreakpoint>(
          bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
          builder: (context, currentBreakpoint) {
            final helper =
                PagebuilderResponsiveConfigHelper(currentBreakpoint);

            return PagebuilderNumberStepperControl(
              title: localization.landingpage_pagebuilder_spacer_config_height,
              initialValue: helper.getValue(properties.height) ?? 40,
              minValue: 1,
              maxValue: 10000,
              bigNumbers: true,
              showResponsiveButton: true,
              currentBreakpoint: currentBreakpoint,
              onSelected: (value) {
                final updatedHeight =
                    helper.setValue(properties.height, value);
                final updatedProperties =
                    properties.copyWith(height: updatedHeight);
                final updatedWidget =
                    model.copyWith(properties: updatedProperties);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
