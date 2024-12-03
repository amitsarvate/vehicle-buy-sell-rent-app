import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'SellPost.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sell_posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, //needed to create new version of database after userId was added
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE sell_posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      make TEXT,
      model TEXT,
      year INTEGER,
      price INTEGER,
      description TEXT,
      image TEXT,
      userId TEXT NULL
    )
    ''');
  }

  //upgraded database to support the changes of making userId NULL
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sell_posts ADD COLUMN userId TEXT NULL');
    }
  }

  Future<void> insertSellPost(SellPost post) async {
    final db = await instance.database;
    await db.insert('sell_posts', post.toMap());
  }

  Future<List<SellPost>> fetchSellPosts() async {
    final db = await instance.database;
    final result = await db.query('sell_posts');
    return result.map((json) => SellPost.fromMap(json)).toList();
  }

  Future<void> deleteSellPost(int id) async {
    final db = await instance.database;
    await db.delete('sell_posts', where: 'id = ?', whereArgs: [id]);
  }
}
