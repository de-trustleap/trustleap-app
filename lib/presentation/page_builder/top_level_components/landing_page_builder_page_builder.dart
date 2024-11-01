import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_section_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderPageBuilder extends StatefulWidget {
  final PageBuilderPage model;
  const LandingPageBuilderPageBuilder({super.key, required this.model});

  @override
  State<LandingPageBuilderPageBuilder> createState() =>
      _LandingPageBuilderPageBuilderState();
}

class _LandingPageBuilderPageBuilderState
    extends State<LandingPageBuilderPageBuilder> {
  final pageBuilderMenuCubit = Modular.get<PagebuilderConfigMenuCubit>();
  bool _isConfigMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocListener<PagebuilderConfigMenuCubit, PagebuilderConfigMenuState>(
          bloc: pageBuilderMenuCubit,
          listener: (context, state) {
            if (state is PageBuilderConfigMenuOpenedState) {
              setState(() {
                _isConfigMenuOpen = true;
              });
            }
          },
          child: LandingPageBuilderConfigMenu(
              isOpen: _isConfigMenuOpen,
              closeMenu: () {
                setState(() {
                  _isConfigMenuOpen = false;
                });
              }),
        ),
        Expanded(
          child: Container(
            color: widget.model.backgroundColor,
            child: BlocProvider(
              create: (context) => Modular.get<PagebuilderHoverCubit>(),
              child: ListView(
                  children: widget.model.sections != null
                      ? widget.model.sections!
                          .map((section) =>
                              LandingPageBuilderSectionView(model: section))
                          .toList()
                      : []),
            ),
          ),
        ),
      ],
    );
  }
}
