import 'package:midprice/database/config/config_bo.dart';
import 'package:midprice/database/db_provider.dart';
import 'package:midprice/models/config/config.dart';
import 'package:path/path.dart';
import 'package:midprice/database/generic_repository.dart';

class ConfigRepository extends DBProvider implements GenericRepository<Config> {
  static final ConfigRepository instance = ConfigRepository._init();

  ConfigRepository._init();

  @override
  late String tableName = ConfigBO.tableName;

  @override
  Future<Config> get(int id) async {
    final db = await ConfigRepository.instance.database;
    final result = await db.query(tableName,
        where: '${ConfigBO.id} = ?', whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return Config.fromJson(result.first);
    } else {
      throw Exception('Config { id: $id } nof found');
    }
  }

  @override
  Future<List<Config>> list() async {
    final db = await ConfigRepository.instance.database;
    List result = await db.query(tableName);
    return result.map((json) => Config.fromJson(json)).toList();
  }

  @override
  Future<Config> create(Config config) async {
    throw Exception('Método não implementado');
  }

  @override
  Future<Config> update(Config config) async {
    try {
      final db = await ConfigRepository.instance.database;
      await db.update(tableName, Config.toJson(config),
          where: '${ConfigBO.id} = ?', whereArgs: [config.id]);
      return config;
    } catch (e) {
      throw Exception(
          'Erro ao atualizar a configuração do usuário: ${Config.toJson(config)}');
    }
  }

  @override
  Future<Config> delete(Config config) async {
    throw Exception('Método não implementado');
  }
}
