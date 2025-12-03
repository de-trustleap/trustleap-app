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
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/button_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/contact_form_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/footer_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/icon_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/image_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_calendly.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_placeholder.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_text.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/video_player_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/widgets/pagebuilder_height_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/reorderable_column_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_row/reorderable_row_widget.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetBuilder {
  final LandingPage? landingPage;

  LandingPageBuilderWidgetBuilder({this.landingPage});

  Widget build(PageBuilderWidget model, {int? index}) {
    switch (model.elementType) {
      case PageBuilderWidgetType.container:
        if (model.properties != null) {
          return buildContainerWidget(
              model.properties as PageBuilderContainerProperties, model,
              index: index);
        } else {
          return buildContainerWidget(null, model, index: index);
        }
      case PageBuilderWidgetType.column:
        if (model.properties != null) {
          return _buildColumnWidget(
              model.properties as PagebuilderColumnProperties, model);
        } else {
          return _buildColumnWidget(null, model);
        }
      case PageBuilderWidgetType.row:
        if (model.properties != null) {
          return buildRowWidget(
              model.properties as PagebuilderRowProperties, model,
              index: index);
        } else {
          return buildRowWidget(null, model, index: index);
        }
      case PageBuilderWidgetType.text:
        return buildTextWidget(
            model.properties as PageBuilderTextProperties, model,
            index: index);
      case PageBuilderWidgetType.image:
        return buildImageWidget(
            model.properties as PageBuilderImageProperties, model,
            index: index);
      case PageBuilderWidgetType.icon:
        return buildIconWidget(
            model.properties as PageBuilderIconProperties, model,
            index: index);
      case PageBuilderWidgetType.contactForm:
        return buildContactFormWidget(
            model.properties as PageBuilderContactFormProperties, model,
            index: index);
      case PageBuilderWidgetType.footer:
        return buildFooterWidget(
            model.properties as PagebuilderFooterProperties, model,
            index: index);
      case PageBuilderWidgetType.videoPlayer:
        return buildVideoPlayerWidget(
            model.properties as PagebuilderVideoPlayerProperties, model,
            index: index);
      case PageBuilderWidgetType.anchorButton:
        return buildButtonWidget(
            (model.properties as PagebuilderAnchorButtonProperties)
                .buttonProperties!,
            model,
            index: index);
      case PageBuilderWidgetType.calendly:
        return buildCalendlyWidget(
            model.properties as PagebuilderCalendlyProperties, model,
            index: index);
      case PageBuilderWidgetType.height:
        return buildSpacerWidget(
            model.properties as PageBuilderHeightProperties, model,
            index: index);
      case PageBuilderWidgetType.placeholder:
        return buildPlaceholderWidget(model, index: index);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildContainerWidget(
      PageBuilderContainerProperties? properties, PageBuilderWidget model,
      {int? index}) {
    return LandingPageBuilderWidgetContainer(
      properties: properties,
      model: model,
      index: index,
      child: model.containerChild != null
          ? build(model.containerChild!)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildColumnWidget(
      PagebuilderColumnProperties? properties, PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    final mainAxisAlignment =
        properties?.mainAxisAlignment ?? MainAxisAlignment.center;
    final crossAxisAlignment =
        properties?.crossAxisAlignment ?? CrossAxisAlignment.center;

    return ReorderableColumnWidget(
      model: model,
      properties: properties,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      buildChild: (child, index) => build(child, index: index),
    );
  }

  Widget buildRowWidget(
      PagebuilderRowProperties? properties, PageBuilderWidget model,
      {int? index}) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableRowWidget(
      model: model,
      properties: properties,
      index: index,
      buildChild: (child, childIndex) => build(child, index: childIndex),
    );
  }

  Widget buildTextWidget(
      PageBuilderTextProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PagebuilderText(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildImageWidget(
      PageBuilderImageProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PageBuilderImageView(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildIconWidget(
      PageBuilderIconProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PageBuilderIconView(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildContactFormWidget(
      PageBuilderContactFormProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PageBuilderContactFormView(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildFooterWidget(
      PagebuilderFooterProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PagebuilderFooterView(
        properties: properties,
        widgetModel: model,
        index: index,
        landingPage: landingPage);
  }

  Widget buildVideoPlayerWidget(
      PagebuilderVideoPlayerProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PagebuilderVideoPlayerView(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildButtonWidget(
      PageBuilderButtonProperties properties, PageBuilderWidget model,
      {int? index}) {
    return LandingPageBuilderWidgetContainer(
      model: model,
      index: index,
      child: PageBuilderButtonView(properties: properties, widgetModel: model),
    );
  }

  Widget buildCalendlyWidget(
      PagebuilderCalendlyProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PagebuilderCalendly(
        properties: properties, widgetModel: model, index: index);
  }

  Widget buildSpacerWidget(
      PageBuilderHeightProperties properties, PageBuilderWidget model,
      {int? index}) {
    return PageBuilderHeightView(model: model);
  }

  Widget buildPlaceholderWidget(PageBuilderWidget model, {int? index}) {
    return PagebuilderPlaceholder(
      widgetModel: model,
      index: index,
    );
  }
}
