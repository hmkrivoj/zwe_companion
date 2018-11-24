import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/util/zwe_formatter.dart';

class WorkdayView extends StatelessWidget {
  final Workday entry;
  final _formatter = ZweFormatter();
  final _header = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  WorkdayView({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balancePrefix = entry.balance.isPositive()
        ? '+'
        : entry.balance.isNegative() ? '-' : '±';
    final balanceColor = entry.balance.isPositive()
        ? Colors.green
        : entry.balance.isNegative() ? Colors.red : null;
    final shade = entry.date.weekday * 100 + 200;
    final fontColor =
        Theme.of(context).primaryColorBrightness == Brightness.light
            ? Colors.black87
            : Colors.white;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 64.0,
          height: 64.0,
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              color: (Theme.of(context).primaryColor as MaterialColor)[shade],
              textStyle:
                  TextStyle(color: fontColor, fontWeight: FontWeight.w600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${DateFormat.E('de_DE').format(entry.date)}.',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(DateFormat.MMMd('de_DE').format(entry.date)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: MaxColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(24.0)),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: IntrinsicColumnWidth(),
              4: FlexColumnWidth(),
              5: FlexColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  Container(),
                  Text(
                    'Von',
                    style: _header,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Bis',
                    style: _header,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Ist (+Pause)',
                    style: _header,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'Soll',
                    style: _header,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'Bilanz',
                    style: _header,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.black12,
                  ),
                  Text(
                    '${_formatter.format(entry.arrival)}',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${_formatter.format(entry.departure)}',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${_formatter.format(entry.actualWork)} (+${_formatter.format(entry.totalBreak)})',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '${_formatter.format(entry.target)}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '$balancePrefix${_formatter.format(entry.balance.abs())}',
                    style: TextStyle(
                        color: balanceColor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Icon(
                    Icons.assignment,
                    color: Colors.black12,
                  ),
                  Text(
                    '${entry.arrival.raw}',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${entry.departure.raw}',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${entry.actualWork.raw} (+${entry.totalBreak.raw})',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '${entry.target.raw}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '$balancePrefix${entry.balance.abs().raw}',
                    style: TextStyle(
                        color: balanceColor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
