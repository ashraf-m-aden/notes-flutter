import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isAuth;

  const AuthUser(this.isAuth);

  factory AuthUser.fromFirebase(User user) {
    if (user.emailVerified || !user.emailVerified) {
      return const AuthUser(true);
    } else {
      return const AuthUser(false);
    }
  }
}
