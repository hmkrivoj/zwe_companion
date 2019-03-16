import 'package:flutter/material.dart';

typedef String Mapper(int index);

class IntegerPicker extends StatefulWidget {
  static const DEFAULT_ITEM_EXTENT = 50.0;
  static const DEFAULT_VISIBLE_ITEM_COUNT = 3;
  static const DEFAULT_WIDTH = 80.0;
  static const DEFAULT_SELECTED_BOX_DECORATION = BoxDecoration(
    border: Border(
      top: BorderSide(
        color: Colors.black54,
      ),
      bottom: BorderSide(
        color: Colors.black54,
      ),
    ),
  );

  /// The number of displayed items. It is used together with [itemExtent] to
  /// determine this numberpicker's height.
  final int visibleItemCount;

  /// The total count of items in this number picker.
  final int itemCount;

  /// The height of a single item. It is used together with [visibleItemCount]
  /// to determine this numberpicker's height.
  final double itemExtent;

  /// The width of this numberpicker.
  final double width;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final FixedExtentScrollController controller;

  /// An optional listener that's called when the centered item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// An optional function for mapping the integers into strings.
  final Mapper textMapper;

  /// The BoxDecoration the centered item.
  final BoxDecoration selectedBoxDecoration;

  /// The TextStyle of not centered items.
  final TextStyle unselectedTextStyle;

  /// The TextStyle of the centered item.
  final TextStyle selectedTextStyle;

  IntegerPicker({
    Key key,
    this.itemExtent = DEFAULT_ITEM_EXTENT,
    this.visibleItemCount = DEFAULT_VISIBLE_ITEM_COUNT,
    this.width = DEFAULT_WIDTH,
    this.selectedBoxDecoration = DEFAULT_SELECTED_BOX_DECORATION,
    this.onSelectedItemChanged,
    this.unselectedTextStyle,
    this.selectedTextStyle,
    this.textMapper,
    @required this.itemCount,
    @required this.controller,
  })  : assert(visibleItemCount > 0 && visibleItemCount.isOdd),
        assert(itemExtent > 0),
        assert(width > 0),
        super(key: key);

  @override
  IntegerPickerState createState() => IntegerPickerState();
}

class IntegerPickerState extends State<IntegerPicker> {
  int _selected = 0;

  @override
  void initState() {
    _selected = widget.controller.initialItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.visibleItemCount * widget.itemExtent,
      width: widget.width,
      child: Stack(
        children: <Widget>[
          ListWheelScrollView.useDelegate(
            physics: FixedExtentScrollPhysics(),
            itemExtent: widget.itemExtent,
            // Flattening the wheel by making the diameter ridiculously big
            diameterRatio: 1337.0,
            controller: widget.controller,
            onSelectedItemChanged: _onSelectedItemChanged,
            childDelegate: ListWheelChildLoopingListDelegate(
              children: List.generate(widget.itemCount, (index) => index)
                  .map((index) {
                final text = widget.textMapper != null
                    ? widget.textMapper(index)
                    : index.toString();
                return Center(
                    child: _selected == index
                        ? _buildSelectedItem(text)
                        : _buildUnselectedItem(text));
              }).toList(),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                  width: widget.width,
                  height: widget.itemExtent,
                  decoration: widget.selectedBoxDecoration),
            ),
          )
        ],
      ),
    );
  }

  void _onSelectedItemChanged(newIndex) {
    setState(() {
      _selected = newIndex;
    });
    if (widget.onSelectedItemChanged != null) {
      widget.onSelectedItemChanged(newIndex);
    }
  }

  Widget _buildSelectedItem(String text) {
    final style = widget.selectedTextStyle ??
        Theme.of(context)
            .textTheme
            .body2
            .copyWith(color: Theme.of(context).accentColor);
    return Text(
      text,
      style: style,
    );
  }

  Widget _buildUnselectedItem(String text) {
    final style =
        widget.unselectedTextStyle ?? Theme.of(context).textTheme.body1;
    return Text(
      text,
      style: style,
    );
  }
}
