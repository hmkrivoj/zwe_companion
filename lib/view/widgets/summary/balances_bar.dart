import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/model.dart';

class BalancesBar extends StatelessWidget {
  final Result result;

  const BalancesBar({Key key, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _BalanceView(
          positive: result.pre.positiveAddend,
          negative: result.pre.negativeAddend,
          sum: result.pre.total,
          icon: GroovinMaterialIcons.format_horizontal_align_left,
          labelText: 'Monatsbeginn',
        ),
        _BalanceView(
          positive: result.mid.positiveAddend,
          negative: result.mid.negativeAddend,
          sum: result.mid.total,
          icon: GroovinMaterialIcons.format_horizontal_align_center,
          labelText: 'Monatsmitte',
        ),
        _BalanceView(
          positive: result.post.positiveAddend,
          negative: result.post.negativeAddend,
          sum: result.post.total,
          icon: GroovinMaterialIcons.format_horizontal_align_right,
          labelText: 'Monatsende',
        ),
      ],
    );
  }
}

class _BalanceView extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final ZweDuration positive;
  final ZweDuration negative;
  final ZweDuration sum;
  const _BalanceView({
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
                  _SmallZweText(zwe: positive, signum: _ZweSignum.POSITIVE),
                  _SmallZweText(zwe: negative, signum: _ZweSignum.NEGATIVE),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _BigZweText(zwe: sum),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _ZweSignum { POSITIVE, NEGATIVE }

// SmallZweText will always format text in either positive or negative style.
class _SmallZweText extends StatelessWidget {
  final ZweDuration zwe;
  final _ZweSignum signum;

  _SmallZweText({Key key, @required this.zwe, @required this.signum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String prefix;
    switch (signum) {
      case _ZweSignum.POSITIVE:
        color = Colors.green;
        prefix = '+';
        break;
      case _ZweSignum.NEGATIVE:
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

class _BigZweText extends StatelessWidget {
  final ZweDuration zwe;

  _BigZweText({Key key, @required this.zwe}) : super(key: key);

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
