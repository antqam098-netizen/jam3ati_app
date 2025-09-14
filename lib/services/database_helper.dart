import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lecture_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDB('lectures.db');
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lectures(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        doctorName TEXT,
        startTime TEXT NOT NULL,
        location TEXT NOT NULL,
        day TEXT NOT NULL
      )
    ''');
  }

  Future<int> createLecture(Lecture lecture) async {
    final db = await instance.database;
    return await db.insert('lectures', lecture.toMap());
  }

  Future<List<Lecture>> getLectures() async {
    final db = await instance.database;
    final result = await db.query('lectures', orderBy: 'id');
    return result.map((map) => Lecture.fromMap(map)).toList();
  }

  Future<List<Lecture>> getLecturesByDay(String day) async {
    final db = await instance.database;
    final result = await db.query('lectures', where: 'day = ?', whereArgs: [day]);
    return result.map((map) => Lecture.fromMap(map)).toList();
  }

  Future<int> updateLecture(Lecture lecture) async {
    final db = await instance.database;
    return await db.update('lectures', lecture.toMap(), where: 'id = ?', whereArgs: [lecture.id]);
  }

  Future<int> deleteLecture(int id) async {
    final db = await instance.database;
    return await db.delete('lectures', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Lecture>> searchLectures(String query) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT * FROM lectures 
      WHERE name LIKE ? OR doctorName LIKE ? OR location LIKE ? OR type LIKE ?
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);
    return result.map((map) => Lecture.fromMap(map)).toList();
  }
}