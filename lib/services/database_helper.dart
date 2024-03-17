import 'package:crystal_tarea_siete/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Grocery.db";
  static DatabaseHelper? _instance;

  DatabaseHelper._(); // Constructor privado para evitar instanciación directa

  static DatabaseHelper getInstance() {
    _instance ??= DatabaseHelper._(); // Inicialización perezosa de la instancia
    return _instance!;
  }

  Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async =>
        await db.execute(
            "CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, amount INTEGER NOT NULL);"),
        version: _version);
  }

  //metodo para agregar productos
  static Future<int> insertProduct(Product product) async {
    final db = await getInstance()._getDB();
    return await db.insert("Products", product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //metodo para editar productos
  static Future<int> updateProduct(Product product) async {
    final db = await getInstance()._getDB();
    return await db.update("Products", product.toJson(),
        where: 'id = ?',
        whereArgs: [product.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //metodo para eliminar productos
  static Future<int> deleteProduct(Product product) async {
    final db = await getInstance()._getDB();
    return await db.delete("Products",
        where: 'id = ?',
        whereArgs: [product.id],);
  }

  static Future<List<Product>?> getAllProduct() async {
    final db = await getInstance()._getDB();

    final List<Map<String, dynamic>> maps = await db.query("Products");

    if(maps.isEmpty){
      return null;
    }

    return List.generate(maps.length, (index) => Product.fromJson(maps[index]));
  }
}