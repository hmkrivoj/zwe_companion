import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/model.dart';

class SumBar extends StatelessWidget {
  final Balances balances;

  const SumBar({Key key, @required this.balances}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SumView(
          positive: balances.preBalancePositive,
          negative: balances.preBalanceNegative,
          sum: balances.preBalance,
          icon: GroovinMaterialIcons.format_horizontal_align_left,
          labelText: 'Monatsbegin',
        ),
        SumView(
          positive: balances.midBalancePositive,
          negative: balances.midBalanceNegative,
          sum: balances.midBalance,
          icon: GroovinMaterialIcons.format_horizontal_align_center,
          labelText: 'Monatsmitte',
        ),
        SumView(
          positive: balances.postBalancePositive,
          negative: balances.postBalanceNegative,
          sum: balances.postBalance,
          icon: GroovinMaterialIcons.format_horizontal_align_right,
          labelText: 'Monatsende',
        ),
      ],
    );
  }
}

class SumView extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final ZweDuration positive;
  final ZweDuration negative;
  final ZweDuration sum;
  const SumView({
    Key key,
    @required this.positive,
    @required this.negative,
    @required this.sum,
    @required this.icon,
    @required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 18.0,
              ),
              Text(labelText)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SmallZweText(zwe: positive, signum: ZweSignum.POSITIVE),
                  SmallZweText(zwe: negative, signum: ZweSignum.NEGATIVE),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  BigZweText(zwe: sum),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SmallZweText extends StatelessWidget {
  final ZweDuration zwe;
  final ZweSignum signum;

  SmallZweText({Key key, @required this.zwe, @required this.signum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String prefix;
    switch (signum) {
      case ZweSignum.POSITIVE:
        color = Colors.green;
        prefix = '+';
        break;
      case ZweSignum.NEGATIVE:
        color = Colors.red;
        prefix = '-';
        break;
    }
    return Text(
      '$prefix${zwe.abs().raw}',
      style: TextStyle(color: color),
    );
  }
}

class BigZweText extends StatelessWidget {
  final ZweDuration zwe;

  BigZweText({Key key, @required this.zwe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefix = zwe.isPositive() ? '+' : zwe.isNegative() ? '-' : '±';
    final color = zwe.isPositive()
        ? Colors.green
        : zwe.isNegative() ? Colors.red : Colors.black54;
    return Text(
      '$prefix${zwe.abs().raw}',
      style:
          TextStyle(color: color, fontSize: 36.0, fontWeight: FontWeight.bold),
    );
  }
}

enum ZweSignum { POSITIVE, NEGATIVE }
