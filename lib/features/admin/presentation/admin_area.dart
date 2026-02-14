import 'package:finanzbegleiter/features/admin/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/features/admin/presentation/company_requests/company_requests_overview.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminArea extends StatelessWidget {
  const AdminArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => Modular.get<CompanyRequestObserverCubit>()
              ..observeAllPendingCompanyRequests(),
            child: const CenteredConstrainedWrapper(
                child: CompanyRequestsOverview())));
  }
}
