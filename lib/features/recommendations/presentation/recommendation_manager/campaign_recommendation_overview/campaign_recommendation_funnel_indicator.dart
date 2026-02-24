import 'package:finanzbegleiter/features/recommendations/domain/recommendation_campaign_funnel_step.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CampaignRecommendationFunnelIndicator extends StatelessWidget {
  final RecommendationStatusCounts? statusCounts;

  const CampaignRecommendationFunnelIndicator({
    super.key,
    required this.statusCounts,
  });

  static const double _circleSize = 40;

  List<RecommendationCampaignFunnelStep> _buildSteps(
      AppLocalizations localization) {
    final counts = statusCounts ?? const RecommendationStatusCounts();
    final baseCount = counts.linkClicked;

    return [
      RecommendationCampaignFunnelStep(
        icon: Icons.mouse,
        label: localization.campaign_manager_funnel_link_clicked,
        count: counts.linkClicked,
      ),
      RecommendationCampaignFunnelStep(
        icon: Icons.send,
        label: localization.campaign_manager_funnel_contact_form,
        count: counts.contactFormSent,
        percentage: baseCount > 0
            ? counts.contactFormSent / baseCount * 100
            : 0.0,
      ),
      RecommendationCampaignFunnelStep(
        icon: Icons.calendar_month,
        label: localization.campaign_manager_funnel_appointment,
        count: counts.appointment,
        percentage:
            baseCount > 0 ? counts.appointment / baseCount * 100 : 0.0,
      ),
      RecommendationCampaignFunnelStep(
        icon: Icons.check,
        label: localization.campaign_manager_funnel_successful,
        count: counts.successful,
        percentage:
            baseCount > 0 ? counts.successful / baseCount * 100 : 0.0,
      ),
      RecommendationCampaignFunnelStep(
        icon: Icons.warning,
        label: localization.campaign_manager_funnel_failed,
        count: counts.failed,
        percentage:
            baseCount > 0 ? counts.failed / baseCount * 100 : 0.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final steps = _buildSteps(localization);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.campaign_manager_funnel_title,
          style: themeData.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;

          return _buildFunnelStep(
            themeData: themeData,
            step: step,
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildFunnelStep({
    required ThemeData themeData,
    required RecommendationCampaignFunnelStep step,
    required bool isLast,
  }) {
    final stepColor =
        isLast ? themeData.colorScheme.error : themeData.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  color: stepColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(step.icon, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.label,
                      style: themeData.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${step.count}",
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isLast ? themeData.colorScheme.error : null,
                      ),
                    ),
                  ],
                ),
                if (step.percentage != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: step.percentage! / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(stepColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        child: Text(
                          "${step.percentage!.toStringAsFixed(0)}%",
                          textAlign: TextAlign.right,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
