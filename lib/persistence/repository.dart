import 'dart:async';

import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';

abstract class Repository {
  /// Try creating a new workday. If workday already exists return null.
  Future<Optional<Workday>> create(Workday workday);

  /// Try updating a specific workday. Returns null if it doesn't exist.
  Future<Optional<Workday>> update(Workday workday);

  /// Try deleting a specific workday. Returns null if it doesn't exist.
  Future<Optional<Workday>> delete(Workday workday);

  /// Get workdays where month and year are equal to month and year of specified date
  Future<List<Workday>> findWorkdaysByMonth(DateTime date);

  Future<ZweDuration> getBalanceAtBeginningOfMonth(DateTime date);
}
