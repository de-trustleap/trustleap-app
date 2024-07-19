import 'package:finanzbegleiter/presentation/admin_area/admin_area.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/admin_page.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_request_detail.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute,
        child: (_) => const AdminPage(),
        transition: TransitionType.noTransition,
        children: [
          ChildRoute(RoutePaths.companyRequestsPath,
              child: (_) => const AdminArea()),
          ChildRoute(RoutePaths.companyRequestDetails,
              child: (_) => const CompanyRequestDetail())
        ]);
    r.wildcard(child: (_) => const AdminArea());
  }
}
