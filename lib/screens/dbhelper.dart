// packages
import 'dart:io';
import 'package:path/path.dart';
// should install these

// refer description for more
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// the database helper class
class Databasehelper {
  // database name
  static final _databasename = "x28ffdh.db";
  static final databaseversion = 1;

  // the table name
  static final table1 = "my_table";
  // static final table2 = "pass_table";

  // column names
  static final columnID = 'id';
  static final columnType = "type";
  static final columnUser = "user";
  static final columnPass = 'pass';
  // static final masterpass = 'mpass';
  // a database
  static Database _database;

  // privateconstructor
  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

  // asking for a database
   Future<Database> get databse async {
    if (_database != null) return _database;

    // create a database if one doesn't exist
    _database = await _initDatabase();
    return _database;
  }

  // function to return a database
  static _initDatabase() async {
    Directory documentdirecoty = await getApplicationDocumentsDirectory();
    String path = join(documentdirecoty.path, _databasename);
    print(path);
    return await openDatabase(path,
        version: databaseversion, onCreate: _onCreate);
  }

  // create a database since it doesn't exist
  static Future _onCreate(Database db, int version) async {
    // sql code
    await db.execute('''
      CREATE TABLE $table1 (
        $columnID INTEGER PRIMARY KEY,
        $columnType TEXT NOT NULL,
        $columnUser TEXT NOT NULL,
        $columnPass TEXT NOT NULL
      )
      ''');

      // await db.execute('''
      // CREATE TABLE $table2 (
      //   $columnID INTEGER PRIMARY KEY,
      //   $masterpass TEXT NOT NULL,
      // )
      // ''');
  }

  // functions to insert data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.databse;
    return await db.insert(table1, row);
  }
//to insert master password
  // Future<int> insertmpass(Map<String, dynamic> row) async {
  //   Database db = await instance.databse;
  //   return await db.insert(table2, row);
  // }

  // function to query all the rows
  Future<List<Map<String, dynamic>>> queryall() async {
    Database db = await instance.databse;
    return await db.query(table1);
  }
  //for master password
// Future<List<Map<String, dynamic>>> mpassquery() async {
//     Database db = await instance.databse;
//     return await db.query(table2);
//   }


  // function to queryspecific
  Future<List<Map<String, dynamic>>> queryspecific(int age) async {
    Database db = await instance.databse;
    // var res = await db.query(table, where: "age < ?", whereArgs: [age]);
    var res = await db.rawQuery('SELECT * FROM my_table WHERE age >?', [age]);
    return res;
  }

  // function to delete some data
 Future<int> deletedata(int id) async {
    Database db = await instance.databse;
   await db.delete(table1, where: "id = ?", whereArgs: [id]);
    return 0;
  }

  
  // function to update some data
//   Future<int> update(int id) async {
//     Database db = await instance.databse;
//     var res = await db.update(table1, {"name": "Desi Programmer", "age": 2},
//         where: "id = ?", whereArgs: [id]);
//     return res;
//   }
}