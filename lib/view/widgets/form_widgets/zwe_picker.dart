import 'package:flutter/material.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/view/widgets/form_widgets/integer_picker.dart';

Future<ZweDuration> showDurationPicker({
  @required BuildContext context,
  @required ZweDuration initialZwe,
}) async {
  assert(context != null);
  assert(initialZwe != null);
  return await showDialog<int>(
    context: context,
    builder: (context) => _ZwePickerDialog(
          initialZwe: initialZwe.raw,
          mode: _ZweMode.DURATION,
        ),
  ).then(
    (raw) => raw != null ? ZweDuration(raw) : null,
  );
}

Future<ZweInstant> showInstantPicker({
  @required BuildContext context,
  @required ZweInstant initialZwe,
}) async {
  assert(context != null);
  assert(initialZwe != null);
  return await showDialog<int>(
    context: context,
    builder: (context) => _ZwePickerDialog(
          initialZwe: initialZwe.raw,
          mode: _ZweMode.INSTANT,
        ),
  ).then(
    (raw) => raw != null ? ZweInstant(raw) : null,
  );
}

class _ZwePickerDialog extends StatefulWidget {
  final int initialZwe;
  final _ZweMode mode;

  const _ZwePickerDialog({Key key, this.initialZwe, this.mode})
      : super(key: key);

  @override
  _ZwePickerDialogState createState() => _ZwePickerDialogState();
}

class _ZwePickerDialogState extends State<_ZwePickerDialog> {
  FixedExtentScrollController scrollController;
  int zwe;

  @override
  void initState() {
    super.initState();
    scrollController =
        FixedExtentScrollController(initialItem: widget.initialZwe);
    zwe = widget.initialZwe;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = MaterialLocalizations.of(context);
    var header = buildHeader(theme);
    var pager = buildPager(theme);
    var content = Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [pager, buildButtonBar(context, localizations)],
      ),
      color: theme.dialogBackgroundColor,
    );
    return Theme(
      data:
          Theme.of(context).copyWith(dialogBackgroundColor: Colors.transparent),
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(builder: (context) {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                return IntrinsicWidth(
                  child: Column(children: [header, content]),
                );
              }
              return IntrinsicHeight(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [header, content]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBar(
      BuildContext context, MaterialLocalizations localizations) {
    return ButtonTheme.bar(
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(localizations.cancelButtonLabel),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, zwe),
            child: Text(localizations.okButtonLabel),
          )
        ],
      ),
    );
  }

  Widget buildHeader(ThemeData theme) {
    final ZweTemporal temporal =
        widget.mode == _ZweMode.DURATION ? ZweDuration(zwe) : ZweInstant(zwe);
    return Material(
      color: theme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${temporal.hour}h ${temporal.minute}min',
              style: theme.primaryTextTheme.subhead,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$zwe ZWE',
                  style: theme.primaryTextTheme.headline,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.access_time,
                        color: theme.primaryIconTheme.color,
                      ),
                      onPressed: () => null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPager(ThemeData theme) {
    return Center(
      child: Container(
        width: 300.0,
        child: Center(
          child: IntegerPicker(
            controller: scrollController,
            textMapper: (index) => "$index ZWE",
            itemCount: 240,
            onSelectedItemChanged: (index) {
              setState(() {
                zwe = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

enum _ZweMode { DURATION, INSTANT }
