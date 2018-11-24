import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/util/zwe_formatter.dart';

class BalanceButton extends StatelessWidget {
  final _formatter = ZweFormatter();
  final Function onPressed;
  final Optional<Workday> data;
  BalanceButton({Key key, this.onPressed, @required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    Color bgColor;
    bool active;
    if (!data.isPresent) {
      label = 'Eingabe überprüfen';
      bgColor = Colors.grey.shade300;
      active = false;
    } else {
      final balance = data.value.balance;
      String prefix;
      active = true;
      if (balance.isPositive()) {
        prefix = '+';
        bgColor = Colors.green;
      } else if (balance.isNegative()) {
        prefix = '-';
        bgColor = Colors.red;
      } else {
        prefix = '±';
        bgColor = Colors.grey;
      }
      label = '$prefix${_formatter.format(balance.abs())}h '
          '($prefix${balance.abs().raw} ZWE) buchen';
    }
    return FlatButton(
      padding: EdgeInsets.all(12.0),
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      color: bgColor,
      disabledColor: bgColor,
      child: Text(
        label,
        style: TextStyle(fontSize: 16.0),
      ),
      onPressed: active ? onPressed : null,
    );
  }
}
