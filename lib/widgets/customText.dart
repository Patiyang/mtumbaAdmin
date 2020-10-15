import 'package:flutter/material.dart';

import '../styling.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final double letterSpacing;
  final Color color;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final int maxLines;
  final TextAlign textAlign;

  const CustomText(
      {Key key, @required this.text, this.size, this.color, this.fontWeight, this.letterSpacing, this.overflow, this.maxLines, this.textAlign, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign:textAlign ,
      maxLines: maxLines ?? 1,
      overflow: overflow ?? TextOverflow.fade,
      style: TextStyle(
          fontSize: size ?? 13.0,
          color: color ?? black,
          fontWeight: fontWeight ?? FontWeight.normal,
          letterSpacing: letterSpacing ?? 0),
    );
  }
}

class CartItemRich extends StatelessWidget {
  final String lightFont;
  final String boldFont;
  final double lightFontSize;
  final double boldFontSize;
  final double letterSpacing;
  const CartItemRich({Key key, this.lightFont, this.boldFont, this.lightFontSize, this.boldFontSize, this.letterSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: lightFont, style: TextStyle(color: black.withOpacity(.6), fontSize: lightFontSize ?? 13, fontWeight: FontWeight.bold)),
        TextSpan(text: boldFont, style: TextStyle(color: black, fontSize: boldFontSize ?? 15, fontWeight: FontWeight.bold, letterSpacing: letterSpacing)),
      ]),
    );
  }
}