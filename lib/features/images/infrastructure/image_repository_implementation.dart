// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/images/domain/image_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepositoryImplementation implements ImageRepository {
  final FirebaseStorage firebaseStorage;

  ImageRepositoryImplementation({
    required this.firebaseStorage,
  });

  @override
  Future<Either<StorageFailure, String>> uploadImageForWeb(
      Uint8List image, String id, ImageUploader uploader) async {
    final Reference refRoot = firebaseStorage.ref();
    Reference imageRef;
    switch (uploader) {
      case ImageUploader.user:
        imageRef = refRoot.child("profileImages/$id/$id");
        break;
      case ImageUploader.company:
        imageRef = refRoot.child("companyImages/$id/$id");
        break;
      case ImageUploader.landingPage:
        imageRef = refRoot.child("landingPageImages/$id/$id");
    }
    try {
      await imageRef.putData(image);
      final downloadURL = await imageRef.getDownloadURL();
      return right(downloadURL);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getStorageException(code: e.code));
    }
  }

  @override
  Future<Either<StorageFailure, String>> uploadImageForApp(
      File image, String id, ImageUploader uploader) async {
    final Reference refRoot = firebaseStorage.ref();
    final Reference userImagesRef = refRoot.child("profileImages/$id/$id");
    try {
      await userImagesRef.putFile(File(image.path));
      final downloadURL = await userImagesRef.getDownloadURL();
      return right(downloadURL);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getStorageException(code: e.code));
    }
  }
}
