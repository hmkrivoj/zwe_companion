import 'package:zwe_companion/model/model.dart';

class Workday implements Comparable<Workday> {
  int id;
  DateTime date;
  ZweInstant arrival;
  ZweInstant departure;
  ZweDuration target;
  ZweDuration additionalBreak;

  Workday({
    this.id,
    this.date,
    this.arrival,
    this.departure,
    this.target,
    this.additionalBreak,
  });

  ZweDuration get total => arrival.until(departure);
  ZweDuration get totalBreak =>
      ZweDuration([61, 62, 63, 64, 65, 96, 97, 98]
          // Number of markers passed = breaktime in zwe
          .where((marker) => (total - additionalBreak).raw >= marker)
          .length) +
      additionalBreak;
  ZweDuration get actualWork => total - totalBreak;
  ZweDuration get balance => actualWork - target;

  Map<String, int> toMap() => {
        'id': id,
        'date': date.millisecondsSinceEpoch ~/ 1000,
        'arrival': arrival.raw,
        'departure': departure.raw,
        'target': target.raw,
        'additionalBreak': additionalBreak.raw,
        'balance': balance.raw,
      };

  factory Workday.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('id'));
    assert(map.containsKey('date'));
    assert(map.containsKey('arrival'));
    assert(map.containsKey('departure'));
    assert(map.containsKey('target'));
    assert(map.containsKey('additionalBreak'));
    return Workday(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000),
      arrival: ZweInstant(map['arrival']),
      departure: ZweInstant(map['departure']),
      target: ZweDuration(map['target']),
      additionalBreak: ZweDuration(map['additionalBreak']),
    );
  }

  @override
  int compareTo(Workday other) => date.compareTo(other.date);
}
