import 'package:flutter/material.dart';
import '../styling.dart';
import 'customText.dart';


///like all the widgets in ths folder, these widgets are meant to make deisgn easier
///rather than repeading the same widget over and over again, I utilize these instead
class CustomButton extends StatefulWidget {
  final VoidCallback callback;
  final icon;
  final String text;
  final Color color;
  final double size;

  const CustomButton({Key key, @required this.callback, @required this.icon, @required this.text, this.color, this.size})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: orange,
      onPressed: widget.callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            widget.icon,
            color: widget.color,
          ),
          CustomText(
            text: widget.text,
            color: widget.color,
            fontWeight: FontWeight.normal,
            size: widget.size??13,
          ),
        ],
      ),
    );
  }
}
