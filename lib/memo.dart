import 'package:sqflite/sqflite.dart';

class FoodModel {
  static const String tableFoods = 'foods';
  static const String columnId = 'id';
  static const String columnContent = 'content';
  static const String? columcat = 'cat';

  late Database _database;

  Future<void> init() async {
    _database = await openDatabase(
      'foodloss.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableFoods (
            $columnId TEXT PRIMARY KEY,
            $columcat TEXT,
            $columnContent TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    return _database.query(tableFoods);
  }

  Future<void> addFood(String id, String content) async {
    await _database.insert(
      tableFoods,
      {
        columnId: id,
        columnContent: content,
      },
    );
  }

  Future<void> updateFood(String id, String content) async {
    await _database.update(
      tableFoods,
      {
        columnContent: content,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFood(String id) async {
    await _database.delete(
      tableFoods,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}