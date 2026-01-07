import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_model.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/models/recording_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';
import '../models/note_model.dart';

class OwlbyDatabase {
  // 1   // Singleton instance  // static means the thing belongs to the class not the object of the class
  static final OwlbyDatabase instance = OwlbyDatabase._init();
  static Database? _database;

  OwlbyDatabase._init();
//3 //
  // Return existing DB or create a new one
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("owlby.db"); // SINGLE DATABASE
    return _database!;
  }

// 2//
  // Initialize DB (create/open) // creating database its the second step // first is to make database singleton
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE recordings ADD COLUMN backend_session_id TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE recordings ADD COLUMN user_id TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('''
      CREATE TABLE IF NOT EXISTS appuser (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        organization_name TEXT,
        subscription INTEGER NOT NULL DEFAULT 0,
        sessions INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        phone TEXT,
        full_name TEXT,
        referred_by TEXT,
        referral_code TEXT
      )
    ''');
        }
      },
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
// recording database table
    await db.execute('''
      CREATE TABLE recordings(
  id TEXT PRIMARY KEY,
  file_path TEXT NOT NULL,
  title TEXT,
  created_at TEXT NOT NULL,
  backend_session_id TEXT,
  user_id TEXT,                     
  status TEXT NOT NULL DEFAULT 'local',
   meeting_id TEXT,
  summary TEXT,
  sentiment TEXT,
  keywords TEXT,
  duration TEXT,
  notes TEXT,
  audio_url TEXT
)
''');
    await db.execute('''
CREATE TABLE appuser (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  organization_name TEXT,
  subscription INTEGER NOT NULL DEFAULT 0,
  sessions INTEGER DEFAULT 0,
  created_at TEXT,
  updated_at TEXT,
  phone TEXT,
  full_name TEXT,
  referred_by TEXT,
  referral_code TEXT
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

  // CRUD for RecordingModel ////////////////////////////////////////////////////////////////////////////////
  // ------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
// inserting recording to local database
  Future<int> insertRecording(RecordingModel recording) async {
    final db = await database;
    return await db.insert(
      'recordings',
      recording.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// fetching recordings from local database
  Future<List<RecordingModel>> fetchRecordings() async {
    final db = await database;
    final maps = await db.query(
      'recordings',
      orderBy: 'datetime(created_at) DESC',
    );

    return maps.map((m) => RecordingModel.fromMap(m)).toList();
  }
  //delete recording from local database

  Future<int> deleteRecording(String id) async {
    final db = await database;
    return await db.delete(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// update recording status like local , progress , done etc
  Future<int> updateRecordingStatus(String id, String status) async {
    final db = await database;
    return await db.update(
      'recordings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// update recording details like session id and status - progress
  Future<int> updateRecordingBackend(
    String id, {
    required String backendsessionId,
    required String status,
  }) async {
    final db = await database;
    return await db.update(
      'recordings',
      {
        'backend_session_id': backendsessionId,
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// update recording details which fetched from backend after process successfull
  Future<int> updateProcessedRecording(
    String id, {
    String? summary,
    String? sentiment,
    String? keywords,
    int? duration,
    String? notes,
    String? audioUrl,
    required String status,
  }) async {
    final db = await database;
    return await db.update(
      'recordings',
      {
        'summary': summary,
        'sentiment': sentiment,
        'keywords': keywords,
        'duration': duration,
        'notes': notes,
        'status': status,
        'audio_url': audioUrl,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

///// getting single recoding details as per its id
  Future<RecordingModel> getRecordingById(String id) async {
    final db = await database;
    final maps = await db.query(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Recording not found for id $id');
    }

    return RecordingModel.fromMap(maps.first);
  }
//////////////////////////////
// crud for user//////////////
//////////////////////////////

  Future<void> saveUser(AppUserModel user) async {
    final db = await database;
    await db.insert(
      'appuser',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AppUserModel?> getUser() async {
    final db = await database;
    final result = await db.query('appuser', limit: 1);

    if (result.isNotEmpty) {
      return AppUserModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteUser() async {
    final db = await database;
    return await db.delete('appuser');
  }

  Future<bool> isUserLoggedIn() async {
    final db = await database;
    final result = await db.query('appuser', limit: 1);
    return result.isNotEmpty;
  }
}
