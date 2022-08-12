import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final User user;
  const AuthUser({required this.user});

  factory AuthUser.fromFirebase(User user) {
    if (user.emailVerified || !user.emailVerified) {
      return AuthUser(user: user);
    } else {
      return AuthUser(user: user);
    }
  }
}
