import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderView extends StatefulWidget {
  const LandingPageBuilderView({super.key});

  @override
  State<LandingPageBuilderView> createState() => _LandingPageBuilderViewState();
}

class _LandingPageBuilderViewState extends State<LandingPageBuilderView> {
  late PagebuilderContent pageBuilderContent;
  late String id;

  @override
  void initState() {
    super.initState();

    id = Modular.args.params["id"] ?? "";
    BlocProvider.of<MenuCubit>(context).collapseMenu(true);
    Modular.get<PagebuilderCubit>().getLandingPage(id);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final pageBuilderCubit = Modular.get<PagebuilderCubit>();

    return BlocConsumer<PagebuilderCubit, PagebuilderState>(
      bloc: pageBuilderCubit,
      listener: (context, state) {
        if (state is GetLandingPageAndUserSuccessState) {
          pageBuilderContent = state.content;
        }
      },
      builder: (context, state) {
        if (state is GetLandingPageFailureState) {
          return ErrorView(
              title: localization.landingpage_pagebuilder_container_request_error,
              message: DatabaseFailureMapper.mapFailureMessage(
                  state.failure, localization),
              callback: () =>
                  {Modular.get<PagebuilderCubit>().getLandingPage(id)});
        } else if (state is GetLandingPageAndUserSuccessState) {
          return Scaffold(
              appBar:
                  AppBar(title: Text(state.content.landingPage?.name ?? "", style: themeData.textTheme.bodyLarge)),
              body: 
                state.content.content != null ?
                  LandingPageBuilderPageBuilder().buildPage(state.content.content!) : const Text("FEHLER!"));
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
