import 'package:owlby_serene_m_i_n_d_s/record_feature/models/recording_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';
import '../models/note_model.dart';

class OwlbyDatabase {
  // Singleton instance
  static final OwlbyDatabase instance = OwlbyDatabase._init();
  static Database? _database;

  OwlbyDatabase._init();

  // Return existing DB or create a new one
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("owlby.db"); // SINGLE DATABASE
    return _database!;
  }

  // Initialize DB (create/open)
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create ALL tables here
  Future _createDB(Database db, int version) async {
    // TASKS TABLE
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');

    // NOTES TABLE
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // recording Table
    await db.execute('''
      CREATE TABLE recordings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path TEXT NOT NULL,
        title TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // -------------------------------------------------------
  // ✔ TASKS CRUD
  // -------------------------------------------------------

  Future<int> addTask(TaskModel task) async {
    final db = await instance.database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -------------------------------------------------------
  // ✔ NOTES CRUD
  // -------------------------------------------------------

  Future<int> addNote(NoteModel note) async {
    final db = await instance.database;
    return db.insert('notes', note.toMap());
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      orderBy: 'id DESC',
    );
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // RECORDING METHODS

  // add recording

  Future<int> insert(RecordingModel model) async {
    final db = await database;
    return await db.insert('recordings', model.toMap());
  }

// fetchh recordings
  Future<List<RecordingModel>> fetch() async {
    final db = await database;
    final result = await db.query('recordings', orderBy: "id DESC");
    return result.map((e) => RecordingModel.fromMap(e)).toList();
  }
  //delete recording

  Future<int> deleteRecording(int id) async {
    final db = await database;
    return await db.delete(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
