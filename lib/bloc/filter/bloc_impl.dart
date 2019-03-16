import 'dart:async';

import 'package:optional/optional_internal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/_workday.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/persistence/repository.dart';

class FilterBlocImpl implements FilterBloc {
  final _monthSelections = BehaviorSubject<DateTime>();
  final _created = PublishSubject<Workday>();
  final _deleted = PublishSubject<Workday>();
  final _updated = PublishSubject<Workday>();
  final Repository repository;

  FilterBlocImpl(this.repository, DateTime initialDate) {
    _monthSelections.sink.add(initialDate);
  }

  Stream<DateTime> get _trigger => Observable.combineLatest2(
      monthSelected,
      Observable.merge([
        _workdayCreated,
        _workdayDeleted,
        _workdayUpdated,
      ]).startWith(null),
      (month, _) => month);

  Stream<List<Workday>> get _workdays =>
      _trigger.asyncMap(repository.findWorkdaysByMonth).distinct();
  Stream<Balance> get _preBalance => _trigger
      .asyncMap(repository.getBalanceAtBeginningOfMonth)
      .map((balance) => Balance.ofTotal(balance));

  Stream<Workday> get _workdayCreated => _created;
  Stream<Workday> get _workdayDeleted => _deleted;
  Stream<Workday> get _workdayUpdated => _updated;

  @override
  Stream<DateTime> get monthSelected => _monthSelections.stream.distinct();

  @override
  void selectMonth(DateTime month) => _monthSelections.sink.add(month);
  @override
  Future<Optional<Workday>> create(Workday workday) =>
      repository.create(workday).then((o) => o..ifPresent(_created.sink.add));
  @override
  Future<Optional<Workday>> delete(Workday workday) =>
      repository.delete(workday).then((o) => o..ifPresent(_deleted.sink.add));
  @override
  Future<Optional<Workday>> update(Workday workday) =>
      repository.update(workday).then((o) => o..ifPresent(_updated.sink.add));

  @override
  Stream<Result> get result => Observable.zip2<Balance, List<Workday>, Result>(
        _preBalance,
        _workdays,
        (pre, workdays) {
          final preMid = workdays
              .where((workday) => workday.date.day <= 15)
              .map((workday) => workday.balance);
          final positiveMid = preMid
              .where((balance) => balance.isPositive())
              .fold(pre.positiveTotal, (a, b) => a + b);
          final negativeMid = preMid
              .where((balance) => balance.isNegative())
              .fold(pre.negativeTotal, (a, b) => a + b);
          final mid = Balance(positiveMid, negativeMid);
          final postMid = workdays
              .where((workday) => workday.date.day > 15)
              .map((workday) => workday.balance);
          final positivePost = postMid
              .where((balance) => balance.isPositive())
              .fold(mid.positiveTotal, (a, b) => a + b);
          final negativePost = postMid
              .where((balance) => balance.isNegative())
              .fold(mid.negativeTotal, (a, b) => a + b);
          final post = Balance(positivePost, negativePost);
          return Result(
              pre: pre, mid: mid, post: post, workdays: workdays, month: null);
        },
      );

  @override
  void dispose() {
    _monthSelections.close();
    _created.close();
    _deleted.close();
    _updated.close();
  }
}
