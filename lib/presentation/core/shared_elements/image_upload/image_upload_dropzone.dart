// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/shared_elements/image_upload/image_dropped_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class ImageUploadDropzone extends StatefulWidget {
  final Widget child;
  final ValueChanged<ImageDroppedFile> onDroppedFile;
  final ValueChanged<List<ImageDroppedFile>> onDroppedMultipleFiles;
  final Function onHover;
  final Function onLeave;

  const ImageUploadDropzone(
      {super.key,
      required this.child,
      required this.onDroppedFile,
      required this.onDroppedMultipleFiles,
      required this.onHover,
      required this.onLeave});

  @override
  State<ImageUploadDropzone> createState() => _ImageUploadDropzoneState();
}

class _ImageUploadDropzoneState extends State<ImageUploadDropzone> {
  late DropzoneViewController controller;

  Future fileDropped(dynamic event) async {
    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final data = await controller.getFileData(event);
    final droppedFile =
        ImageDroppedFile(data: data, name: name, mime: mime, bytes: bytes);
    widget.onDroppedFile(droppedFile);
  }

  Future multipleFilesDropped(List<dynamic>? events) async {
    if (events != null) {
      final List<ImageDroppedFile> fileList = [];
      for (var event in events) {
        final name = event.name;
        final mime = await controller.getFileMIME(event);
        final bytes = await controller.getFileSize(event);
        final data = await controller.getFileData(event);

        final droppedFile =
            ImageDroppedFile(data: data, name: name, mime: mime, bytes: bytes);
        fileList.add(droppedFile);
      }
      widget.onDroppedMultipleFiles(fileList);
    }
  }

  Future hovered() async {
    widget.onHover();
  }

  Future leaved() async {
    widget.onLeave();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DropzoneView(
          operation: DragOperation.copy,
          onCreated: (controller) => this.controller = controller,
          onDropFile: fileDropped,
          onDropFiles: multipleFilesDropped,
          onHover: hovered,
          onLeave: leaved),
      Center(child: widget.child)
    ]);
  }
}
