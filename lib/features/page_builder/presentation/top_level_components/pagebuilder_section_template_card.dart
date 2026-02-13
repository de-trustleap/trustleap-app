import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section_template_meta.dart';
import 'package:flutter/material.dart';

class PagebuilderSectionTemplateCard extends StatefulWidget {
  final PagebuilderSectionTemplateMeta meta;
  final VoidCallback onSelected;

  const PagebuilderSectionTemplateCard({
    super.key,
    required this.meta,
    required this.onSelected,
  });

  @override
  State<PagebuilderSectionTemplateCard> createState() =>
      _PagebuilderSectionTemplateCardState();
}

class _PagebuilderSectionTemplateCardState
    extends State<PagebuilderSectionTemplateCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onSelected,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: themeData.colorScheme.secondary
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.meta.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: themeData.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: themeData.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: themeData.colorScheme.onSurface
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ),
                if (_isHovered)
                  Container(
                    color:
                        themeData.colorScheme.secondary.withValues(alpha: 0.1),
                    child: Center(
                      child: Icon(
                        Icons.add_circle,
                        size: 48,
                        color: themeData.colorScheme.secondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
