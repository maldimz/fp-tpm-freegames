import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "appGames.db";
  static final _databaseVersion = 1;

  DatabaseHelper._internal();
  static final DatabaseHelper databaseHelper = DatabaseHelper._internal();
  static DatabaseHelper get instance => databaseHelper;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Reviews(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        review TEXT,
        FOREIGN KEY (userId) REFERENCES User (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Games(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        gamesId,
        title TEXT,
        thumbnail TEXT,
        shortDescription TEXT,
        gameUrl TEXT,
        genre TEXT,
        platform TEXT,
        publisher TEXT,
        developer TEXT,
        releaseDate TEXT,
        freetogameProfileUrl TEXT,
        FOREIGN KEY (userId) REFERENCES User (id)
      )
    ''');
  }
}
