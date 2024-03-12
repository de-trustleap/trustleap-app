// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepositoryImplementation implements ImageRepository {
  final FirebaseStorage firebaseStorage;

  ImageRepositoryImplementation({
    required this.firebaseStorage,
  });

  @override
  Future<Either<StorageFailure, String>> uploadImageForWeb(
      Uint8List image, String userID) async {
    final Reference refRoot = firebaseStorage.ref();
    final Reference userImagesRef =
        refRoot.child("profileImages/$userID/$userID");
    try {
      await userImagesRef.putData(image);
      final downloadURL = await userImagesRef.getDownloadURL();
      return right(downloadURL);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getStorageException(code: e.code));
    }
  }

  @override
  Future<Either<StorageFailure, String>> uploadImageForApp(
      File image, String userID) async {
    final Reference refRoot = firebaseStorage.ref();
    final Reference userImagesRef =
        refRoot.child("profileImages/$userID/$userID");
    try {
      await userImagesRef.putFile(File(image.path));
      final downloadURL = await userImagesRef.getDownloadURL();
      return right(downloadURL);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getStorageException(code: e.code));
    }
  }
}
