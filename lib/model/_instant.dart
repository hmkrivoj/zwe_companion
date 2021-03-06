import 'package:zwe_companion/model/model.dart';

/// ZWE representing a point in time instead of a period of time.
/// The day starts with 0 ZWE which is 6:30 in real time.
class ZweInstant extends ZweTemporal {
  ZweInstant(int raw) : super(raw);
  factory ZweInstant.fromTime(int hour, int minute) =>
      ZweInstant((10 * hour + minute ~/ 6 - 65) % 240);

  @override
  int get hour => ((raw + 65) % 240 ~/ 10);
  @override
  int get minute => (raw + 65) % 10 * 6;

  int get dayOffset => raw ~/ 240;

  ZweInstant operator +(ZweDuration other) =>
      ZweInstant((raw + other.raw) % 240);
  ZweInstant operator -(ZweDuration other) =>
      ZweInstant((raw - other.raw) % 240);
  ZweDuration until(ZweInstant other) => ZweDuration((other.raw - raw) % 240);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZweInstant &&
          runtimeType == other.runtimeType &&
          raw == other.raw;

  @override
  int get hashCode => raw.hashCode;
}
