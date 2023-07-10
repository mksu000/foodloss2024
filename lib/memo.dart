import 'package:sqflite/sqflite.dart';

class FoodModel {
  static const String tableFoods = 'foods';
  static const String tableCat = 'Cat';
  static const String columnId = 'id';
  static const String columnContent = 'content';
  static const String columcat = 'cat';

  late Database _database;

  Future<void> init() async {
    _database = await openDatabase(
      'foodloss２.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableFoods (
            $columnId TEXT PRIMARY KEY,
            $columcat TEXT,
            $columnContent TEXT NOT NULL
          )

          ''');

        await db.execute('''
           CREATE TABLE $tableCat (
            category TEXT PRIMARY KEY
          )
          ''');

        await db.execute('''
          INSERT INTO $tableCat (category) VALUES
             ('肉・肉加工品'), 
             ('水産物'), 
             ('野菜'), 
             ('果物'), 
             ('スイーツ')
         ''');
        

      },
    );
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    return _database.query(tableFoods);
  }

  Future<List<Map<String, dynamic>>> getCats() async {
    return _database.query(tableCat);
  }

  Future<void> addFood(String id, String content, String selectedCat) async {
    await _database.insert(
      tableFoods,
      {
        columnId: id,
        columnContent: content,
        columcat:selectedCat,
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