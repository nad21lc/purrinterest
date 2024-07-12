import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:purrinterest/models/cat.dart';

//This class is to manage the database
class DbHelper{
  static int version = 1;
  static String databaseName = "cats3.db";
  static String tableName = 'cats';
  static Database? db;

  //This is to open only one instance of the database
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return _dbHelper;
  }

  //Open database
  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), databaseName),
        onCreate: (db, version){
          db.execute('CREATE TABLE $tableName ('
              'id TEXT PRIMARY KEY, '
              'name TEXT, '
              'temperament TEXT, '
              'intelligence INTEGER, '
              'reference_image_id TEXT)');
        }, version: version);
    return db!;
  }

  //CRUD
  //Insert and Update
  Future<int> insertCat(Cat cat) async {
    int id = await db!.insert(tableName, cat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //delete
  Future<int> deleteCat(Cat cat) async {
    int result = await db!.delete(tableName, where: 'id = ?', whereArgs: [cat.id]);
    return result;
  }

  // Verify if the cat is favorite
  Future<bool> isFavorite(Cat cat) async {
    final List<Map<String, dynamic>> maps = await db!.query(tableName, where: 'id = ?', whereArgs: [cat.id]);
    return maps.isNotEmpty;
  }

  // Fetch all favorite cats
  Future<List<Cat>> fetchFavorites() async {
    final List<Map<String, dynamic>> maps = await db!.query(tableName);
    return maps.map((map) => Cat.fromMap(map)).toList();
  }
}