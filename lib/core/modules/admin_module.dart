import 'package:finanzbegleiter/features/admin/presentation/admin_area.dart';
import 'package:finanzbegleiter/features/admin/presentation/admin_legals_page.dart';
import 'package:finanzbegleiter/features/admin/presentation/company_requests/admin_page.dart';
import 'package:finanzbegleiter/features/admin/presentation/company_requests/company_request_detail_page.dart';
import 'package:finanzbegleiter/features/admin/presentation/feedback/admin_feedback_page.dart';
import 'package:finanzbegleiter/features/admin/presentation/registration_code_creator.dart';
import 'package:finanzbegleiter/features/admin/presentation/templates/template_manager_page.dart';
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
              child: (_) => const TemplateManagerPage(),
              children: [
                ChildRoute(RoutePaths.templateCreatePath,
                    child: (_) => const TemplateManagerPage()),
                ChildRoute(RoutePaths.templateEditPath,
                    child: (_) => const TemplateManagerPage()),
              ])
        ]);
    r.wildcard(child: (_) => const AdminArea());
  }
}
