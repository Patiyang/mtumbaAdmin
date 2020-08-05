import 'package:flutter/material.dart';
import './customText.dart';
class FavoriteButton extends StatefulWidget {
  final Color color;
  final VoidCallback callback;
  final String text;
  final icon;
  const FavoriteButton({Key key, this.color, @required this.callback, @required this.text, @required this.icon})
      : super(key: key);
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: FlatButton.icon(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: widget.callback,
          icon: Icon(
            widget.icon,
            size: 20,
          ),
          label: CustomText(text: widget.text),
          color: widget.color,
        ),
    );
  }
}
