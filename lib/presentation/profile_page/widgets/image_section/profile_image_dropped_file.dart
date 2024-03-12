// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class ProfileImageDroppedFile {
  final Uint8List data;
  final String name;
  final String mime;
  final int bytes;

  ProfileImageDroppedFile({
    required this.data,
    required this.name,
    required this.mime,
    required this.bytes,
  });
}
