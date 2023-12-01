import 'dart:async';
import 'dart:math';
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
}

// import 'dart:convert';
// import 'dart:math';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

class ReportRequest {
  String id;
  String hash;
  String usuario;
  String tipoIncendio;
  String lon;
  String lat;
  String audio;
  String imagenes;
  String part;

  ReportRequest({
    required this.id,
    required this.hash,
    required this.usuario,
    required this.tipoIncendio,
    required this.lon,
    required this.lat,
    required this.audio,
    required this.imagenes,
    required this.part,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hash': hash,
      'usuario': usuario,
      'tipoIncendio': tipoIncendio,
      'lon': lon,
      'lat': lat,
      'audio': audio,
      'imagenes': imagenes,
      'part': part,
    };
  }

  factory ReportRequest.fromMap(Map<String, dynamic> map) {
    return ReportRequest(
      id: map['id'],
      hash: map['hash'],
      usuario: map['usuario'],
      tipoIncendio: map['tipoIncendio'],
      lon: map['lon'],
      lat: map['lat'],
      audio: map['audio'],
      imagenes: map['imagenes'],
      part: map['part'],
    );
  }
}

class ReportRequestDataBase {
  static final ReportRequestDataBase instance =
      ReportRequestDataBase._privateConstructor();
  static Database? _database;

  ReportRequestDataBase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'report_database.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports(
        id TEXT PRIMARY KEY,
        hash TEXT,
        usuario TEXT,
        tipoIncendio TEXT,
        lon TEXT,
        lat TEXT,
        audio TEXT,
        imagenes TEXT,
        part TEXT
      )
    ''');
  }

  Future<void> insertReport(ReportRequest report) async {
    Database db = await instance.database;
    await db.insert('reports', report.toMap());
  }

  Future<void> deleteReport(String id) async {
    Database db = await instance.database;
    await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }

  Future<ReportRequest?> getOldestReport() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'reports',
      orderBy: 'id ASC',
      limit: 1,
    );
    return result.isNotEmpty ? ReportRequest.fromMap(result.first) : null;
  }

  Future<void> updateReport(ReportRequest report) async {
    Database db = await instance.database;
    await db.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }
}
