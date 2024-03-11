import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:flutter/foundation.dart';

abstract class ImageRepository {
  Future<Either<StorageFailure, String>> uploadImageForWeb(
      Uint8List image, String userID);
  Future<Either<StorageFailure, String>> uploadImageForApp(
      File image, String userID);
}
