import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/util/zwe_formatter.dart';
import 'package:zwe_companion/view/widgets/custom_time_picker.dart';

class InstantTextfield extends StatefulWidget {
  final Stream<Optional<ZweInstant>> stream;
  final Optional<ZweInstant> initialData;
  final Sink<String> sink;
  final String labelText;

  InstantTextfield({
    @required this.sink,
    Key key,
    @required this.stream,
    @required this.labelText,
    this.initialData = const Optional<ZweInstant>.empty(),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InstantTextfieldState();
}

class _InstantTextfieldState extends State<InstantTextfield> {
  final TextEditingController controller = TextEditingController();
  final formatter = ZweFormatter(prefix: 'Entspricht ', suffix: ' Uhr');

  @override
  void initState() {
    super.initState();
    controller.addListener(() => widget.sink.add(controller.text));
    widget.initialData
        .ifPresent((instant) => controller.text = '${instant.raw}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Optional<ZweInstant>>(
      initialData: widget.initialData,
      stream: widget.stream,
      builder: (context, snapshot) {
        return TextField(
          controller: controller,
          maxLength: 3,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: !snapshot.data.isPresent ? 'Ungültiger Wert' : null,
            helperText: snapshot.data.isPresent
                ? formatter.format(snapshot.data.value)
                : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () {
                final initial =
                    snapshot.data.isPresent ? snapshot.data.value : null;
                showCustomTimePicker(context: context, initial: initial).then(
                  (time) {
                    if (time != null) {
                      controller.text = time.raw.toString();
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
