import 'package:zwe_companion/model/model.dart';

/// ZWE representing a period of time instead of a point in time.
/// One ZWE equals 6 minutes.
class ZweDuration extends ZweTemporal {
  ZweDuration(int raw) : super(raw);
  factory ZweDuration.fromTime(int hour, int minute) =>
      ZweDuration(hour * 10 + (minute ~/ 6));

  @override
  int get hour => raw ~/ 10;
  @override
  int get minute => raw % 10 * 6;

  bool isNegative() => raw < 0;
  bool isPositive() => raw > 0;
  ZweDuration abs() => ZweDuration(raw.abs());

  ZweDuration operator +(ZweDuration other) => ZweDuration(raw + other.raw);
  ZweDuration operator -(ZweDuration other) => ZweDuration(raw - other.raw);
  ZweDuration operator -() => ZweDuration(-raw);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZweDuration &&
          runtimeType == other.runtimeType &&
          raw == other.raw;

  @override
  int get hashCode => raw.hashCode;
}
