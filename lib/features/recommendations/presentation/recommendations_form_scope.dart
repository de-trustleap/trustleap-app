import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_form_helper.dart';
import 'package:flutter/material.dart';

class RecommendationsFormScope extends InheritedWidget {
  final TextEditingController promoterTextController;
  final TextEditingController serviceProviderTextController;
  final List<RecommendationReason> reasons;
  final RecommendationReason? selectedReason;
  final CustomUser? currentUser;
  final CustomUser? parentUser;
  final RecommendationFormHelper helper;
  final GlobalKey<FormState> formKey;
  final bool validationHasError;
  final String? reasonValid;
  final bool promoterTextFieldDisabled;

  final ValueChanged<RecommendationReason?> onReasonChanged;
  final VoidCallback onResetError;
  final ValueChanged<String?> onReasonValidChanged;
  final ValueChanged<bool> onValidationHasErrorChanged;

  final String Function() getReasonValues;
  final bool Function() isRecommendationLimitReached;
  final bool Function() hasActiveReasons;
  final String? Function() getRecommendationLimitResetText;

  const RecommendationsFormScope({
    super.key,
    required super.child,
    required this.promoterTextController,
    required this.serviceProviderTextController,
    required this.reasons,
    required this.selectedReason,
    required this.currentUser,
    required this.parentUser,
    required this.helper,
    required this.formKey,
    required this.validationHasError,
    required this.reasonValid,
    required this.promoterTextFieldDisabled,
    required this.onReasonChanged,
    required this.onResetError,
    required this.onReasonValidChanged,
    required this.onValidationHasErrorChanged,
    required this.getReasonValues,
    required this.isRecommendationLimitReached,
    required this.hasActiveReasons,
    required this.getRecommendationLimitResetText,
  });

  static RecommendationsFormScope of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RecommendationsFormScope>()!;
  }

  @override
  bool updateShouldNotify(RecommendationsFormScope oldWidget) {
    return reasons != oldWidget.reasons ||
        selectedReason != oldWidget.selectedReason ||
        currentUser != oldWidget.currentUser ||
        parentUser != oldWidget.parentUser ||
        validationHasError != oldWidget.validationHasError ||
        reasonValid != oldWidget.reasonValid ||
        promoterTextFieldDisabled != oldWidget.promoterTextFieldDisabled;
  }
}

class SectionHeader extends StatelessWidget {
  final int number;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}
