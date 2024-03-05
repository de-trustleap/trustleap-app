import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/core/errors/errors.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

extension FirestoreExtension on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = Modular.get<AuthRepository>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance.collection("users").doc(user.id.value);
  }
}
