import 'package:finanzbegleiter/presentation/page_builder/landing_page_builder_view.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_page_view.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute,
        child: (_) => const Scaffold(body: PagebuilderPageView()),
        transition: TransitionType.noTransition,
        children: [
          ChildRoute("${RoutePaths.builderPath}/:id",
              child: (_) => const LandingPageBuilderView()),
        ]);
    r.wildcard(child: (_) => const LandingPageBuilderView());
  }
}
