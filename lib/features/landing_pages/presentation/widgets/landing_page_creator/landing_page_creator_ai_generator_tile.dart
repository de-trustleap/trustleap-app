import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LandingPageCreatorAIGeneratorTile extends StatefulWidget {
  final bool isSelected;
  final bool disabled;
  final VoidCallback onTap;

  const LandingPageCreatorAIGeneratorTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.disabled = false,
  });

  @override
  State<LandingPageCreatorAIGeneratorTile> createState() =>
      _LandingPageCreatorAIGeneratorTileState();
}

class _LandingPageCreatorAIGeneratorTileState
    extends State<LandingPageCreatorAIGeneratorTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: MouseRegion(
        cursor: widget.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.disabled) {
            setState(() {
              _isHovered = true;
            });
          }
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: AnimatedScale(
            scale: _isHovered && !widget.disabled ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeData.colorScheme.primary.withValues(alpha: 0.3),
                    themeData.colorScheme.primary.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(
                  color: widget.isSelected
                      ? themeData.colorScheme.secondary
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_fix_high,
                        color: themeData.colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization.landingpage_creator_ai_generator_tile_title,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization
                          .landingpage_creator_ai_generator_tile_description,
                      style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
