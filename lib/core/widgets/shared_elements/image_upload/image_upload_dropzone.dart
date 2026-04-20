// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/widgets/shared_elements/image_upload/image_dropped_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class ImageUploadDropzone extends StatefulWidget {
  final Widget child;
  final ValueChanged<ImageDroppedFile> onDroppedFile;
  final Function onHover;
  final Function onLeave;

  const ImageUploadDropzone(
      {super.key,
      required this.child,
      required this.onDroppedFile,
      required this.onHover,
      required this.onLeave});

  @override
  State<ImageUploadDropzone> createState() => _ImageUploadDropzoneState();
}

class _ImageUploadDropzoneState extends State<ImageUploadDropzone> {
  late DropzoneViewController controller;

  Future filesDropped(List<dynamic>? events) async {
    if (events == null || events.isEmpty) return;
    final event = events.first;
    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final data = await controller.getFileData(event);
    widget.onDroppedFile(
        ImageDroppedFile(data: data, name: name, mime: mime, bytes: bytes));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DropzoneView(
          operation: DragOperation.copy,
          onCreated: (controller) => this.controller = controller,
          onDropFiles: filesDropped,
          onHover: () => widget.onHover(),
          onLeave: () => widget.onLeave()),
      Center(child: widget.child)
    ]);
  }
}
