import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/bloc/create/bloc.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/view/widgets/form_widgets/balance_button.dart';
import 'package:zwe_companion/view/widgets/form_widgets/date_textfield.dart';
import 'package:zwe_companion/view/widgets/form_widgets/duration_textfield.dart';
import 'package:zwe_companion/view/widgets/form_widgets/instant_textfield.dart';

class CreateWorkdayScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateWorkdayScaffoldState();
}

class _CreateWorkdayScaffoldState extends State<CreateWorkdayScaffold> {
  CreateBLoC bLoC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arbeitstag erfassen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DurationTextfield(
              labelText: 'Tagessoll(Ohne Pause)',
              stream: bLoC.target,
              sink: bLoC.targetSink,
              initialData: bLoC.initialTarget,
            ),
            DateTextfield(
              labelText: 'Datum',
              stream: bLoC.date,
              sink: bLoC.dateSink,
              initialData: bLoC.initialDate,
            ),
            Divider(),
            InstantTextfield(
              labelText: 'Kommt',
              stream: bLoC.arrival,
              sink: bLoC.arrivalSink,
              initialData: bLoC.initialArrival,
            ),
            InstantTextfield(
              labelText: 'Geht',
              stream: bLoC.departure,
              sink: bLoC.departureSink,
              initialData: bLoC.initialDeparture,
            ),
            Divider(),
            DurationTextfield(
              labelText: 'Pause zusätzlich zur vorgeschriebenen Pause',
              stream: bLoC.additionalBreak,
              sink: bLoC.additionalBreakSink,
              initialData: bLoC.initialAdditionalBreak,
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<Optional<Workday>>(
                    initialData: Optional<Workday>.empty(),
                    stream: bLoC.workday,
                    builder: (context, snapshot) {
                      return BalanceButton(
                        data: snapshot.data,
                        onPressed: () {
                          Navigator.pop<Workday>(context, snapshot.data.value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bLoC = Injector.getInjector().get<CreateBLoC>();
  }
}
