import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';

abstract class FilterBloc {
  Stream<List<Workday>> get workdays;
  Stream<DateTime> get monthSelected;
  Stream<Balances> get balances;
  void selectMonth(DateTime month);
  Future<Optional<Workday>> create(Workday workday);
  Future<Optional<Workday>> update(Workday workday);
  Future<Optional<Workday>> delete(Workday workday);
  Stream<Workday> get created;
  Stream<Workday> get deleted;
  Stream<Workday> get updated;
}

class Balances {
  final ZweDuration preBalancePositive;
  final ZweDuration preBalanceNegative;
  final ZweDuration preBalance;
  final ZweDuration midBalancePositive;
  final ZweDuration midBalanceNegative;
  final ZweDuration midBalance;
  final ZweDuration postBalancePositive;
  final ZweDuration postBalanceNegative;
  final ZweDuration postBalance;

  Balances(
    this.preBalancePositive,
    this.preBalanceNegative,
    this.preBalance,
    this.midBalancePositive,
    this.midBalanceNegative,
    this.midBalance,
    this.postBalancePositive,
    this.postBalanceNegative,
    this.postBalance,
  );
}
