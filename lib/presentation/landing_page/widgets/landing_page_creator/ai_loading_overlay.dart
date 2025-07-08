import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class AILoadingOverlay extends StatelessWidget {
  const AILoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Stack(
      children: [
        // Semi-transparent background
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
        // Loading content
        Positioned.fill(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoadingIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    "Die KI erstellt gerade deine Landing Page...",
                    style: themeData.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Das kann bis zu 5 Minuten dauern. Bitte warten...",
                    style: themeData.textTheme.bodyMedium!.copyWith(
                      color: themeData.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}