import 'package:flutter/cupertino.dart';

import '../../constants/db-constants.dart';
import 'crud_exceptions.dart';
import 'db_service.dart';

class UserService {
  final DbService _dbService = DbService();
  UserService._sharedInstance();

  static final UserService _shared = UserService._sharedInstance();
  factory UserService() => _shared;

  Future<void> deleteUser({required String email}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();

    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> getUser({required String? email}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email?.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<Iterable<DatabaseUser>> getAllUser() async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();
    final users = await db.query(userTable);
    return users.map((userRow) => DatabaseUser.fromRow(userRow));
  }

  Future<DatabaseUser> createUser({required String? email}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email?.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }
    final userId =
        await db.insert(userTable, {emailColumn: email?.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getOrCreateUser({required String? email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String? email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  @override
  String toString() {
    return 'Person, ID = $id , email = $email';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
