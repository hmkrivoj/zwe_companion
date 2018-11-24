import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';

abstract class CreateBLoC {
  Stream<Optional<DateTime>> get date;
  Stream<Optional<ZweInstant>> get arrival;
  Stream<Optional<ZweInstant>> get departure;
  Stream<Optional<ZweDuration>> get target;
  Stream<Optional<ZweDuration>> get additionalBreak;
  Stream<Optional<Workday>> get workday;
  Sink<String> get dateSink;
  Sink<String> get arrivalSink;
  Sink<String> get departureSink;
  Sink<String> get targetSink;
  Sink<String> get additionalBreakSink;
  Optional<DateTime> get initialDate;
  Optional<ZweInstant> get initialArrival;
  Optional<ZweInstant> get initialDeparture;
  Optional<ZweDuration> get initialTarget;
  Optional<ZweDuration> get initialAdditionalBreak;
  void createWorkday(Workday workday);
}
