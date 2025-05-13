import 'package:flutter/material.dart';

class RecommendationManagerFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  const RecommendationManagerFavoriteButton(
      {super.key, required this.isFavorite, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return IconButton(
        onPressed: onPressed,
        color: themeData.colorScheme.secondary,
        iconSize: 24,
        icon: isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border));
  }
}
