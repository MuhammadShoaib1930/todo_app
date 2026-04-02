import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteService {
  SqlfliteService._();
  static final SqlfliteService _instance = SqlfliteService._();
  factory SqlfliteService() => _instance;

  Database? db;
  final String databaseName = "note_data.db";
  final String databaseTable = "tasks";
  final String databaseC1 = "SN";
  final String databaseC2 = "Title";
  final String databaseC3 = "Description";
  final String databaseC4 = "workDone";
  final String dateTimeC5 = "dateTime";
  Future<Database> getdb() async {
    return db ?? await openDB();
  }

  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/$databaseName";
    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          "Create table $databaseTable($databaseC1 INTEGER PRIMARY KEY AUTOINCREMENT , $databaseC2 text, $databaseC3 text,$databaseC4 INTEGER,$dateTimeC5 text)",
        );
      },
      version: 01,
    );
  }

  void add(String title, description) async {
    db ??= await getdb();

    db?.insert(databaseTable, {
      databaseC2: title,
      databaseC3: description,
      databaseC4: false,
      dateTimeC5: DateTime.now().toString().replaceRange(15, 25, ''),
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    db ??= await getdb();
    return await db?.query(databaseTable) ?? [];
  }

  void delete(int sn) async {
    db ?? await getdb();
    await db?.delete(databaseTable, where: '$databaseC1 = ?', whereArgs: [sn]);
  }

  void update(int sn, String title, String description, int isTrue) async {
    db ?? await getdb();
    await db?.update(
      databaseTable,
      {
        databaseC2: title,
        databaseC3: description,
        databaseC4: isTrue,
        dateTimeC5: DateTime.now().toString().replaceRange(15, 25, ''),
      },
      where: '$databaseC1 = ?',
      whereArgs: [sn],
    );
  }
}
