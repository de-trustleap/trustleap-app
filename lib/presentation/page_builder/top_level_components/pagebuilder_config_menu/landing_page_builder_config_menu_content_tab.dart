import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuContentTab extends StatelessWidget {
  final PageBuilderWidget model;
  const LandingPageBuilderConfigMenuContentTab(
      {super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        PagebuilderConfigMenuTextConfig(model: model)
      ],
    );
  }
}
