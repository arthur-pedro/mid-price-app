import 'package:midpriceapp/database/generic_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Repository<T> implements GenericRepository<T> {
  static final Repository instance = Repository._init();

  Repository._init();

  Repository(
      {required this.dbName, required this.tableName, required this.script}) {
    initRepository();
  }

  @override
  Database? db;

  @override
  late String dbName;

  @override
  late String tableName;

  @override
  late String script;

  @override
  Future initRepository() async {
    await list();
  }

  @override
  Future createDB(db, version) async {
    await db.execute(script);
  }

  @override
  Future close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future close() async {
    final db = await instance.database;
    if (db.isOpen) {
      db.close();
    }
  }

  @override
  Future<T> get(int id) async {
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
  Future<List<T>> list() async {
    final db = await AssetRepository.instance.database;
    List result = await db.query(tableName, orderBy: '${AssetBO.name} ASC');
    return result.map((json) => Asset.fromJson(json)).toList();
  }

  @override
  Future<T> create(T entity) async {
    final db = await AssetRepository.instance.database;
    await db.insert(
      tableName,
      Asset.toJson(entity),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entity;
  }

  @override
  Future<T> update(T entity) async {
    try {
      final db = await AssetRepository.instance.database;
      await db.update(tableName, Asset.toJson(entity),
          where: '${AssetBO.id} = ?', whereArgs: [entity.id]);
      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar o ativo: ${Asset.toJson(entity)}');
    }
  }

  @override
  Future<T> delete(T entity) async {
    final db = await AssetRepository.instance.database;
    await db
        .delete(tableName, where: '${AssetBO.id} = ?', whereArgs: [entity.id]);
    return entity;
  }
}
