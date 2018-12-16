import 'package:optional/optional_internal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/persistence/repository.dart';

/// Repository using Sqflite for persisting data locally.
class SqliteRepository implements Repository {
  static const _DATABASE_FILE = '/zwe_companion.db';
  static const _VERSION = 2;
  static const _TABLE_WORKDAY = 'workday';
  static const _COLUMN_WORKDAY_ID = 'id';
  static const _COLUMN_WORKDAY_ARRIVAL = 'arrival';
  static const _COLUMN_WORKDAY_DEPARTURE = 'departure';
  static const _COLUMN_WORKDAY_TARGET = 'target';
  static const _COLUMN_WORKDAY_ADDITIONAL_BREAK = 'additionalBreak';
  static const _COLUMN_WORKDAY_DATE = 'date';
  static const _COLUMN_WORKDAY_BALANCE = 'balance';
  // Don't use this object directly! Use _getDatabase() instead.
  Database _dbInstance;

  @override
  Future<List<Workday>> findWorkdaysByMonth(DateTime date) => _getDatabase()
      .then(
        (db) => db.query(
              _TABLE_WORKDAY,
              orderBy: _COLUMN_WORKDAY_DATE,
              where: "$_COLUMN_WORKDAY_DATE >= ? AND "
                  "$_COLUMN_WORKDAY_DATE < ?",
              whereArgs: [
                DateTime(date.year, date.month).millisecondsSinceEpoch ~/ 1000,
                DateTime(date.year, date.month + 1).millisecondsSinceEpoch ~/
                    1000,
              ],
            ),
      )
      .then((records) =>
          records.map((record) => Workday.fromMap(record)).toList());

  @override
  Future<ZweDuration> getBalanceAtBeginningOfMonth(DateTime date) {
    final beginning =
        DateTime(date.year, date.month).millisecondsSinceEpoch ~/ 1000;
    return _getDatabase()
        .then(
          (db) => db.query(
                _TABLE_WORKDAY,
                columns: ['sum($_COLUMN_WORKDAY_BALANCE) AS balanceSum'],
                where: "$_COLUMN_WORKDAY_DATE < ?",
                whereArgs: [beginning],
              ),
        )
        .then<int>((records) => records.first['balanceSum'] ?? 0)
        .then((raw) => ZweDuration(raw));
  }

  @override
  Future<Optional<Workday>> create(Workday workday) =>
      // Get database
      _getDatabase()
          // Insert workday into database
          .then(
            (db) => db.insert(
                  _TABLE_WORKDAY,
                  workday.toMap(),
                ),
          )
          // Wrap id into Optional for null safety
          .then((id) => Optional.ofNullable(id))
          // Insert id into workday and return it
          .then((optional) => optional.map((id) => workday..id = id));

  @override
  Future<Optional<Workday>> update(Workday workday) =>
      // Get database
      _getDatabase()
          // Then update entry
          .then(
            (db) => db.update(
                  _TABLE_WORKDAY,
                  workday.toMap(),
                  where: '$_COLUMN_WORKDAY_ID = ?',
                  whereArgs: [workday.id],
                ),
          )
          // Then wrap id into Optional for null safety
          .then((id) => Optional.ofNullable(id))
          // Return workday
          .then((optional) => optional.map((_) => workday));

  @override
  Future<Optional<Workday>> delete(Workday workday) =>
      // Get database
      _getDatabase()
          // Then delete entry
          .then(
            (db) => db.delete(_TABLE_WORKDAY,
                where: '$_COLUMN_WORKDAY_ID = ?', whereArgs: [workday.id]),
          )
          // Then wrap id into Optional for null safety
          .then((id) => Optional.ofNullable(id))
          // Return workday
          .then((optional) => optional.map((_) => workday));

  Future<Database> _getDatabase() async {
    if (_dbInstance == null) {
      final path = await getApplicationDocumentsDirectory()
          .then((dir) => dir.path + _DATABASE_FILE);
      _dbInstance = await openDatabase(
        path,
        version: _VERSION,
        onCreate: (db, version) async => await db.execute('''
        CREATE TABLE $_TABLE_WORKDAY (
        $_COLUMN_WORKDAY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $_COLUMN_WORKDAY_ARRIVAL INTEGER,
        $_COLUMN_WORKDAY_DEPARTURE INTEGER,
        $_COLUMN_WORKDAY_TARGET INTEGER,
        $_COLUMN_WORKDAY_ADDITIONAL_BREAK INTEGER,
        $_COLUMN_WORKDAY_DATE INTEGER,
        $_COLUMN_WORKDAY_BALANCE INTEGER)
        '''),
        onUpgrade: (db, oldVersion, newVersion) async {
          // In this version of the database the timestamp used to be stored as
          // milliseconds instead of seconds, so the timestamp has to be divided
          // by 1000 in order to become compatible with later versions
          if (oldVersion <= 1) {
            await db.execute('''
            UPDATE $_TABLE_WORKDAY
            SET $_COLUMN_WORKDAY_DATE = $_COLUMN_WORKDAY_DATE / 1000
            ''');
          }
        },
      );
    }
    return _dbInstance;
  }
}
