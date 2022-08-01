import 'package:sqflite/sqflite.dart';

abstract class GenericRepository<T> {
  late String tableName;

  Database? db;

  Future<T> get(int id);

  Future<List<T>> list();

  Future<T> create(T entity);

  Future<T> update(T entity);

  Future<T> delete(T entity);
}
