import 'package:zwe_companion/model/model.dart';

class ZweDuration implements FormatableZweTemporal {
  final int raw;

  const ZweDuration(this.raw);
  const ZweDuration.fromTime(int hour, int minute)
      : this.raw = hour * 10 + (minute ~/ 6);

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
