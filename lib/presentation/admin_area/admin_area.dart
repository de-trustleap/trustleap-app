import 'package:finanzbegleiter/presentation/admin_area/company_requests_overview.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:flutter/material.dart';

class AdminArea extends StatelessWidget {
  const AdminArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: CenteredConstrainedWrapper(child: CompanyRequestsOverview()));
  }
}
