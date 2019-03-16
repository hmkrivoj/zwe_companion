import 'package:flutter/material.dart';

class DropdownTextButtonWithLabelAndIcon extends StatelessWidget {
  final String text;
  final String label;
  final IconData icon;
  final Function onTap;

  DropdownTextButtonWithLabelAndIcon(
      {@required this.text,
      @required this.label,
      this.onTap,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    final color = onTap != null
        ? Theme.of(context).accentColor
        : Theme.of(context).disabledColor;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Text(label),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: color),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
