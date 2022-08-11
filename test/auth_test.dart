import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? user;
  var _isInitialized = false;
  bool get isInitialize => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialize) {
      throw NotInitializeException();
    } else {
      await Future.delayed(const Duration(milliseconds: 2000));
      return login(email: email, password: password);
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (!isInitialize) {
      throw NotInitializeException();
    } else {
      await Future.delayed(const Duration(milliseconds: 2000));
      return login(email: email, password: password);
    }
  }
}
