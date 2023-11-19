import 'dart:async';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'example.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS fire_types (
            id TEXT PRIMARY KEY,
            nombre TEXT,
            descripcion TEXT,
            imageUrl TEXT,
            status TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS fire_reports (
            id TEXT PRIMARY KEY,
            fireTypeId TEXT,
            audioData TEXT,
            imageData TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertFireType(FireTypes fireType) async {
    Database db = await database;
    return await db.insert('fire_types', fireType.toJson());
  }

  Future<List<FireTypes>> getFireTypes() async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('fire_types');
    return results.map((map) => FireTypes.fromJson(map)).toList();
  }

  Future<int> insertFireReport({
    required String id,
    required String fireTypeId,
    String? audioData,
    String? imageData,
  }) async {
    Database db = await database;
    return await db.insert('fire_reports', {
      'id': id,
      'fireTypeId': fireTypeId,
      'audioData': audioData,
      'imageData': imageData,
    });
  }

  Future<List<Map<String, dynamic>>> getFireReports() async {
    Database db = await database;
    return await db.query('fire_reports');
  }

  Future<DateTime?> getLastModifiedTime() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'example.db');

    File dbFile = File(dbPath);

    if (await dbFile.exists()) {
      DateTime lastModified = await dbFile.lastModified();
      return lastModified;
    } else {
      return null;
    }
  }

  Future<int> updateFireType(FireTypes fireType) async {
    Database db = await database;

    return await db.update(
      'fire_types',
      fireType.toJson(),
      where: 'id = ?',
      whereArgs: [fireType.id],
    );
  }

  Future<int> updateFireReport({
    required String id,
    String? fireTypeId,
    String? audioData,
    String? imageData,
  }) async {
    Database db = await database;

    Map<String, dynamic> updateData = {};
    if (fireTypeId != null) {
      updateData['fireTypeId'] = fireTypeId;
    }
    if (audioData != null) {
      updateData['audioData'] = audioData;
    }
    if (imageData != null) {
      updateData['imageData'] = imageData;
    }

    return await db.update(
      'fire_reports',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
