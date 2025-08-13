import 'package:finanzbegleiter/application/legals/legals_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/auth_page_template.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LegalsPage extends StatefulWidget {
  const LegalsPage({super.key});

  @override
  State<LegalsPage> createState() => _LegalsPageState();
}

class _LegalsPageState extends State<LegalsPage> {
  late LegalsType legalsType;

  @override
  void initState() {
    super.initState();

    final currentRoute = Modular.to.path;
    if (currentRoute.contains("privacy-policy")) {
      legalsType = LegalsType.privacyPolicy;
    } else if (currentRoute.contains("terms-and-condition")) {
      legalsType = LegalsType.termsAndCondition;
    } else {
      legalsType = LegalsType.imprint;
    }
    Modular.get<LegalsCubit>().getLegals(legalsType);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = Modular.get<LegalsCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return AuthPageTemplate(
      child: Material(
        child: CenteredConstrainedWrapper(
          child: BlocBuilder<LegalsCubit, LegalsState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is GetLegalsSuccessState) {
                if (state.text != null) {
                  return SelectableText(state.text ?? "",
                      style: themeData.textTheme.bodyMedium);
                } else {
                  return ErrorView(
                      title: localization.admin_company_request_overview_error,
                      message: legalsType == LegalsType.privacyPolicy
                          ? "Es wurde keine Datenschutzerklärung gefunden."
                          : "Es wurden keine AGB gefunden.",
                      callback: () => {cubit.getLegals(legalsType)});
                }
              } else if (state is GetLegalsFailureState) {
                return ErrorView(
                    title: localization.admin_company_request_overview_error,
                    message: DatabaseFailureMapper.mapFailureMessage(
                        state.failure, localization),
                    callback: () => {cubit.getLegals(legalsType)});
              } else {
                return const LoadingIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
