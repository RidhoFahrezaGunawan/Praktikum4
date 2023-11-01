import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/user.dart';  // Make sure the Saham model is defined in this path

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE sahamku("
              "tickerid INTEGER PRIMARY KEY AUTOINCREMENT, "
              "ticker TEXT NOT NULL,"
              "open INTEGER,"
              "high INTEGER,"
              "last INTEGER,"
              "change TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertSahamku(dynamic sahamin) async {
    int result = 0;
    final Database db = await initializeDB();

    if (sahamin is Sahamku) {
      return await db.insert('saham', sahamin.toMap());
    } else if (sahamin is List<Sahamku>) {
      for (var Sahamku in sahamin) {
        result = await db.insert('saham', Sahamku.toMap());
      }
      return result;
    } else {
      throw ArgumentError('Expected either a Saham or List<Saham> argument');
    }
  }

  Future<List<Sahamku>> retrievesahamin() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('sahamku');
    return queryResult.map((e) => Sahamku.fromMap(e)).toList();
  }
}