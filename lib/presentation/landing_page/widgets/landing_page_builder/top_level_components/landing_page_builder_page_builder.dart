import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/top_level_components/landing_page_builder_section_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderPageBuilder {
  Widget buildPage(PageBuilderPage model) {
    return Container(
      color: model.backgroundColor,
      child: BlocProvider(
        create: (context) => Modular.get<PagebuilderHoverCubit>(),
        child: ListView(
            children: model.sections != null
                ? model.sections!
                    .map((section) =>
                        LandingPageBuilderSectionView(model: section))
                    .toList()
                : []),
      ),
    );
  }
}
