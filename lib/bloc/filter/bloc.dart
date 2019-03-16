import 'dart:async';

import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';

abstract class FilterBloc {
  void dispose();
  void selectMonth(DateTime month);
  Future<Optional<Workday>> create(Workday workday);
  Future<Optional<Workday>> update(Workday workday);
  Future<Optional<Workday>> delete(Workday workday);
  Stream<DateTime> get monthSelected;
  Stream<Result> get result;
}

@immutable
class Balance {
  final ZweDuration positiveAddend;
  final ZweDuration negativeAddend;
  Balance(this.positiveAddend, this.negativeAddend)
      : assert(!positiveAddend.isNegative()),
        assert(!negativeAddend.isPositive());
  factory Balance.ofTotal(ZweDuration total) => total.isPositive()
      ? Balance(total, ZweDuration(0))
      : Balance(ZweDuration(0), total);
  ZweDuration get total => positiveAddend + negativeAddend;
  ZweDuration get negativeTotal => total.isNegative() ? total : ZweDuration(0);
  ZweDuration get positiveTotal => total.isPositive() ? total : ZweDuration(0);
}

@immutable
class Result {
  final Balance pre;
  final Balance mid;
  final Balance post;
  final List<Workday> workdays;
  final DateTime month;

  Result({
    @required this.pre,
    @required this.mid,
    @required this.post,
    @required this.workdays,
    @required this.month,
  });
}
