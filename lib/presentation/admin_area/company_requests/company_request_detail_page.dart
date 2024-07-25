import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_request_detail.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompanyRequestDetailPage extends StatelessWidget {
  const CompanyRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Modular.get<CompanyRequestCubit>(),
      child: const CenteredConstrainedWrapper(child: CompanyRequestDetail()),
    );
  }
}
