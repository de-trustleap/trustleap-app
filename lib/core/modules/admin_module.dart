import 'package:finanzbegleiter/presentation/admin_area/admin_area.dart';
import 'package:finanzbegleiter/presentation/admin_area/admin_legals_page.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/admin_page.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_request_detail_page.dart';
import 'package:finanzbegleiter/presentation/admin_area/feedback/admin_feedback_page.dart';
import 'package:finanzbegleiter/presentation/admin_area/registration_code_creator.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/template_manager_page.dart';
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
              child: (_) => const CompanyRequestDetailPage()),
          ChildRoute(RoutePaths.registrationCodes,
              child: (_) => const RegistrationCodeCreator()),
          ChildRoute(RoutePaths.userFeedback,
              child: (_) => const AdminFeedbackPage()),
          ChildRoute(RoutePaths.legals, child: (_) => const AdminLegalsPage()),
          ChildRoute(RoutePaths.templates,
              child: (_) => const TemplateManagerPage())
        ]);
    r.wildcard(child: (_) => const AdminArea());
  }
}
