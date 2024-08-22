// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class CustomEmojiPicker extends StatelessWidget {
  final TextEditingController controller;

  const CustomEmojiPicker({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return EmojiPicker(
        textEditingController: controller,
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          swapCategoryAndBottomBar: false,
          skinToneConfig: const SkinToneConfig(enabled: true),
          categoryViewConfig: CategoryViewConfig(
              initCategory: Category.SMILEYS,
              backgroundColor: Colors.transparent,
              indicatorColor: themeData.colorScheme.secondary,
              iconColor: themeData.colorScheme.surfaceTint.withOpacity(0.7),
              iconColorSelected: themeData.colorScheme.secondary),
          emojiViewConfig:
              const EmojiViewConfig(backgroundColor: Colors.transparent),
          bottomActionBarConfig: BottomActionBarConfig(
              showBackspaceButton: false,
              backgroundColor: Colors.transparent,
              buttonColor: Colors.transparent,
              buttonIconColor: themeData.colorScheme.secondary),
          searchViewConfig: SearchViewConfig(
              backgroundColor: Colors.transparent,
              buttonColor: Colors.transparent,
              buttonIconColor: themeData.colorScheme.secondary,
              hintText: "Suche Emoji"),
        ));
  }
}
