import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/db-constants.dart';
import 'crud_exceptions.dart';

class DbService {
  Database? database;

  Database getDbOrThrow() {
    final db = database;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = database;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      database = null;
    }
  }

  Future<void> open() async {
    if (database != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      database = db;

// create user table and note table
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }
}
