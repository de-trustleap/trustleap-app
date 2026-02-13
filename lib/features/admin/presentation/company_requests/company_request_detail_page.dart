import 'package:finanzbegleiter/features/admin/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/features/admin/presentation/company_requests/company_request_detail.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
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
