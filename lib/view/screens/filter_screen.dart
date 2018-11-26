import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/view/widgets/summary/summary_view.dart';
import 'package:zwe_companion/view/widgets/workday_view.dart';

class FilterScreen extends StatelessWidget {
  final _slidableController = SlidableController();
  final FilterBloc bloc;

  FilterScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: buildSummary(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: buildResultList(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: StreamBuilder(
          stream: bloc.monthSelected,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${DateFormat.yMMMM('de_DE').format(snapshot.data)}');
            }
            return Text('Kein Monat ausgewählt');
          }),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2030),
              ).then((date) {
                if (date != null) {
                  bloc.selectMonth(date);
                }
              }),
        )
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create').then((workday) {
          if (workday != null) {
            bloc.create(workday);
          }
        });
      },
      child: Icon(Icons.add),
    );
  }

  StreamBuilder<Balances> buildSummary() {
    return StreamBuilder<Balances>(
      stream: bloc.balances,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Summary(snapshot.data);
        }
        return CircularProgressIndicator();
      },
    );
  }

  StreamBuilder<List<Workday>> buildResultList() {
    return StreamBuilder<List<Workday>>(
      stream: bloc.workdays,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              'Keine Einträge für diesen Monat\n¯\\_(ツ)_/¯',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subhead,
            ),
          );
        }
        return Column(
          children: snapshot.data
              .map((workday) => buildListItem(context, workday))
              .toList(),
        );
      },
    );
  }

  Widget buildListItem(BuildContext context, Workday entry) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26),
        ),
      ),
      child: Slidable(
        controller: _slidableController,
        delegate: SlidableDrawerDelegate(),
        actions: <Widget>[
          IconSlideAction(
            icon: Icons.delete,
            caption: 'Entfernen',
            color: Colors.red,
            onTap: () => handleDelete(entry, context),
            closeOnTap: true,
          ),
        ],
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: WorkdayView(entry: entry),
        ),
      ),
    );
  }

  void handleDelete(Workday entry, BuildContext context) {
    bloc.delete(entry).then((o) => o.ifPresent((workday) {
          final dateFormat = DateFormat.MMMEd('de_DE');
          final contentLabel = '${dateFormat.format(workday.date)} gelöscht';
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(contentLabel),
              action: SnackBarAction(
                label: 'Wiederherstellen',
                onPressed: () => bloc.create(workday),
              )));
        }));
  }
}
