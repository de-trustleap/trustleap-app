import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_anchor_button_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_background.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_calendly_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_column_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_contactform_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_container_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_custom_css.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_footer_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_icon_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_image_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_layout.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_row_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config_container.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_videoplayer_config.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuDesignTab extends StatelessWidget {
  final PageBuilderWidget model;
  final LandingPage? landingPage;
  final PageBuilderGlobalColors? globalColors;

  const LandingPageBuilderConfigMenuDesignTab({
    super.key,
    required this.model,
    this.landingPage,
    this.globalColors,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        if (model.elementType == PageBuilderWidgetType.text) ...[
          PagebuilderConfigMenuTextConfigContainer(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.image) ...[
          PagebuilderConfigMenuImageConfig(model: model, globalColors: globalColors)
        ] else if (model.elementType == PageBuilderWidgetType.container) ...[
          PagebuilderConfigMenuContainerConfig(model: model, globalColors: globalColors)
        ] else if (model.elementType == PageBuilderWidgetType.row) ...[
          PagebuilderConfigMenuRowConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.column) ...[
          PagebuilderConfigMenuColumnConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.icon) ...[
          PagebuilderConfigMenuIconConfig(model: model, globalColors: globalColors)
        ] else if (model.elementType == PageBuilderWidgetType.contactForm) ...[
          PagebuilderConfigMenuContactFormConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.footer) ...[
          PagebuilderConfigMenuFooterConfig(model: model, landingPage: landingPage)
        ] else if (model.elementType == PageBuilderWidgetType.videoPlayer) ...[
          PagebuilderConfigMenuVideoPlayerConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.anchorButton) ...[
          PagebuilderConfigMenuAnchorButtonConfig(model: model, globalColors: globalColors)
        ] else if (model.elementType == PageBuilderWidgetType.calendly) ...[
          PagebuilderConfigMenuCalendlyConfig(model: model, globalColors: globalColors)
        ],
        const SizedBox(height: 8),
        PagebuilderConfigMenuLayout(model: model),
        const SizedBox(height: 8),
        PagebuilderConfigMenuBackground(model: model, section: null, globalColors: globalColors),
        const SizedBox(height: 8),
        PagebuilderConfigMenuCustomCSS(model: model, section: null),
        const SizedBox(height: 40)
      ],
    );
  }
}
