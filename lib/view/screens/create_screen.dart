import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/util/zwe_formatter.dart';
import 'package:zwe_companion/view/widgets/form_widgets/dropdown_text_button.dart';
import 'package:zwe_companion/view/widgets/form_widgets/zwe_picker.dart';
import 'package:intl/intl.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  static final ZweFormatter _durationFormatter = ZweFormatter(suffix: ' h');
  static final ZweFormatter _instantFormatter = ZweFormatter(suffix: ' Uhr');
  ZweDuration _target = ZweDuration(78);
  ZweInstant _arrival = ZweInstant(0);
  ZweInstant _departure = ZweInstant(85);
  ZweDuration _break = ZweDuration(5);
  bool _automaticBreak = true;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arbeitstag erfassen'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(GroovinMaterialIcons.content_save),
        onPressed: () => Navigator.pop<Workday>(
              context,
              Workday(
                date: _date,
                totalBreak: _break,
                target: _target,
                arrival: _arrival,
                departure: _departure,
              ),
            ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DropdownTextButtonWithLabelAndIcon(
              icon: GroovinMaterialIcons.timer,
              label: 'Tagessoll (Ohne Pause)',
              text: '${_durationFormatter.format(_target)} '
                  '(${_target.raw} ZWE)',
              onTap: () =>
                  showDurationPicker(context: context, initialZwe: _target)
                      .then((target) {
                    if (target != null) {
                      setState(() {
                        _target = target;
                      });
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DropdownTextButtonWithLabelAndIcon(
              icon: GroovinMaterialIcons.calendar_blank,
              label: 'Datum',
              text: '${DateFormat.EEEE('de_DE').format(_date)}, '
                  'der ${DateFormat.yMd('de_DE').format(_date)}',
              onTap: () => showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2030),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        _date = date;
                      });
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DropdownTextButtonWithLabelAndIcon(
              icon: GroovinMaterialIcons.arrow_bottom_right,
              label: 'Kommt',
              text: '${_instantFormatter.format(_arrival)} '
                  '(${_arrival.raw} ZWE)',
              onTap: () =>
                  showInstantPicker(context: context, initialZwe: _arrival)
                      .then((arrival) {
                    if (arrival != null) {
                      setState(() {
                        _arrival = arrival;
                      });
                      _calculateBreak();
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DropdownTextButtonWithLabelAndIcon(
              icon: GroovinMaterialIcons.arrow_top_right,
              label: 'Geht',
              text: '${_instantFormatter.format(_departure)} '
                  '(${_departure.raw} ZWE)',
              onTap: () =>
                  showInstantPicker(context: context, initialZwe: _departure)
                      .then((departure) {
                    if (departure != null) {
                      setState(() {
                        _departure = departure;
                      });
                      _calculateBreak();
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildAutomaticBreak(context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DropdownTextButtonWithLabelAndIcon(
              icon: GroovinMaterialIcons.coffee,
              label: 'Pause',
              text: '${_durationFormatter.format(_break)} '
                  '(${_break.raw} ZWE)',
              onTap: _automaticBreak
                  ? null
                  : () => showDurationPicker(
                        context: context,
                        initialZwe: _break,
                      ).then((newBreak) {
                        if (newBreak != null) {
                          setState(() {
                            _break = newBreak;
                          });
                        }
                      }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildBalance(context),
          ),
        ],
      ),
    );
  }

  void _calculateBreak() {
    if (_automaticBreak) {
      final total = _arrival.until(_departure).raw;
      setState(() {
        _break = ZweDuration([61, 62, 63, 64, 65, 96, 97, 98]
            .where((mark) => total >= mark)
            .length);
      });
    }
  }

  Widget _buildAutomaticBreak(BuildContext context) {
    final color = _automaticBreak
        ? Theme.of(context).accentColor
        : Theme.of(context).disabledColor;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            GroovinMaterialIcons.cogs,
            color: color,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Pausenberechnung'),
              ),
              Row(
                children: <Widget>[
                  Switch(
                    value: _automaticBreak,
                    onChanged: (newAutomaticBreak) {
                      setState(() => _automaticBreak = newAutomaticBreak);
                      _calculateBreak();
                    },
                  ),
                  Text(
                    _automaticBreak ? 'Automatisch' : 'Manuell',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: color),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalance(BuildContext context) {
    final balance = _arrival.until(_departure) - _target - _break;
    String prefix;
    Color color;
    if (balance.isPositive()) {
      color = Colors.green;
      prefix = '+';
    } else if (balance.isNegative()) {
      color = Colors.red;
      prefix = '-';
    } else {
      color = Colors.black54;
      prefix = '±';
    }
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            GroovinMaterialIcons.scale_balance,
            color: color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Saldo'),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      '$prefix${_durationFormatter.format(balance)} '
                          '($prefix${balance.abs().raw} ZWE)',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
