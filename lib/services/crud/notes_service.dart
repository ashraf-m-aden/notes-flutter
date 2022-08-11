import 'package:flutter/cupertino.dart';
import 'package:notes/services/crud/db_service.dart';
import 'package:notes/services/crud/users_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import '../../constants/db-constants.dart';
import 'crud_exceptions.dart';

class NoteService {
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = DbService().getDbOrThrow();

// make sure user exist in the db
    final dbUser = await UserService().getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = 'Ceci est un test';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
    });

    final note = DatabaseNote(id: noteId, userId: owner.id, text: text);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = DbService().getDbOrThrow();

    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = DbService().getDbOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = DbService().getDbOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = DbService().getDbOrThrow();
    const text = "Ceci est une mise à jour";
    final updateCount = await db.update(noteTable, {textColumn: text});
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    return await getNote(id: note.id);
  }
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() {
    return 'Note, ID = $id , userId = $userId , text = $text';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
