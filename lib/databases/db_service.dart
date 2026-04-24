import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../logics/logic.dart';

class DbService {
  static Database? db;

  static Future<Database> init() async {
    if (db != null) return db!;

    db = await openDatabase(
      join(await getDatabasesPath(), 'listrik.db'),
      onCreate: (database, version) {
        return database.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jumlah REAL,
            watt REAL,
            waktu REAL,
            tarif REAL,
            hasil REAL,
            kwh REAL
          )
        ''');
      },
      version: 1,
    );

    return db!;
  }

  static Future<void> insert(Logic data) async {
    final database = await init();
    await database.insert('history', data.toMap());
  }

  static Future<List<Logic>> getAll() async {
    final database = await init();
    final result = await database.query('history', orderBy: 'id DESC');
    return result.map((e) => Logic.fromMap(e)).toList();
  }

  static Future<void> delete(int id) async {
    final database = await init();
    await database.delete('history', where: 'id=?', whereArgs: [id]);
  }

  static Future<void> clear() async {
    final database = await init();
    await database.delete('history');
  }
}
