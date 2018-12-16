import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/model.dart';

class ChartView extends StatelessWidget {
  final Result result;

  const ChartView({Key key, @required this.result}) : super(key: key);

  List<Charts.Series<Workday, String>> buildSeries() {
    return [
      Charts.Series(
        id: 'Plus',
        domainFn: (workday, _) => workday.date.day.toString(),
        measureFn: (workday, _) =>
            (workday.balance.isPositive() ? workday.balance.abs().raw : 0),
        colorFn: (workday, _) => Charts.ColorUtil.fromDartColor(Colors.green),
        data: result.workdays,
      ),
      Charts.Series(
        id: 'Minus',
        domainFn: (workday, _) => workday.date.day.toString(),
        measureFn: (workday, _) =>
            (workday.balance.isNegative() ? workday.balance.abs().raw : 0),
        colorFn: (workday, _) => Charts.ColorUtil.fromDartColor(Colors.red),
        data: result.workdays,
      ),
      Charts.Series(
        id: 'Erfülltes Soll',
        domainFn: (workday, _) => workday.date.day.toString(),
        measureFn: (workday, _) =>
            workday.arrival.raw +
            workday.target.raw +
            (workday.balance.isNegative() ? workday.balance.raw : 0),
        colorFn: (workday, _) =>
            Charts.ColorUtil.fromDartColor(Colors.grey.shade300),
        data: result.workdays,
      ),
      Charts.Series(
        id: 'Pause',
        domainFn: (workday, _) => workday.date.day.toString(),
        measureFn: (workday, _) => workday.totalBreak.raw,
        colorFn: (workday, _) =>
            Charts.ColorUtil.fromDartColor(Colors.grey.shade400),
        data: result.workdays,
      ),
      Charts.Series(
        id: 'Kommt',
        domainFn: (workday, _) => workday.date.day.toString(),
        measureFn: (workday, _) => workday.arrival.raw,
        colorFn: (workday, _) =>
            Charts.ColorUtil.fromDartColor(Colors.grey.shade500),
        data: result.workdays,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Charts.BarChart(
      buildSeries(),
      animate: true,
      barGroupingType: Charts.BarGroupingType.groupedStacked,
    );
  }
}
