import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
        CREATE TABLE data(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          cap TEXT,
          desc TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'my_database.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print('creating table');
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String cap, String? desc) async {
    final db = await SQLHelper.db();
    final data = {'cap': cap, 'desc': desc};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String cap, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'cap': cap,
      'desc': desc,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('data', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
