import 'package:midpriceapp/database/asset/asset_bo.dart';
import 'package:midpriceapp/database/deposit/deposit_bo.dart';
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
      FOREIGN KEY (${DepositBO.asset}) REFERENCES ${AssetBO.tableName} (${AssetBO.name}) ON DELETE NO ACTION ON UPDATE NO ACTION
    );
  ''';

  Future createDB(db, version) async {
    await db.execute(tableAsset);
    await db.execute(tableDeposit);
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
