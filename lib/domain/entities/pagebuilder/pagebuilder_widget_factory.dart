import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

/// Factory class to create default PageBuilderWidget instances from widget types
class PagebuilderWidgetFactory {
  /// Creates a new widget with default properties based on the widget type
  static PageBuilderWidget createDefaultWidget(PageBuilderWidgetType widgetType) {
    switch (widgetType) {
      case PageBuilderWidgetType.text:
        return _createTextWidget();
      case PageBuilderWidgetType.button:
        return _createButtonWidget();
      case PageBuilderWidgetType.image:
        return _createImageWidget();
      case PageBuilderWidgetType.container:
        return _createContainerWidget();
      case PageBuilderWidgetType.icon:
        return _createIconWidget();
      case PageBuilderWidgetType.videoPlayer:
        return _createVideoPlayerWidget();
      case PageBuilderWidgetType.contactForm:
        return _createContactFormWidget();
      case PageBuilderWidgetType.anchorButton:
        return _createAnchorButtonWidget();
      case PageBuilderWidgetType.calendly:
        return _createCalendlyWidget();
      case PageBuilderWidgetType.row:
        return _createRowWidget();
      case PageBuilderWidgetType.column:
        return _createColumnWidget();
      default:
        // Fallback to text widget for unknown types
        return _createTextWidget();
    }
  }

  static PageBuilderWidget _createTextWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.text,
      properties: const PageBuilderTextProperties(
        text: 'Neuer Text',
        fontSize: PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: null,
        lineHeight: PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        color: Colors.black,
        alignment: PagebuilderResponsiveOrConstant.constant(TextAlign.left),
        textShadow: null,
        isBold: false,
        isItalic: false,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createButtonWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.button,
      properties: const PageBuilderButtonProperties(
        width: PagebuilderResponsiveOrConstant.constant(200.0),
        height: PagebuilderResponsiveOrConstant.constant(50.0),
        borderRadius: 8.0,
        backgroundPaint: null,
        textProperties: PageBuilderTextProperties(
          text: 'Button',
          fontSize: PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: null,
          lineHeight: null,
          letterSpacing: null,
          color: Colors.white,
          alignment: PagebuilderResponsiveOrConstant.constant(TextAlign.center),
          textShadow: null,
          isBold: false,
          isItalic: false,
        ),
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createImageWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.image,
      properties: const PageBuilderImageProperties(
        url: null,
        borderRadius: 0.0,
        width: PagebuilderResponsiveOrConstant.constant(300.0),
        height: PagebuilderResponsiveOrConstant.constant(200.0),
        contentMode: PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
        overlayPaint: null,
        showPromoterImage: false,
        localImage: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createContainerWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.container,
      properties: const PageBuilderContainerProperties(
        borderRadius: 0.0,
        shadow: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createIconWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.icon,
      properties: const PageBuilderIconProperties(
        code: '0xe87c', // star icon code point
        size: PagebuilderResponsiveOrConstant.constant(24.0),
        color: Colors.black,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createVideoPlayerWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.videoPlayer,
      properties: const PagebuilderVideoPlayerProperties(
        link: null,
        width: PagebuilderResponsiveOrConstant.constant(640.0),
        height: PagebuilderResponsiveOrConstant.constant(360.0),
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createContactFormWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.contactForm,
      properties: const PageBuilderContactFormProperties(
        email: null,
        nameTextFieldProperties: null,
        emailTextFieldProperties: null,
        phoneTextFieldProperties: null,
        messageTextFieldProperties: null,
        buttonProperties: null,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createAnchorButtonWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.anchorButton,
      properties: const PagebuilderAnchorButtonProperties(
        sectionName: null,
        buttonProperties: PageBuilderButtonProperties(
          width: PagebuilderResponsiveOrConstant.constant(200.0),
          height: PagebuilderResponsiveOrConstant.constant(50.0),
          borderRadius: 8.0,
          backgroundPaint: null,
          textProperties: PageBuilderTextProperties(
            text: 'Zur Sektion',
            fontSize: PagebuilderResponsiveOrConstant.constant(16.0),
            fontFamily: null,
            lineHeight: null,
            letterSpacing: null,
            color: Colors.white,
            alignment: PagebuilderResponsiveOrConstant.constant(TextAlign.center),
            textShadow: null,
            isBold: false,
            isItalic: false,
          ),
        ),
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createCalendlyWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.calendly,
      properties: const PagebuilderCalendlyProperties(
        width: PagebuilderResponsiveOrConstant.constant(640.0),
        height: PagebuilderResponsiveOrConstant.constant(700.0),
        borderRadius: 0.0,
        calendlyEventURL: null,
        eventTypeName: null,
        textColor: null,
        backgroundColor: null,
        primaryColor: null,
        hideEventTypeDetails: false,
        shadow: null,
        useIntrinsicHeight: false,
      ),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createRowWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.row,
      properties: null,
      hoverProperties: null,
      children: [],
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }

  static PageBuilderWidget _createColumnWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.column,
      properties: null,
      hoverProperties: null,
      children: [],
      containerChild: null,
      widthPercentage: null,
      background: null,
      hoverBackground: null,
      padding: null,
      margin: null,
      maxWidth: null,
      alignment: null,
      customCSS: null,
    );
  }
}
