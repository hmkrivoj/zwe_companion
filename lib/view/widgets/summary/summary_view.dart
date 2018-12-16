import 'package:flutter/material.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/view/widgets/summary/balances_bar.dart';
import 'package:zwe_companion/view/widgets/summary/chart_view.dart';

class SummaryView extends StatelessWidget {
  final Result result;

  const SummaryView({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            result.workdays.length > 0
                ? SizedBox(height: 300, child: ChartView(result: result))
                : Container(),
            BalancesBar(result: result),
          ],
        ),
      ),
    );
  }
}
