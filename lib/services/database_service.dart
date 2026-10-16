import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_center.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foodlink.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_centers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        address TEXT NOT NULL,
        phone TEXT,
        operatingHours TEXT,
        isAvailable INTEGER NOT NULL,
        eligibility TEXT,
        description TEXT,
        lastUpdated TEXT,
        isVerified INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE alerts (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        timestamp TEXT NOT NULL,
        isRead INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertFoodCenter(FoodCenter center) async {
    final db = await database;
    await db.insert(
      'food_centers',
      center.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodCenter>> getAllFoodCenters() async {
    final db = await database;
    final maps = await db.query('food_centers');
    return maps.map((map) => FoodCenter.fromMap(map)).toList();
  }

  Future<List<FoodCenter>> searchFoodCenters(String query) async {
    final db = await database;
    final maps = await db.query(
      'food_centers',
      where: 'name LIKE ? OR type LIKE ? OR address LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => FoodCenter.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
