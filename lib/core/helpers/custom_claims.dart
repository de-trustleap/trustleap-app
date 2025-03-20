import 'package:finanzbegleiter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomClaims {
  final FirebaseAuth auth;
  const CustomClaims({required this.auth});

  Future<Role> getUserCustomClaims() async {
    final user = FirebaseAuth.instance.currentUser!;
    final idTokenResult = await user.getIdTokenResult(true);
    final claims = idTokenResult.claims;
    if (claims != null) {
      final isAdmin = claims["admin"] ?? false;
      final isCompany = claims["company"] ?? false;
      if (isAdmin is bool && isAdmin) {
        return Role.admin;
      } else if (isCompany is bool && isCompany) {
        return Role.company;
      } else {
        return Role.promoter;
      }
    } else {
      return Role.promoter;
    }
  }
}
