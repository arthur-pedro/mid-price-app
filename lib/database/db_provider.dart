import 'package:midprice/database/asset/asset_bo.dart';
import 'package:midprice/database/config/config_bo.dart';
import 'package:midprice/database/deposit/deposit_bo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._init();

  DBProvider._init();

  Database? db;

  String dbName = 'rebalance.db';

  DBProvider() {
    _initDatabase(dbName);
  }

  String tableAsset = '''
    CREATE TABLE IF NOT EXISTS ${AssetBO.tableName} (
      ${AssetBO.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      ${AssetBO.name} TEXT NOT NULL,
      ${AssetBO.price} TEXT NOT NULL,
      ${AssetBO.category} TEXT NOT NULL
    );
  ''';

  String tableDeposit = '''
    CREATE TABLE IF NOT EXISTS ${DepositBO.tableName} (
      ${DepositBO.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DepositBO.date} INT NOT NULL,
      ${DepositBO.quantity} TEXT NOT NULL,
      ${DepositBO.payedValue} TEXT NOT NULL,
      ${DepositBO.asset} TEXT NOT NULL,
      ${DepositBO.operation} TEXT NOT NULL,
      ${DepositBO.fee} TEXT NOT NULL,
      FOREIGN KEY (${DepositBO.asset}) REFERENCES ${AssetBO.tableName} (${AssetBO.name}) ON DELETE CASCADE ON UPDATE CASCADE
    );
  ''';

  String tableConfig = '''
    CREATE TABLE IF NOT EXISTS ${ConfigBO.tableName} (
      ${ConfigBO.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ConfigBO.noAds} INT NOT NULL,
      ${ConfigBO.theme} TEXT NOT NULL,
      ${ConfigBO.assetLimitStep} INT NOT NULL,
      ${ConfigBO.depositLimitStep} INT NOT NULL,
      ${ConfigBO.assetQuantityLimit} INT NOT NULL,
      ${ConfigBO.depositQuantityLimit} INT NOT NULL,
      ${ConfigBO.lvl} INT NOT NULL
    );
  ''';

  String insertDefaultConfig = '''
    INSERT INTO 
      ${ConfigBO.tableName} (${ConfigBO.id}, ${ConfigBO.assetQuantityLimit},  ${ConfigBO.noAds},  ${ConfigBO.theme}, ${ConfigBO.assetLimitStep}, ${ConfigBO.depositLimitStep}, ${ConfigBO.depositQuantityLimit}, ${ConfigBO.lvl})
    SELECT 1, 3, 0, 'DEFAULT', 3, 3, 3, 1
    WHERE NOT EXISTS(SELECT 1 FROM ${ConfigBO.tableName} WHERE id = 1)
  ''';

  Future createDB(db, version) async {
    await db.execute(tableAsset);
    await db.execute(tableDeposit);
    await db.execute(tableConfig);
    await db.execute(insertDefaultConfig);
  }

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDatabase(dbName)!;
    return db!;
  }

  _initDatabase(String dbName) async {
    return await openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, onCreate: createDB);
  }

  Future close() async {
    final db = await instance.database;
    if (db.isOpen) {
      db.close();
    }
  }
}
