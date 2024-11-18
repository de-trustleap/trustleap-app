import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_section_builder.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu.dart';
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
        BlocConsumer<PagebuilderConfigMenuCubit, PagebuilderConfigMenuState>(
            bloc: pageBuilderMenuCubit,
            listener: (context, state) {
              if (state is PageBuilderConfigMenuOpenedState) {
                setState(() {
                  _isConfigMenuOpen = true;
                });
              }
            },
            builder: (context, state) {
              if (state is PageBuilderConfigMenuOpenedState) {
                return LandingPageBuilderConfigMenu(
                    key: ValueKey(state.model.id),
                    isOpen: _isConfigMenuOpen,
                    model: state.model,
                    closeMenu: () {
                      setState(() {
                        _isConfigMenuOpen = false;
                      });
                    });
              } else {
                return SizedBox.shrink();
              }
            }),
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
