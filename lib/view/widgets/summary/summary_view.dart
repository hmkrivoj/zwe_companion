import 'package:flutter/material.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/view/widgets/summary/sum_view.dart';

class Summary extends StatelessWidget {
  final Balances balances;

  Summary(this.balances);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SumBar(balances: balances),
      ),
    );
  }
}
