import 'dart:developer';

import 'package:midprice/database/asset/asset_bo.dart';
import 'package:midprice/database/db_provider.dart';
import 'package:midprice/database/deposit/deposit_bo.dart';
import 'package:midprice/database/generic_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DepositRepository extends DBProvider
    implements GenericRepository<Deposit> {
  static final DepositRepository instance = DepositRepository._init();

  DepositRepository._init();

  @override
  String tableName = DepositBO.tableName;

  @override
  Future<Deposit> get(int id) async {
    final db = await DepositRepository.instance.database;
    final result = await db.query(tableName,
        where: '${DepositBO.id} = ?', whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return Deposit.fromJson(result.first);
    } else {
      throw Exception('Deposit { id: $id } nof found');
    }
  }

  @override
  Future<List<Deposit>> list() async {
    final db = await DepositRepository.instance.database;
    List result = await db.rawQuery('''
      SELECT
        ${DepositBO.tableName}.${DepositBO.id},
        ${DepositBO.tableName}.${DepositBO.date},
        ${DepositBO.tableName}.${DepositBO.quantity},
        ${DepositBO.tableName}.${DepositBO.asset},
        ${DepositBO.tableName}.${DepositBO.payedValue},
        ${DepositBO.tableName}.${DepositBO.operation},
        ${DepositBO.tableName}.${DepositBO.fee},
        ${AssetBO.tableName}.${AssetBO.id} AS ${DepositBO.aliasPkAssetId},
        ${AssetBO.tableName}.${AssetBO.name} AS ${DepositBO.aliasPkAssetName},
        ${AssetBO.tableName}.${AssetBO.price} AS ${DepositBO.aliasPkAssetPrice},
        ${AssetBO.tableName}.${AssetBO.category} AS ${DepositBO.aliasPkAssetCategory}
      FROM
        ${DepositBO.tableName}
      INNER JOIN
        ${AssetBO.tableName} 
      ON 
        ${DepositBO.tableName}.${DepositBO.asset} = ${AssetBO.tableName}.${AssetBO.name}
      ORDER BY 
        ${DepositBO.date} ASC
    ''');
    return result.map((json) => Deposit.fromJson(json)).toList();
  }

  @override
  Future<Deposit> create(Deposit entity) async {
    final db = await DepositRepository.instance.database;
    await db.insert(
      tableName,
      Deposit.toJson(entity),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entity;
  }

  @override
  Future<Deposit> update(Deposit entity) async {
    try {
      final db = await DepositRepository.instance.database;
      await db.update(tableName, Deposit.toJson(entity),
          where: '${DepositBO.id} = ?', whereArgs: [entity.id]);
      return entity;
    } catch (e) {
      throw Exception('Erro ao atualizar o aporte: ${Deposit.toJson(entity)}');
    }
  }

  @override
  Future<Deposit> delete(Deposit entity) async {
    final db = await DepositRepository.instance.database;
    await db.delete(tableName,
        where: '${DepositBO.id} = ?', whereArgs: [entity.id]);
    return entity;
  }

  Future<void> deleteByAsset(Asset asset) async {
    final db = await DepositRepository.instance.database;
    await db.delete(tableName,
        where: '${DepositBO.asset} = ?', whereArgs: [asset.name]);
  }

  Future<bool> hasDepositByAssetId(String assetName) async {
    final db = await DepositRepository.instance.database;
    final result = await db.query(tableName,
        where: '${DepositBO.asset} = ?', whereArgs: [assetName], limit: 1);
    return result.isNotEmpty;
  }
}
