import 'package:finanzbegleiter/presentation/admin_area/admin_area.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute,
        child: (_) => const AdminArea(),
        transition: TransitionType.noTransition,
        children: [
          ChildRoute(RoutePaths.overviewPath, child: (_) => const AdminArea())
        ]);
    r.wildcard(child: (_) => const AdminArea());
  }
}
