import 'package:zwe_companion/model/model.dart';

class Workday implements Comparable<Workday> {
  int id;
  DateTime date;
  ZweInstant arrival;
  ZweInstant departure;
  ZweDuration target;
  ZweDuration totalBreak;

  Workday({
    this.id,
    this.date,
    this.arrival,
    this.departure,
    this.target,
    this.totalBreak,
  });

  ZweDuration get total => arrival.until(departure);
  ZweDuration get actualWork => total - totalBreak;
  ZweDuration get balance => actualWork - target;

  Map<String, int> toMap() => {
        'id': id,
        'date': date.millisecondsSinceEpoch ~/ 1000,
        'arrival': arrival.raw,
        'departure': departure.raw,
        'target': target.raw,
        'break': totalBreak.raw,
        'balance': balance.raw,
      };

  factory Workday.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('id'));
    assert(map.containsKey('date'));
    assert(map.containsKey('arrival'));
    assert(map.containsKey('departure'));
    assert(map.containsKey('target'));
    assert(map.containsKey('break'));
    return Workday(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000),
      arrival: ZweInstant(map['arrival']),
      departure: ZweInstant(map['departure']),
      target: ZweDuration(map['target']),
      totalBreak: ZweDuration(map['break']),
    );
  }

  @override
  int compareTo(Workday other) => date.compareTo(other.date);
}
