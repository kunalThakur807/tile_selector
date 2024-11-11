import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tile.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tiles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, filePath),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tiles (
            id INTEGER PRIMARY KEY,
            name TEXT,
            color TEXT,
            usage TEXT,
            image_url TEXT
          )
        ''');
        // Insert sample data
        await db.insert(
            'tiles',
            Tile(
                    name: 'ABCD Tile - Black',
                    color: 'black',
                    usage: 'commercial',
                    imageUrl: 'assets/black_tile.jpg')
                .toMap());
        await db.insert(
            'tiles',
            Tile(
                    name: 'ABCD Tile - White',
                    color: 'white',
                    usage: 'home',
                    imageUrl: 'assets/white_tile.jpg')
                .toMap());
      },
      version: 1,
    );
  }

  Future<List<Tile>> getTilesByNames(List<String> names) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tiles',
      where: 'name IN (${names.map((_) => '?').join(', ')})',
      whereArgs: names,
    );
    return maps.map((tileMap) => Tile.fromMap(tileMap)).toList();
  }

  Future<List<Tile>> getSuggestedTiles(String color, String usage) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tiles',
      where: 'color = ? AND usage = ?',
      whereArgs: [color, usage],
    );
    return maps.map((tileMap) => Tile.fromMap(tileMap)).toList();
  }
}
