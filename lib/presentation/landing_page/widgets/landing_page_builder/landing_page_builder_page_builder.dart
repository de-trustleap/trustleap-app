import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_section_builder.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderPageBuilder {
  final LandingPageBuilderSectionBuilder sectionBuilder =
      LandingPageBuilderSectionBuilder();

  Widget buildPage(PageBuilderPage model) {
    return Container(
      color: model.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
            children: model.sections != null
                ? model.sections!
                    .map((section) => sectionBuilder.buildSection(section))
                    .toList()
                : []),
      ),
    );
  }
}
