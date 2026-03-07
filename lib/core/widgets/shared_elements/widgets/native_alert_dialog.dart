// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/destructive_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class NativeAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? messageWidget;
  final bool isLoading;
  final String actionButtonTitle;
  final String? cancelButtonTitle;
  final bool cancelButtonDisabled;
  final bool actionButtonDisabled;
  final Function actionButtonAction;
  final Function? cancelButtonAction;
  final IconData? icon;
  final bool isDestructive;

  const NativeAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.isLoading = false,
    this.messageWidget,
    required this.actionButtonTitle,
    required this.actionButtonAction,
    this.cancelButtonDisabled = false,
    this.actionButtonDisabled = false,
    this.cancelButtonTitle,
    this.cancelButtonAction,
    this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? theme.colorScheme.error.withValues(alpha: 0.1)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (title.isNotEmpty) ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (isLoading) ...[
              const SizedBox(height: 8),
              const LoadingIndicator(),
              const SizedBox(height: 8),
            ] else if (messageWidget != null) ...[
              messageWidget!,
            ] else if (message.isNotEmpty) ...[
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (isDestructive)
              DestructiveButton(
                title: actionButtonTitle,
                disabled: actionButtonDisabled,
                isLoading: isLoading,
                onTap: actionButtonAction,
              )
            else
              PrimaryButton(
                title: actionButtonTitle,
                disabled: actionButtonDisabled,
                isLoading: isLoading,
                onTap: actionButtonAction,
              ),
            if (cancelButtonAction != null && cancelButtonTitle != null) ...[
              const SizedBox(height: 8),
              SecondaryButton(
                title: cancelButtonTitle!,
                disabled: cancelButtonDisabled,
                onTap: cancelButtonAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
