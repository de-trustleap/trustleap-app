import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/axis_alignment_converter.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/button_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/contact_form_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/footer_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/icon_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/image_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_calendly.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_text.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/video_player_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderWidgetBuilder {
  Widget build(PageBuilderWidget model) {
    switch (model.elementType) {
      case PageBuilderWidgetType.container:
        if (model.properties != null) {
          return buildContainerWidget(
              model.properties as PageBuilderContainerProperties, model);
        } else {
          return buildContainerWidget(null, model);
        }
      case PageBuilderWidgetType.column:
        if (model.properties != null) {
          return buildColumnWidget(
              model.properties as PagebuilderColumnProperties, model);
        } else {
          return buildColumnWidget(null, model);
        }
      case PageBuilderWidgetType.row:
        if (model.properties != null) {
          return buildRowWidget(
              model.properties as PagebuilderRowProperties, model);
        } else {
          return buildRowWidget(null, model);
        }
      case PageBuilderWidgetType.text:
        return buildTextWidget(
            model.properties as PageBuilderTextProperties, model);
      case PageBuilderWidgetType.image:
        return buildImageWidget(
            model.properties as PageBuilderImageProperties, model);
      case PageBuilderWidgetType.icon:
        return buildIconWidget(
            model.properties as PageBuilderIconProperties, model);
      case PageBuilderWidgetType.contactForm:
        return buildContactFormWidget(
            model.properties as PageBuilderContactFormProperties, model);
      case PageBuilderWidgetType.footer:
        return buildFooterWidget(
            model.properties as PagebuilderFooterProperties, model);
      case PageBuilderWidgetType.videoPlayer:
        return buildVideoPlayerWidget(
            model.properties as PagebuilderVideoPlayerProperties, model);
      case PageBuilderWidgetType.anchorButton:
        return buildButtonWidget(
            (model.properties as PagebuilderAnchorButtonProperties)
                .buttonProperties!,
            model);
      case PageBuilderWidgetType.calendly:
        return buildCalendlyWidget(
            model.properties as PagebuilderCalendlyProperties, model);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildContainerWidget(
      PageBuilderContainerProperties? properties, PageBuilderWidget model) {
    return LandingPageBuilderWidgetContainer(
        properties: properties,
        model: model,
        child: model.containerChild != null
            ? build(model.containerChild!)
            : const SizedBox.shrink());
  }

  Widget buildColumnWidget(
      PagebuilderColumnProperties? properties, PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }
    return LandingPageBuilderWidgetContainer(
      model: model,
      child: Column(
          mainAxisAlignment:
              properties?.mainAxisAlignment ?? MainAxisAlignment.center,
          crossAxisAlignment:
              properties?.crossAxisAlignment ?? CrossAxisAlignment.center,
          children: model.children?.map((child) {
                return build(child);
              }).toList() ??
              []),
    );
  }

  Widget buildRowWidget(
      PagebuilderRowProperties? properties, PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        // Check if we should switch to Column for current breakpoint
        final shouldBeColumn = properties?.switchToColumnFor != null &&
            properties!.switchToColumnFor!.contains(breakpoint);

        if (shouldBeColumn) {
          // Switch to Column layout - swap main and cross axis alignments
          return LandingPageBuilderWidgetContainer(
            model: model,
            child: Column(
              // Row's mainAxis (horizontal) becomes Column's crossAxis
              crossAxisAlignment: AxisAlignmentConverter.mainAxisToCrossAxis(
                  properties.mainAxisAlignment ?? MainAxisAlignment.center),
              // Row's crossAxis (vertical) becomes Column's mainAxis
              mainAxisAlignment: AxisAlignmentConverter.crossAxisToMainAxis(
                  properties.crossAxisAlignment ?? CrossAxisAlignment.center),
              children:
                  model.children?.map((child) => build(child)).toList() ?? [],
            ),
          );
        }

        // Regular Row layout
        // Berechne den Gesamtwert der definierten widthPercentage Werte
        final totalWidthPercentage = model.children!.fold<double>(
            0,
            (sum, child) =>
                sum +
                (child.widthPercentage?.getValueForBreakpoint(breakpoint) ?? 0));
        // Falls die Gesamtbreite über 100% liegt, passe die Werte an
        final scaleFactor =
            totalWidthPercentage > 100 ? 100 / totalWidthPercentage : 1.0;
        // Restliche Breite berechnen, falls die Gesamtbreite unter 100% liegt
        final remainingWidthPercentage =
            100 - totalWidthPercentage * scaleFactor;

        // Erstelle eine Liste für die Kinder der Row
        List<Widget> rowChildren = [];

        // Füge die Expanded-Widgets für jedes Kind hinzu
        for (var child in model.children!) {
          final flexValue =
              (child.widthPercentage?.getValueForBreakpoint(breakpoint) ?? 0) *
                  scaleFactor;
          rowChildren.add(
            Expanded(
              flex: (flexValue * 100).toInt(),
              child: build(child),
            ),
          );
        }

        // Füge eine SizedBox am Ende hinzu, falls restliche Breite vorhanden ist
        if (remainingWidthPercentage > 0) {
          rowChildren.add(
            Expanded(
              flex: (remainingWidthPercentage * 100).toInt(),
              child: const SizedBox.shrink(),
            ),
          );
        }
        return LandingPageBuilderWidgetContainer(
          model: model,
          child: properties?.equalHeights == true
              ? IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: properties?.mainAxisAlignment ??
                        MainAxisAlignment.center,
                    crossAxisAlignment: properties?.crossAxisAlignment ??
                        CrossAxisAlignment.center,
                    children: rowChildren,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: rowChildren,
                ),
        );
      },
    );
  }

  Widget buildTextWidget(
      PageBuilderTextProperties properties, PageBuilderWidget model) {
    return PagebuilderText(properties: properties, widgetModel: model);
  }

  Widget buildImageWidget(
      PageBuilderImageProperties properties, PageBuilderWidget model) {
    return PageBuilderImageView(properties: properties, widgetModel: model);
  }

  Widget buildIconWidget(
      PageBuilderIconProperties properties, PageBuilderWidget model) {
    return PageBuilderIconView(properties: properties, widgetModel: model);
  }

  Widget buildContactFormWidget(
      PageBuilderContactFormProperties properties, PageBuilderWidget model) {
    return PageBuilderContactFormView(
        properties: properties, widgetModel: model);
  }

  Widget buildFooterWidget(
      PagebuilderFooterProperties properties, PageBuilderWidget model) {
    return PagebuilderFooterView(properties: properties, widgetModel: model);
  }

  Widget buildVideoPlayerWidget(
      PagebuilderVideoPlayerProperties properties, PageBuilderWidget model) {
    return PagebuilderVideoPlayerView(
        properties: properties, widgetModel: model);
  }

  Widget buildButtonWidget(
      PageBuilderButtonProperties properties, PageBuilderWidget model) {
    return LandingPageBuilderWidgetContainer(
      model: model,
      child: PageBuilderButtonView(properties: properties, widgetModel: model),
    );
  }

  Widget buildCalendlyWidget(
      PagebuilderCalendlyProperties properties, PageBuilderWidget model) {
    return PagebuilderCalendly(properties: properties, widgetModel: model);
  }
}
