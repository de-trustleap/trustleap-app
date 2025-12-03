import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_anchor_button_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_calendly_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_contactform_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_icon_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_image_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_spacer_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_videoplayer_content.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_config_menu_text_content.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuContentTab extends StatelessWidget {
  final PageBuilderWidget model;

  const LandingPageBuilderConfigMenuContentTab({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        if (model.elementType == PageBuilderWidgetType.text) ...[
          PagebuilderConfigMenuTextContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.image) ...[
          PagebuilderConfigMenuImageContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.icon) ...[
          PagebuilderConfigMenuIconContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.contactForm) ...[
          PagebuilderConfigMenuContactFormContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.videoPlayer) ...[
          PagebuilderConfigMenuVideoPlayerContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.anchorButton) ...[
          PagebuilderConfigMenuAnchorButtonContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.calendly) ...[
          PagebuilderConfigMenuCalendlyContent(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.spacer) ...[
          PagebuilderConfigMenuSpacerContent(
            model: model,
          )
        ],
        const SizedBox(height: 40)
      ],
    );
  }
}
