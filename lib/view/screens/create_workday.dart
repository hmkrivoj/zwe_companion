import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/bloc/create/bloc.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/view/widgets/form_widgets/balance_button.dart';
import 'package:zwe_companion/view/widgets/form_widgets/date_textfield.dart';
import 'package:zwe_companion/view/widgets/form_widgets/duration_textfield.dart';
import 'package:zwe_companion/view/widgets/form_widgets/instant_textfield.dart';

class CreateWorkdayScaffold extends StatefulWidget {
  final CreateBLoC initialBloc;

  CreateWorkdayScaffold({Key key, @required this.initialBloc})
      : super(key: key);

  @override
  CreateWorkdayScaffoldState createState() {
    return CreateWorkdayScaffoldState(initialBloc);
  }
}

class CreateWorkdayScaffoldState extends State<CreateWorkdayScaffold> {
  final CreateBLoC bloc;

  CreateWorkdayScaffoldState(this.bloc);

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
              stream: bloc.target,
              sink: bloc.targetSink,
              initialData: bloc.initialTarget,
            ),
            DateTextfield(
              labelText: 'Datum',
              stream: bloc.date,
              sink: bloc.dateSink,
              initialData: bloc.initialDate,
            ),
            Divider(),
            InstantTextfield(
              labelText: 'Kommt',
              stream: bloc.arrival,
              sink: bloc.arrivalSink,
              initialData: bloc.initialArrival,
            ),
            InstantTextfield(
              labelText: 'Geht',
              stream: bloc.departure,
              sink: bloc.departureSink,
              initialData: bloc.initialDeparture,
            ),
            Divider(),
            DurationTextfield(
              labelText: 'Pause zusätzlich zur vorgeschriebenen Pause',
              stream: bloc.additionalBreak,
              sink: bloc.additionalBreakSink,
              initialData: bloc.initialAdditionalBreak,
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<Optional<Workday>>(
                    initialData: Optional<Workday>.empty(),
                    stream: bloc.workday,
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
}
