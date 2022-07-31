import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class GenericRepository<T> {
  late String tableName;

  late String dbName;

  late String script;

  Database? db;

  Future initRepository();

  Future createDB(db, version);

  Future close();

  Future<T> get(int id);

  Future<List<T>> list();

  Future<T> create(T entity);

  Future<T> update(T entity);

  Future<T> delete(T entity);

  String get _deposit => '''
    CREATE TABLE IF NOT EXISTS deposit (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INT,
      quantity TEXT,
      payedValue TEXT,
      asset TEXT
    );
  ''';
}
