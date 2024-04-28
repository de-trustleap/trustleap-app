import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:flutter/foundation.dart';

abstract class ImageRepository {
  Future<Either<StorageFailure, String>> uploadImageForWeb(
      Uint8List image, String id, ImageUploader uploader);
  Future<Either<StorageFailure, String>> uploadImageForApp(
      File image, String id, ImageUploader uploader);
}
