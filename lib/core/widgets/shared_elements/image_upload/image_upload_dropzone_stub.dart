import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_dropped_file.dart';
import 'package:flutter/material.dart';

// Stub für native: Drag-and-Drop nicht verfügbar, child wird direkt gerendert
class ImageUploadDropzone extends StatelessWidget {
  final Widget child;
  final ValueChanged<ImageDroppedFile> onDroppedFile;
  final Function onHover;
  final Function onLeave;

  const ImageUploadDropzone({
    super.key,
    required this.child,
    required this.onDroppedFile,
    required this.onHover,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) => child;
}
