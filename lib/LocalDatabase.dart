import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'SellPost.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB('sell_posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  
  Future _createDB(Database db, int version) async{
    await db.execute(''' 
    CREATE TABLE sell_posts 
    ( id INTEGER PRIMARY KEY AUTOINCREMENT, 
    model TEXT, year INTEGER, 
    price INTEGER, 
    description TEXT, 
    image TEXT ) ''');
  }

  Future<void> insertSellPost(SellPost post) async{
    final db = await instance.database;
    await db.insert('sell_posts', post.toMap());
  }

  Future<List<SellPost>> fetchSellPosts() async{
    final db = await instance.database;
    final result = await db.query('sell_posts');
    return result.map((json) => SellPost.fromMap(json)).toList();
  }

  Future<void> deleteSellPost(int id) async{
    final db = await instance.database;
    await db.delete('sell_posts', where: 'id = ?', whereArgs: [id]);
  }

}