import 'dart:typed_data';

import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackImageUpload extends StatefulWidget {
  final Function(List<Uint8List>) onImagesSelected;
  final int maxImages;
  final bool disabled;

  const FeedbackImageUpload({
    super.key,
    required this.onImagesSelected,
    required this.maxImages,
    this.disabled = false,
  });

  @override
  State<FeedbackImageUpload> createState() => _FeedbackImageUploadState();
}

class _FeedbackImageUploadState extends State<FeedbackImageUpload> {
  List<Uint8List> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    if (widget.disabled) return;

    final remainingSlots = widget.maxImages - selectedImages.length;
    if (remainingSlots <= 0) return;

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
      );

      if (pickedFiles.isNotEmpty) {
        final List<Uint8List> newImages = [];

        for (int i = 0; i < pickedFiles.length && i < remainingSlots; i++) {
          final bytes = await pickedFiles[i].readAsBytes();
          newImages.add(bytes);
        }

        setState(() {
          selectedImages.addAll(newImages);
        });

        widget.onImagesSelected(selectedImages);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.of(context).showCustomSnackBar(
          'Fehler beim Laden der Bilder: $e',
          SnackBarType.failure,
        );
      }
    }
  }

  void _removeImage(int index) {
    if (widget.disabled) return;

    setState(() {
      selectedImages.removeAt(index);
    });
    widget.onImagesSelected(selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected images grid
        if (selectedImages.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: themeData.colorScheme.outline,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (!widget.disabled)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Add images button
        if (selectedImages.length < widget.maxImages)
          ElevatedButton.icon(
            onPressed: widget.disabled ? null : _pickImages,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              selectedImages.isEmpty
                  ? 'Bilder hinzufügen (${selectedImages.length}/${widget.maxImages})'
                  : 'Weitere Bilder hinzufügen (${selectedImages.length}/${widget.maxImages})',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: themeData.colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }
}
