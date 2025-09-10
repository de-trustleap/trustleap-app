import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';

class LegalsCheck extends StatefulWidget {
  final double maxWidth;
  final bool initialTermsAndConditionsChecked;
  final bool initialPrivacyPolicyChecked;
  final bool isLoggedIn;
  final Function(bool termsAndConditionsChecked, bool privacyPolicyChecked)
      onChanged;

  const LegalsCheck({
    super.key,
    required this.maxWidth,
    this.initialTermsAndConditionsChecked = false,
    this.initialPrivacyPolicyChecked = false,
    required this.isLoggedIn,
    required this.onChanged,
  });

  @override
  State<LegalsCheck> createState() => _LegalsCheckWidgetState();
}

class _LegalsCheckWidgetState extends State<LegalsCheck> {
  late bool termsAndConditionsChecked;
  late bool privacyPolicyChecked;

  @override
  void initState() {
    super.initState();
    termsAndConditionsChecked = widget.initialTermsAndConditionsChecked;
    privacyPolicyChecked = widget.initialPrivacyPolicyChecked;
  }

  void _updateTermsAndConditions(bool? checked) {
    setState(() {
      termsAndConditionsChecked = checked ?? false;
    });
    widget.onChanged(termsAndConditionsChecked, privacyPolicyChecked);
  }

  void _updatePrivacyPolicy(bool? checked) {
    setState(() {
      privacyPolicyChecked = checked ?? false;
    });
    widget.onChanged(termsAndConditionsChecked, privacyPolicyChecked);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    return Column(
      children: [
        SizedBox(
          width: widget.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: termsAndConditionsChecked,
                onChanged: _updateTermsAndConditions,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: themeData.textTheme.bodyMedium,
                    children: [
                      TextSpan(text: localization.register_terms_and_condition_text),
                      const TextSpan(text: ' '),
                      WidgetSpan(
                        child: ClickableLink(
                          title: localization.register_terms_and_condition_link,
                          onTap: () {
                            navigator.openInNewTab(widget.isLoggedIn
                                ? RoutePaths.homePath + RoutePaths.termsAndCondition
                                : RoutePaths.termsAndCondition);
                          },
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: localization.register_terms_and_condition_text2),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: widget.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: privacyPolicyChecked,
                onChanged: _updatePrivacyPolicy,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: themeData.textTheme.bodyMedium,
                    children: [
                      TextSpan(text: localization.register_privacy_policy_text),
                      const TextSpan(text: ' '),
                      WidgetSpan(
                        child: ClickableLink(
                          title: localization.register_privacy_policy_link,
                          onTap: () {
                            navigator.openInNewTab(widget.isLoggedIn
                                ? RoutePaths.homePath + RoutePaths.privacyPolicy
                                : RoutePaths.privacyPolicy);
                          },
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: localization.register_privacy_policy_text2),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
