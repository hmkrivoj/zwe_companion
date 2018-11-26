import 'package:intl/intl.dart';
import 'package:optional/optional_internal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zwe_companion/bloc/create/bloc.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/persistence/repository.dart';

class CreateBlocImpl implements CreateBloc {
  static final _dateRegex = RegExp(r'\d\d?\.\d\d?\.\d\d\d\d');
  static final _zweRegex = RegExp(r'\D');

  final _additionalBreakController = BehaviorSubject<String>();
  final _arrivalController = BehaviorSubject<String>();
  final _dateController = BehaviorSubject<String>();
  final _departureController = BehaviorSubject<String>();
  final _targetController = BehaviorSubject<String>();
  final Repository dao;
  @override
  final DateTime initialDate;

  CreateBlocImpl(this.dao, this.initialDate);

  @override
  Sink<String> get additionalBreakSink => _additionalBreakController;
  @override
  Sink<String> get arrivalSink => _arrivalController;
  @override
  Sink<String> get dateSink => _dateController;
  @override
  Sink<String> get departureSink => _departureController;
  @override
  Sink<String> get targetSink => _targetController;

  @override
  Stream<Optional<ZweDuration>> get additionalBreak =>
      _additionalBreakController.map((text) => _parseDuration(text));
  @override
  Stream<Optional<ZweInstant>> get arrival =>
      _arrivalController.map((text) => _parseInstant(text));
  @override
  Stream<Optional<DateTime>> get date =>
      _dateController.map((text) => _parseDate(text));
  @override
  Stream<Optional<ZweInstant>> get departure =>
      _departureController.map((text) => _parseInstant(text));
  @override
  Stream<Optional<ZweDuration>> get target =>
      _targetController.map((text) => _parseDuration(text));

  @override
  Stream<Optional<Workday>> get workday => Observable.combineLatest5<
          Optional<ZweInstant>,
          Optional<ZweInstant>,
          Optional<ZweDuration>,
          Optional<ZweDuration>,
          Optional<DateTime>,
          Optional<Workday>>(
        arrival,
        departure,
        target,
        additionalBreak,
        date,
        (arrival, departure, target, additional, date) =>
            // Make sure input data is valid by checking if it's present
            arrival.isPresent &&
                    departure.isPresent &&
                    target.isPresent &&
                    additional.isPresent &&
                    date.isPresent
                // All data is present, create Workday from data
                ? Optional.of(Workday(
                    arrival: arrival.value,
                    departure: departure.value,
                    target: target.value,
                    additionalBreak: additional.value,
                    date: date.value,
                  ))
                // Data is invalid, don't return anything
                : Optional<Workday>.empty(),
      );

  static Optional<ZweInstant> _parseInstant(String text) => _validateZwe(text)
      ? Optional.of(ZweInstant(int.parse(text)))
      : Optional.empty();
  static Optional<ZweDuration> _parseDuration(String text) => _validateZwe(text)
      ? Optional.of(ZweDuration(int.parse(text)))
      : Optional.empty();
  static Optional<DateTime> _parseDate(String text) => _validateDate(text)
      ? Optional.of(DateFormat.yMd('de_DE').parse(text))
      : Optional.empty();
  static bool _validateDate(String text) =>
      text.length > 0 && _dateRegex.hasMatch(text);
  static bool _validateZwe(String text) =>
      text.length > 0 &&
      !_zweRegex.hasMatch(text) &&
      int.parse(text) >= 0 &&
      int.parse(text) < 240;

  @override
  void createWorkday(Workday workday) => dao.create(workday);

  @override
  ZweDuration get initialAdditionalBreak => ZweDuration(0);

  @override
  ZweInstant get initialArrival => ZweInstant(0);

  @override
  ZweInstant get initialDeparture => ZweInstant(85);

  @override
  ZweDuration get initialTarget => ZweDuration(78);
}
