import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:zwe_companion/model/model.dart';
import 'package:zwe_companion/util/zwe_formatter.dart';

class DurationTextfield extends StatefulWidget {
  final Stream<Optional<ZweDuration>> stream;
  final ZweDuration initialData;
  final Sink<String> sink;
  final String labelText;

  DurationTextfield({
    @required this.sink,
    Key key,
    @required this.stream,
    @required this.labelText,
    @required this.initialData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DurationTextfieldState();
}

class _DurationTextfieldState extends State<DurationTextfield> {
  final TextEditingController controller = TextEditingController();
  final formatter = ZweFormatter(
    prefix: 'Entspricht ',
    suffix: 'h',
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() => widget.sink.add(controller.text));
    controller.text = '${widget.initialData.raw}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Optional<ZweDuration>>(
      initialData: Optional.of(widget.initialData),
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
          ),
        );
      },
    );
  }
}
