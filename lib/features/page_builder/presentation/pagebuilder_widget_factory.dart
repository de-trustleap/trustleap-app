import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_background.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

class PagebuilderWidgetFactory {
  static PageBuilderWidget createDefaultWidget(
      PageBuilderWidgetType widgetType) {
    switch (widgetType) {
      case PageBuilderWidgetType.text:
        return _createTextWidget();
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
      case PageBuilderWidgetType.height:
        return _createHeightWidget();
      case PageBuilderWidgetType.placeholder:
        return _createPlaceholderWidget();
      default:
        return _createTextWidget();
    }
  }

  static PageBuilderWidget _createTextWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.text,
      properties: const PageBuilderTextProperties(
        text: '<span style="color: #000000">Neuer Text</span>',
        fontSize: PagebuilderResponsiveOrConstant.constant(20.0),
        fontFamily: "Poppins",
        lineHeight: PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        color: null,
        alignment: PagebuilderResponsiveOrConstant.constant(TextAlign.left),
        textShadow: null,
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
          border: null,
          width: PagebuilderResponsiveOrConstant.constant(300.0),
          height: PagebuilderResponsiveOrConstant.constant(200.0),
          contentMode: PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          overlayPaint: null,
          showPromoterImage: false,
          localImage: null,
          shadow: null),
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
          border: null, shadow: null, width: null, height: null),
      hoverProperties: null,
      children: null,
      containerChild: null,
      widthPercentage: null,
      background: PagebuilderBackground(
          backgroundPaint: PagebuilderPaint(
              color: Color(ColorUtility.getHexIntFromString("FFFFFFFF"))),
          imageProperties: null,
          overlayPaint: null),
      hoverBackground: null,
      padding: const PageBuilderSpacing(
          top: PagebuilderResponsiveOrConstant.constant(50),
          bottom: PagebuilderResponsiveOrConstant.constant(50),
          left: PagebuilderResponsiveOrConstant.constant(50),
          right: PagebuilderResponsiveOrConstant.constant(50)),
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
        code: '0xe87c',
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
      properties: PageBuilderContactFormProperties(
        email: null,
        nameTextFieldProperties: PageBuilderTextFieldProperties(
            width: const PagebuilderResponsiveOrConstant.constant(400),
            minLines: 1,
            maxLines: 1,
            isRequired: true,
            backgroundColor:
                Color(ColorUtility.getHexIntFromString("FFF9F9F9")),
            borderColor: Color(ColorUtility.getHexIntFromString("FFDBDBDB")),
            placeHolderTextProperties: PageBuilderTextProperties(
                text: "Ihr Name",
                fontSize: const PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: Color(ColorUtility.getHexIntFromString("FF9A9A9C")),
                alignment: const PagebuilderResponsiveOrConstant.constant(
                    TextAlign.left),
                textShadow: null),
            textProperties: const PageBuilderTextProperties(
                text: null,
                fontSize: PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: null,
                alignment:
                    PagebuilderResponsiveOrConstant.constant(TextAlign.left),
                textShadow: null)),
        emailTextFieldProperties: PageBuilderTextFieldProperties(
            width: const PagebuilderResponsiveOrConstant.constant(400),
            minLines: 1,
            maxLines: 1,
            isRequired: true,
            backgroundColor:
                Color(ColorUtility.getHexIntFromString("FFF9F9F9")),
            borderColor: Color(ColorUtility.getHexIntFromString("FFDBDBDB")),
            placeHolderTextProperties: PageBuilderTextProperties(
                text: "Ihr E-Mail",
                fontSize: const PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: Color(ColorUtility.getHexIntFromString("FF9A9A9C")),
                alignment: const PagebuilderResponsiveOrConstant.constant(
                    TextAlign.left),
                textShadow: null),
            textProperties: const PageBuilderTextProperties(
                text: null,
                fontSize: PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: null,
                alignment:
                    PagebuilderResponsiveOrConstant.constant(TextAlign.left),
                textShadow: null)),
        phoneTextFieldProperties: PageBuilderTextFieldProperties(
            width: const PagebuilderResponsiveOrConstant.constant(400),
            minLines: 1,
            maxLines: 1,
            isRequired: true,
            backgroundColor:
                Color(ColorUtility.getHexIntFromString("FFF9F9F9")),
            borderColor: Color(ColorUtility.getHexIntFromString("FFDBDBDB")),
            placeHolderTextProperties: PageBuilderTextProperties(
                text: "Ihre Telefonnummer",
                fontSize: const PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: Color(ColorUtility.getHexIntFromString("FF9A9A9C")),
                alignment: const PagebuilderResponsiveOrConstant.constant(
                    TextAlign.left),
                textShadow: null),
            textProperties: const PageBuilderTextProperties(
                text: null,
                fontSize: PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: null,
                alignment:
                    PagebuilderResponsiveOrConstant.constant(TextAlign.left),
                textShadow: null)),
        messageTextFieldProperties: PageBuilderTextFieldProperties(
            width: const PagebuilderResponsiveOrConstant.constant(400),
            minLines: 4,
            maxLines: 10,
            isRequired: true,
            backgroundColor:
                Color(ColorUtility.getHexIntFromString("FFF9F9F9")),
            borderColor: Color(ColorUtility.getHexIntFromString("FFDBDBDB")),
            placeHolderTextProperties: PageBuilderTextProperties(
                text: "Ihre Nachricht",
                fontSize: const PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: Color(ColorUtility.getHexIntFromString("FF9A9A9C")),
                alignment: const PagebuilderResponsiveOrConstant.constant(
                    TextAlign.left),
                textShadow: null),
            textProperties: const PageBuilderTextProperties(
                text: null,
                fontSize: PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: null,
                alignment:
                    PagebuilderResponsiveOrConstant.constant(TextAlign.left),
                textShadow: null)),
        buttonProperties: PageBuilderButtonProperties(
            sizeMode: null,
            width: const PagebuilderResponsiveOrConstant.constant(200),
            height: const PagebuilderResponsiveOrConstant.constant(70),
            minWidthPercent: null,
            contentPadding: null,
            border:
                const PagebuilderBorder(width: null, radius: 4, color: null),
            backgroundPaint: PagebuilderPaint(
                color: Color(ColorUtility.getHexIntFromString("FF000000"))),
            textProperties: PageBuilderTextProperties(
                text: "Nachricht senden",
                fontSize: const PagebuilderResponsiveOrConstant.constant(16),
                fontFamily: "Roboto",
                lineHeight: null,
                letterSpacing: null,
                color: Color(ColorUtility.getHexIntFromString("FFFFFFFF")),
                alignment: const PagebuilderResponsiveOrConstant.constant(
                    TextAlign.center),
                textShadow: null)),
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
          sizeMode: null,
          width: PagebuilderResponsiveOrConstant.constant(200.0),
          height: PagebuilderResponsiveOrConstant.constant(50.0),
          minWidthPercent: null,
          contentPadding: null,
          border: PagebuilderBorder(width: null, radius: 8, color: null),
          backgroundPaint: null,
          textProperties: PageBuilderTextProperties(
            text: "Zur Sektion",
            fontSize: PagebuilderResponsiveOrConstant.constant(16.0),
            fontFamily: "Roboto",
            lineHeight: null,
            letterSpacing: null,
            color: Colors.black,
            alignment:
                PagebuilderResponsiveOrConstant.constant(TextAlign.center),
            textShadow: null,
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

  static PageBuilderWidget _createHeightWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.height,
      properties: const PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
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

  static PageBuilderWidget _createPlaceholderWidget() {
    return PageBuilderWidget(
      id: UniqueID(),
      elementType: PageBuilderWidgetType.placeholder,
      properties: null,
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
}
