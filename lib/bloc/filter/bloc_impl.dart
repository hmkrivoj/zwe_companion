import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/_duration.dart';
import 'package:zwe_companion/model/_workday.dart';
import 'package:zwe_companion/persistence/dao.dart';

class FilterBlocImpl implements FilterBloc {
  final _monthSelections = BehaviorSubject<DateTime>(seedValue: DateTime.now());
  final _created = PublishSubject<Workday>();
  final _deleted = PublishSubject<Workday>();
  final _updated = PublishSubject<Workday>();
  final Repository repository;

  FilterBlocImpl(this.repository);

  Stream<DateTime> get _trigger => Observable.combineLatest2(
      monthSelected,
      Observable.merge([
        created,
        deleted,
        updated,
      ]).startWith(null),
      (month, _) => month);

  @override
  Stream<List<Workday>> get workdays =>
      _trigger.asyncMap(repository.findWorkdaysByMonth).distinct();

  @override
  Stream<DateTime> get monthSelected => _monthSelections.stream.distinct();
  @override
  Stream<Workday> get created => _created;
  @override
  Stream<Workday> get deleted => _deleted;
  @override
  Stream<Workday> get updated => _updated;

  @override
  void selectMonth(DateTime month) => _monthSelections.add(month);
  @override
  Future<Optional<Workday>> create(Workday workday) =>
      repository.create(workday).then((o) {
        o.ifPresent(_created.add);
        return o;
      });
  @override
  Future<Optional<Workday>> delete(Workday workday) =>
      repository.delete(workday).then((o) {
        o.ifPresent(_deleted.add);
        return o;
      });
  @override
  Future<Optional<Workday>> update(Workday workday) =>
      repository.update(workday).then((o) {
        o.ifPresent(_updated.add);
        return o;
      });

  Stream<ZweDuration> get _preBalanceSum =>
      _trigger.asyncMap(repository.getBalanceAtBeginningOfMonth);
  Stream<ZweDuration> get _preBalanceSumPositive => _preBalanceSum
      .map((balance) => balance.isPositive() ? balance : ZweDuration(0));
  Stream<ZweDuration> get _preBalanceSumNegative => _preBalanceSum
      .map((balance) => balance.isNegative() ? balance : ZweDuration(0));

  Stream<ZweDuration> get _midBalancePositive => Observable.zip2(
        _preBalanceSumPositive,
        workdays,
        (ZweDuration pre, List<Workday> list) => list
            .where((workday) => workday.balance.isPositive())
            .where((workday) => workday.date.day <= 15)
            .map((w) => w.balance)
            .fold(pre, (a, b) => a + b),
      );
  Stream<ZweDuration> get _midBalanceNegative => Observable.zip2(
        _preBalanceSumNegative,
        workdays,
        (ZweDuration pre, List<Workday> list) => list
            .where((workday) => workday.balance.isNegative())
            .where((workday) => workday.date.day <= 15)
            .map((w) => w.balance)
            .fold(pre, (a, b) => a + b),
      );
  Stream<ZweDuration> get _midBalanceSum => Observable.zip2(
        _midBalanceNegative,
        _midBalancePositive,
        (ZweDuration a, ZweDuration b) => a + b,
      );
  Stream<ZweDuration> get _midBalanceSumPositive => _midBalanceSum
      .map((balance) => balance.isPositive() ? balance : ZweDuration(0));
  Stream<ZweDuration> get _midBalanceSumNegative => _midBalanceSum
      .map((balance) => balance.isNegative() ? balance : ZweDuration(0));

  Stream<ZweDuration> get _postBalancePositive => Observable.zip2(
        _midBalanceSumPositive,
        workdays,
        (ZweDuration mind, List<Workday> list) => list
            .where((workday) => workday.balance.isPositive())
            .where((workday) => workday.date.day > 15)
            .map((w) => w.balance)
            .fold(mind, (a, b) => a + b),
      );
  Stream<ZweDuration> get _postBalanceNegative => Observable.zip2(
        _midBalanceSumNegative,
        workdays,
        (ZweDuration mind, List<Workday> list) => list
            .where((workday) => workday.balance.isNegative())
            .where((workday) => workday.date.day > 15)
            .map((w) => w.balance)
            .fold(mind, (a, b) => a + b),
      );
  Stream<ZweDuration> get _postBalanceSum => Observable.zip2(
        _postBalanceNegative,
        _postBalancePositive,
        (ZweDuration a, ZweDuration b) => a + b,
      );

  @override
  Stream<Balances> get balances => Observable.zip9(
      _preBalanceSumPositive,
      _preBalanceSumNegative,
      _preBalanceSum,
      _midBalancePositive,
      _midBalanceNegative,
      _midBalanceSum,
      _postBalancePositive,
      _postBalanceNegative,
      _postBalanceSum,
      (prePos, preNeg, preSum, midPos, midNeg, midSum, postPos, postNeg,
              postSum) =>
          Balances(prePos, preNeg, preSum, midPos, midNeg, midSum, postPos,
              postNeg, postSum));

  void dispose() {
    _monthSelections.close();
    _created.close();
    _deleted.close();
    _updated.close();
  }
}
