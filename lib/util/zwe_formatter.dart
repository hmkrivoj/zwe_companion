import 'package:zwe_companion/model/model.dart';

/// Converts ZWEs to strings of hours and minutes.
class ZweFormatter {
  final String suffix;
  final String prefix;

  const ZweFormatter({this.suffix = '', this.prefix = ''});

  String format(FormatableZweTemporal temporal) => '$prefix'
      '${temporal.hour.toString().padLeft(2, '0')}:'
      '${temporal.minute.toString().padLeft(2, '0')}'
      '$suffix';
}
