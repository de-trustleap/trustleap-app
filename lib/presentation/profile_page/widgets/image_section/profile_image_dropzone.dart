// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/profile_page/widgets/image_section/profile_image_dropped_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class ImageUploadDropzone extends StatefulWidget {
  final Widget child;
  final ValueChanged<ProfileImageDroppedFile> onDroppedFile;
  final ValueChanged<List<ProfileImageDroppedFile>> onDroppedMultipleFiles;
  final Function onHover;
  final Function onLeave;

  const ImageUploadDropzone(
      {Key? key,
      required this.child,
      required this.onDroppedFile,
      required this.onDroppedMultipleFiles,
      required this.onHover,
      required this.onLeave})
      : super(key: key);

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
    final droppedFile = ProfileImageDroppedFile(
        data: data, name: name, mime: mime, bytes: bytes);
    widget.onDroppedFile(droppedFile);
  }

  Future multipleFilesDropped(List<dynamic>? events) async {
    if (events != null) {
      final List<ProfileImageDroppedFile> fileList = [];
      for (var event in events) {
        final name = event.name;
        final mime = await controller.getFileMIME(event);
        final bytes = await controller.getFileSize(event);
        final data = await controller.getFileData(event);

        final droppedFile = ProfileImageDroppedFile(
            data: data, name: name, mime: mime, bytes: bytes);
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
          onDrop: fileDropped,
          onDropMultiple: multipleFilesDropped,
          onHover: hovered,
          onLeave: leaved),
      Center(child: widget.child)
    ]);
  }
}
