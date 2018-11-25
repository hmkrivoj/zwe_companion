import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optional/optional.dart';

class DateTextfield extends StatefulWidget {
  final Stream<Optional<DateTime>> stream;
  final DateTime initialData;
  final Sink<String> sink;
  final String labelText;

  DateTextfield({
    @required this.sink,
    Key key,
    @required this.stream,
    @required this.labelText,
    @required this.initialData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateTextfieldState();
}

class _DateTextfieldState extends State<DateTextfield> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => widget.sink.add(controller.text));
    controller.text = DateFormat.yMd('de_DE').format(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Optional<DateTime>>(
      initialData: Optional.of(widget.initialData),
      stream: widget.stream,
      builder: (context, snapshot) {
        return TextField(
          controller: controller,
          maxLength: 10,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: !snapshot.data.isPresent ? 'Ungültiger Wert' : null,
            helperText: snapshot.data.isPresent
                ? DateFormat.yMMMEd('de_DE').format(snapshot.data.value)
                : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                final initial = snapshot.data.isPresent
                    ? snapshot.data.value
                    : DateTime.now();
                showDatePicker(
                        context: context,
                        initialDate: initial,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2030))
                    .then(
                  (date) {
                    if (date != null) {
                      controller.text = DateFormat.yMd('de_DE').format(date);
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
