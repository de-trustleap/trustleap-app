import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileRegisterCompanySection extends StatefulWidget {
  final CustomUser user;
  const ProfileRegisterCompanySection({super.key, required this.user});

  @override
  State<ProfileRegisterCompanySection> createState() =>
      _ProfileRegisterCompanySectionState();
}

class _ProfileRegisterCompanySectionState
    extends State<ProfileRegisterCompanySection> {
  @override
  void initState() {
    if (_hasPendingCompanyRequest()) {
      BlocProvider.of<CompanyRequestCubit>(context)
          .getPendingCompanyRequest(widget.user.pendingCompanyRequestID!);
    }
    super.initState();
  }

  bool _hasPendingCompanyRequest() {
    return widget.user.pendingCompanyRequestID != null &&
        widget.user.pendingCompanyRequestID != "";
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    const spacing = 20;

    return BlocBuilder<CompanyRequestCubit, CompanyRequestState>(
      builder: (context, state) {
        return CardContainer(
            child: LayoutBuilder(builder: ((context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                    localization.profile_register_company_section_title,
                    style: themeData.textTheme.headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: spacing.toDouble()),
                if (!_hasPendingCompanyRequest()) ...[
                  registerRequestView(themeData, responsiveValue, localization,
                      navigator, maxWidth, spacing)
                ] else if (state is PendingCompanyRequestSuccessState) ...[
                  SizedBox(
                    width: maxWidth,
                    child: SelectableText(
                        localization
                            .profile_register_company_section_subtitle_in_progress,
                        style: responsiveValue.isMobile
                            ? themeData.textTheme.bodySmall
                            : themeData.textTheme.bodyMedium),
                  ),
                  if (state.request.createdAt != null) ...[
                    SizedBox(height: spacing.toDouble()),
                    SizedBox(
                      width: maxWidth,
                      child: SelectableText(
                          "${localization.profile_register_company_section_subtitle_requested_at}${DateTimeFormatter().getStringFromDate(context, state.request.createdAt!)}",
                          style: responsiveValue.isMobile
                              ? themeData.textTheme.bodySmall
                              : themeData.textTheme.bodyMedium),
                    )
                  ]
                ] else if (state is PendingCompanyRequestFailureState) ...[
                  FormErrorView(
                      message: DatabaseFailureMapper.mapFailureMessage(
                          state.failure, localization))
                ] else ...[
                  const LoadingIndicator()
                ]
              ]);
        })));
      },
    );
  }

  Widget registerRequestView(
      ThemeData themeData,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localization,
      CustomNavigatorBase navigator,
      double maxWidth,
      int spacing) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelectableText(localization.profile_register_company_section_subtitle,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      SizedBox(height: spacing * 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization.profile_register_company_section_button_title,
              width: responsiveValue.isMobile
                  ? maxWidth - spacing
                  : maxWidth / 2 - spacing,
              disabled: false,
              onTap: () {
                navigator.navigate(
                    RoutePaths.homePath + RoutePaths.companyRegistration);
              })
        ],
      ),
    ]);
  }
}
