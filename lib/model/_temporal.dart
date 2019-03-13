/// Interface for ZWE classes which can be represented by hours and minutes.
abstract class ZweTemporal {
  ZweTemporal(this.raw);
  int get minute;
  int get hour;
  final int raw;
}
