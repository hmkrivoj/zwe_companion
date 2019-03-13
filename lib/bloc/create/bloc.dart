import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';

abstract class CreateBloc {
  Stream<Optional<DateTime>> get date;
  Stream<Optional<ZweInstant>> get arrival;
  Stream<Optional<ZweInstant>> get departure;
  Stream<Optional<ZweDuration>> get target;
  Stream<Optional<ZweDuration>> get totalBreak;
  Stream<Optional<Workday>> get workday;
  Sink<String> get dateSink;
  Sink<String> get arrivalSink;
  Sink<String> get departureSink;
  Sink<String> get targetSink;
  Sink<String> get totalBreakSink;
  DateTime get initialDate;
  ZweInstant get initialArrival;
  ZweInstant get initialDeparture;
  ZweDuration get initialTarget;
  ZweDuration get initialTotalBreak;
  void createWorkday(Workday workday);
}
