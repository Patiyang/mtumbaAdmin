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
  final Color buttonColor;
  final double size;

  const CustomButton({Key key, @required this.callback, this.icon, @required this.text, this.color, this.size, this.buttonColor}) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: widget.buttonColor,
      splashColor: orange,
      onPressed: widget.callback,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.color,
            ),
            CustomText(maxLines: 2,
              text: widget.text,
              color: widget.color,
              fontWeight: FontWeight.normal,
              size: widget.size ?? 13,
            ),
          ],
        ),
      ),
    );
  }
}
