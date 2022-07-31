import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:midpriceapp/database/asset/asset_bo.dart';
import 'package:midpriceapp/database/generic_repository.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:sqflite/sqflite.dart';

class AssetRepository implements GenericRepository<Asset> {
  static final AssetRepository instance = AssetRepository._init();

  AssetRepository._init();

  AssetRepository() {
    initRepository();
  }

  @override
  Database? db;

  @override
  late String tableName = 'wallet';

  @override
  late String dbName = 'wallet';

  @override
  late String script = '''
    CREATE TABLE IF NOT EXISTS wallet (
      ${AssetBO.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      ${AssetBO.name} TEXT NOT NULL,
      ${AssetBO.price} TEXT NOT NULL,
      ${AssetBO.category} TEXT NOT NULL
    );
  ''';
  @override
  Future initRepository() async {
    await list();
  }

  @override
  Future createDB(db, version) async {
    await db.execute(script);
  }

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDatabase(tableName)!;
    return db!;
  }

  _initDatabase(String dbName) async {
    return await openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, onCreate: createDB);
  }

  @override
  Future close() async {
    final db = await instance.database;
    if (db.isOpen) {
      db.close();
    }
  }

  @override
  Future<Asset> get(int id) async {
    final db = await AssetRepository.instance.database;
    final result = await db.query(tableName,
        where: '${AssetBO.id} = ?', whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return Asset.fromJson(result.first);
    } else {
      throw Exception('Asset { id: $id } nof found');
    }
  }

  @override
  Future<List<Asset>> list() async {
    final db = await AssetRepository.instance.database;
    List result = await db.query(tableName, orderBy: '${AssetBO.name} ASC');
    return result.map((json) => Asset.fromJson(json)).toList();
  }

  @override
  Future<Asset> create(Asset asset) async {
    final db = await AssetRepository.instance.database;
    await db.insert(
      tableName,
      Asset.toJson(asset),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return asset;
  }

  @override
  Future<Asset> update(Asset asset) async {
    try {
      final db = await AssetRepository.instance.database;
      await db.update(tableName, Asset.toJson(asset),
          where: '${AssetBO.id} = ?', whereArgs: [asset.id]);
      return asset;
    } catch (e) {
      throw Exception('Erro ao atualizar o ativo: ${Asset.toJson(asset)}');
    }
  }

  @override
  Future<Asset> delete(Asset asset) async {
    final db = await AssetRepository.instance.database;
    await db
        .delete(tableName, where: '${AssetBO.id} = ?', whereArgs: [asset.id]);
    return asset;
  }
}
