import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/create_template_view.dart';
import 'package:finanzbegleiter/presentation/admin_area/templates/edit_template_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TemplateManagerPage extends StatefulWidget {
  const TemplateManagerPage({super.key});

  @override
  State<TemplateManagerPage> createState() => _TemplateManagerPageState();
}

class _TemplateManagerPageState extends State<TemplateManagerPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    final currentRoute = Modular.to.path;
    if (currentRoute == "${RoutePaths.adminPath}${RoutePaths.templates}") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Modular.to.navigate(
            "${RoutePaths.adminPath}${RoutePaths.templates}${RoutePaths.templateCreatePath}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return CustomTabBar(
      tabs: [
        CustomTabItem(
          title: localization.admin_area_template_manager_tab_create,
          icon: Icons.upload_file,
          route:
              "${RoutePaths.adminPath}${RoutePaths.templates}${RoutePaths.templateCreatePath}",
          content: const CreateTemplateView(),
        ),
        CustomTabItem(
          title: localization.admin_area_template_manager_tab_edit,
          icon: Icons.edit,
          route:
              "${RoutePaths.adminPath}${RoutePaths.templates}${RoutePaths.templateEditPath}",
          content: const EditTemplateView(),
        ),
      ],
    );
  }
}
