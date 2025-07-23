import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  // Compresses images to reduce file size before uploading
  static Future<List<Uint8List>> compressImages(
    List<Uint8List> images, {
    int quality = 70,
    int minWidth = 1024,
    int minHeight = 1024,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    if (images.isEmpty) return images;

    final compressedImages = <Uint8List>[];

    for (final imageData in images) {
      try {
        final compressedImage = await _compressSingleImage(
          imageData,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
          format: format,
        );
        compressedImages.add(compressedImage ?? imageData);
      } catch (e) {
        // If compression fails, use original image
        compressedImages.add(imageData);
      }
    }

    return compressedImages;
  }

  static Future<Uint8List?> _compressSingleImage(
    Uint8List imageData, {
    required int quality,
    required int minWidth,
    required int minHeight,
    required CompressFormat format,
  }) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithList(
        imageData,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: format,
        keepExif: false,
      );

      return compressedImage;
    } catch (e) {
      return null;
    }
  }

  static double getCompressionRatio(Uint8List original, Uint8List compressed) {
    if (original.isEmpty) return 1.0;
    return compressed.length / original.length;
  }

  static String getHumanReadableSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
