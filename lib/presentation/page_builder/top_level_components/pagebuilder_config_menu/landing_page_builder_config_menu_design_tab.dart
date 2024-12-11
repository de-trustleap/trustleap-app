import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_background.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_container_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_image_config.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_layout.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuDesignTab extends StatelessWidget {
  final PageBuilderWidget model;
  const LandingPageBuilderConfigMenuDesignTab({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        if (model.elementType == PageBuilderWidgetType.text) ...[
          PagebuilderConfigMenuTextConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.image) ...[
          PagebuilderConfigMenuImageConfig(model: model)
        ] else if (model.elementType == PageBuilderWidgetType.container) ...[
          PagebuilderConfigMenuContainerConfig(model: model)
        ],
        SizedBox(height: 8),
        PagebuilderConfigMenuLayout(model: model),
        SizedBox(height: 8),
        PagebuilderConfigMenuBackground(model: model)
      ],
    );
  }
}
