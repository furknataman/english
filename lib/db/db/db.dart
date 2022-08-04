import 'package:english/db/models/lists.dart';
import 'package:english/db/models/words.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  //Singleton
  static final DB instance = DB._init();
  static Database? _database;

  DB._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quezy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int versiom) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINTCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE  IF NOT EXISTS $tableNameLists(
  ${ListsTableFields.id} $idType,
  ${ListsTableFields.name} $textType,
)
''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS $tableNameWord (
${WordTableFields.id} $idType,
${WordTableFields.list_id} $integerType,
${WordTableFields.word_eng} $textType,
${WordTableFields.word_tr} $textType,
${WordTableFields.status} $boolType,
FOREIGN KEY(${WordTableFields.list_id} REFERENCES $tableNameLists (${ListsTableFields.id}))
''');
  }
}
