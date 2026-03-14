import 'package:finanzbegleiter/features/legals/application/legals_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/auth_page_template.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LegalsPage extends StatefulWidget {
  final LegalsType? legalsType;

  const LegalsPage({super.key, this.legalsType});

  @override
  State<LegalsPage> createState() => _LegalsPageState();
}

class _LegalsPageState extends State<LegalsPage> {
  late LegalsType legalsType;

  @override
  void initState() {
    super.initState();

    if (widget.legalsType != null) {
      legalsType = widget.legalsType!;
    } else {
      final currentRoute = Modular.to.path;
      if (currentRoute.contains("privacy-policy")) {
        legalsType = LegalsType.privacyPolicy;
      } else if (currentRoute.contains("terms-and-condition")) {
        legalsType = LegalsType.termsAndCondition;
      } else {
        legalsType = LegalsType.imprint;
      }
    }
    Modular.get<LegalsCubit>().getLegals(legalsType);
  }

  String _title(AppLocalizations localization) {
    switch (legalsType) {
      case LegalsType.privacyPolicy:
        return localization.settings_privacy_policy;
      case LegalsType.termsAndCondition:
        return localization.settings_terms_and_conditions;
      case LegalsType.imprint:
        return localization.settings_imprint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = Modular.get<LegalsCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    return AuthPageTemplate(
      title: _title(localization),
      child: Material(
        child: CenteredConstrainedWrapper(
          child: BlocBuilder<LegalsCubit, LegalsState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is GetLegalsSuccessState) {
                if (state.text != null) {
                  final baseTextStyle = responsiveValue.isMobile
                      ? themeData.textTheme.bodySmall
                      : themeData.textTheme.bodyMedium;
                  final baseFontSize = baseTextStyle?.fontSize ?? 16.0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Html(
                      data: state.text ?? "",
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontFamily: baseTextStyle?.fontFamily,
                          fontSize: FontSize(baseFontSize),
                          color: baseTextStyle?.color,
                          backgroundColor: themeData.colorScheme.surface,
                        ),
                        "h1": Style(
                          fontSize: FontSize(baseFontSize * 2),
                          color: themeData.colorScheme.onSurface,
                          margin: Margins.only(
                              top: baseFontSize * 1.2,
                              bottom: baseFontSize * 0.5),
                        ),
                        "h2": Style(
                          fontSize: FontSize(baseFontSize * 1.5),
                          color: themeData.colorScheme.onSurface,
                          margin: Margins.only(
                              top: baseFontSize * 1.2,
                              bottom: baseFontSize * 0.5),
                        ),
                        "h3": Style(
                          fontSize: FontSize(baseFontSize * 1.25),
                          color: themeData.colorScheme.onSurface,
                          margin: Margins.only(
                              top: baseFontSize * 1.2,
                              bottom: baseFontSize * 0.5),
                        ),
                        "h4": Style(
                          color: themeData.colorScheme.onSurface,
                          margin: Margins.only(
                              top: baseFontSize * 1.2,
                              bottom: baseFontSize * 0.5),
                        ),
                        "p": Style(
                          margin: Margins.only(
                              top: baseFontSize * 0.5,
                              bottom: baseFontSize * 0.5),
                        ),
                        "ul": Style(
                          margin: Margins.only(
                              top: baseFontSize * 0.5,
                              bottom: baseFontSize * 1,
                              left: baseFontSize * 1.5),
                        ),
                        "table": Style(
                          width: Width(100, Unit.percent),
                          margin: Margins.only(bottom: baseFontSize * 1),
                        ),
                        "th": Style(
                          backgroundColor: themeData.colorScheme.surfaceContainerHighest,
                          border: Border.fromBorderSide(
                              BorderSide(color: themeData.colorScheme.outline, width: 1)),
                          padding: HtmlPaddings.all(8),
                          alignment: Alignment.centerLeft,
                        ),
                        "td": Style(
                          border: Border.fromBorderSide(
                              BorderSide(color: themeData.colorScheme.outline, width: 1)),
                          padding: HtmlPaddings.all(8),
                        ),
                        "tr": Style(
                          backgroundColor: themeData.colorScheme.surface,
                        ),
                        "strong": Style(
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  );
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
