import 'package:english/db/models/lists.dart';
import 'package:english/db/models/words.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' ;

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

    // await addDefaultRecords();

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /*Future addDefaultRecords() async {
    //define word dict
    //insert dictionary with regular insert function
    //optional: define bulk insert functionü
    throw new Exception("not implemented");
  }*/
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE  IF NOT EXISTS $tableNameLists(
    ${ListsTableFields.id} $idType,
    ${ListsTableFields.name} $textType
    )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableNameWord (
      ${WordTableFields.id} $idType,
      ${WordTableFields.list_id} $integerType,
      ${WordTableFields.word_eng} $textType,
      ${WordTableFields.word_tr} $textType,
      ${WordTableFields.status} $boolType,
      FOREIGN KEY(${WordTableFields.list_id}) REFERENCES $tableNameLists (${ListsTableFields.id}))
      ''');
  }

  Future<Lists> insertList(Lists lists) async {
    final db = await instance.database;
    final id = await db.insert(tableNameLists, lists.toJson());

    return lists.copy(id: id);
  }

  Future<Word> insertWord(Word word) async {
    final db = await instance.database;
    final id = await db.insert(tableNameWord, word.toJson());
    return word.copy(id: id);
  }

  Future<List<Word>> readWordByList(int? listID) async {
    final db = await instance.database;
    const orderBy = '${WordTableFields.id} ASC';
    final result = await db.query(tableNameWord,
        orderBy: orderBy, where: '${WordTableFields.list_id}=?', whereArgs: [listID]);

    return result.map((json) => Word.fromJson(json)).toList();
  }

  Future<List<Map<String, Object?>>> readListAll() async {
    final db = await instance.database;
    List<Map<String, Object?>> res = [];
    List<Map<String, Object?>> lists = await db.rawQuery("SELECT id,name FROM lists");

    await Future.forEach(lists, (element) async {
      element = element as Map;
      var wordInfoByList = await db.rawQuery(
          "SELECT(SELECT COUNT(*) FROM words where list_id=${element['id']}) as sum_word,"
          "(SELECT COUNT(*) FROM words where status=0 and list_id=${element['id']}) as sum_unlearned");
      Map<String, Object?> temp = Map.of(wordInfoByList[0]);
      temp["name"] = element["name"];
      temp["list_id"] = element["id"];
      res.add(temp);
    });
    return res;
  }

  Future<List<Word>> readWordByLists(List<int> listsID, {bool? status}) async {
    final db = await instance.database;
    String idList = "";
    for (int i = 0; i < listsID.length; i++) {
      if (i == listsID.length - 1) {
        idList += (listsID[i].toString());
      } else {
        idList += ("${listsID[i]},");
      }
    }

    List<Map<String, Object?>> result;
    if (status != null) {
      result = await db.rawQuery(
          'SELECT * FROM words WHERE list_id IN($idList)and status=${status ? "1" : "0"}');
    } else {
      result = await db.rawQuery('SELECT * FROM words WHERE list_id IN($idList)');
    }

    return result.map((json) => Word.fromJson(json)).toList();
  }

  Future<int> updateWord(Word word) async {
    final db = await instance.database;
    return db.update(tableNameWord, word.toJson(),
        where: '${WordTableFields.id}=?', whereArgs: [word.id]);
  }

  Future<int> getCount() async {
    final db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from words');
    int count = Sqflite.firstIntValue(x) ?? 0;
    return count;
  }

  Future<int> getLearnCount() async {
    final db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from words where status=1');
    int learnedCount = Sqflite.firstIntValue(x) ?? 0;
    return learnedCount;
  }

  Future<int> updateList(Lists lists) async {
    final db = await instance.database;
    return db.update(tableNameLists, lists.toJson(),
        where: '${ListsTableFields.id}=?', whereArgs: [lists.id]);
  }

  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return db.delete(tableNameWord, where: '${WordTableFields.id}=?', whereArgs: [id]);
  }

  Future deleteTableWord(int id) async {
    final db = await instance.database;
    await db.delete(tableNameWord, where: '${WordTableFields.list_id}=?', whereArgs: [id]);
  }

  Future<int> markAslearned(bool mark, int id) async {
    final db = await instance.database;
    int result = mark == true ? 1 : 0;
    return db.update(tableNameWord, {WordTableFields.status: result},
        where: '${WordTableFields.id}=?', whereArgs: [id]);
  }

  Future<int> deleteListsAndWordByList(int id) async {
    final db = await instance.database;
    int result = await db
        .delete(tableNameLists, where: '${ListsTableFields.id}=?', whereArgs: [id]);
    if (result == 1) {
      await db
          .delete(tableNameWord, where: '${WordTableFields.list_id}=?', whereArgs: [id]);
    }
    return result;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
