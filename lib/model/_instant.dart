import 'package:zwe_companion/model/model.dart';

class ZweInstant implements FormatableZweTemporal {
  final int raw;

  const ZweInstant(this.raw);
  const ZweInstant.fromTime(int hour, int minute)
      : this.raw = (10 * hour + minute ~/ 6 - 65) % 240;

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
