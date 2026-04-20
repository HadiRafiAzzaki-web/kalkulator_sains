import 'package:kalkulator_sains/logics/logic.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'listrik.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          jumlah REAL,
          watt REAL,
          waktu REAL,
          tarif REAL,
          hasil REAL
        )
        ''');
      },
    );
  }

  static Future<void> insert(Logic data) async {
    final database = await db;
    await database.insert('history', data.toMap());
  }

  static Future<List<Logic>> getAll() async {
    final database = await db;
    final result = await database.query('history', orderBy: 'id DESC');
    return result.map((e) => Logic.fromMap(e)).toList();
  }

  static Future<void> delete(int id) async {
    final database = await db;
    await database.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clear() async {
    final database = await db;
    await database.delete('history');
  }
}
