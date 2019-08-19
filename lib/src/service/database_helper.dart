import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/service/logger.dart';

class DatabaseHelper {
  static final _databaseName = "konmari.db";
  static final _databaseVersion = 1;
  static final tableItem = 'item';
  static final tableUtility = 'utility';
  static final tableImage = 'image';
  static final tableUser = 'user';
  static final tableNote = 'note';
  static final tableCategory = 'category';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnStartTime = 'startTime';
  static const columnEndTime = 'endTime';
  static const columnCategory = 'category';
  static const columnImageUrl = 'imageUrl';
  static const columnLocalUrl = 'localUrl';
  static const columnItemUserId = 'userId'; // foreign key for user
  static const columnUtilityDate = 'date';
  static const columnUtilityUtility = 'utility';
  static const columnFireBaseId = 'firebaseId';
  static const columnItemId = 'itemId';
  static const columnNoteText = 'noteText';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  final log = getLogger('DatabaseHelper');

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();

    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    log.d('Initializing database...');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }
  //todo : add userid as row

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableItem (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnStartTime TEXT NOT NULL,
            $columnEndTime TEXT NOT NULL,
            $columnCategory TEXT,
            $columnItemUserId TEXT,
            $columnFireBaseId TEXT
          )
          ''');

    await db.execute('''
      CREATE TABLE $tableUtility (
        $columnId INTEGER PRIMARY KEY,
        $columnItemId INTEGER REFERENCES $tableItem,
        $columnUtilityDate TEXT NOT NULL,
        $columnUtilityUtility INTEGER NOT NULL
        )
       ''');

    await db.execute('''
      CREATE TABLE $tableImage (
        $columnId INTEGER PRIMARY KEY,
        $columnItemId INTEGER REFERENCES $tableItem,
        $columnName TEXT NOT NULL,
        $columnFireBaseId TEXT,
        $columnImageUrl TEXT NOT NULL,
        $columnLocalUrl TEXT NOT NULL
        )
       ''');

    await db.execute('''
      CREATE TABLE $tableNote (
        $columnId INTEGER PRIMARY KEY,
        $columnItemId INTEGER REFERENCES $tableItem,
        $columnNoteText TEXT NOT NULL,
        $columnUtilityDate TEXT
        )
       ''');

    await db.execute('''
      CREATE TABLE $tableCategory (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnFireBaseId TEXT
        )
       ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> query(String table, String column, int id) async {
    Database db = await instance.database;
    return await db.query(table, where: '$column = ?', whereArgs:  [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> exists(int id, String table, {String fbId}) async {
    Database db = await instance.database;
    var value = await db.rawQuery('''
      SELECT * FROM $table WHERE $columnId = $id
    ''');

    log.d('fbId: $fbId');
    if (fbId != null && fbId != "") {
      var value = await db.rawQuery('''
        SELECT * FROM $table WHERE $columnFireBaseId = $fbId
      ''');
      if (value != null && value.length > 0 && value[0] != null) {
        return true;
      } else {
        return false;
      }
    }

    if (value != null && value.length > 0 && value[0] != null) {
      return true;
    } else {
      return false;
    }
  }
}
