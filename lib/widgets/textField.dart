import 'package:flutter/material.dart';

import '../styling.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final iconOne;
  final iconTwo;
  final Color containerColor;
  final Color hintColor;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyBoardType;
  final TextAlign textAlign;
  final bool readOnly;
  final String initialValue;
  final int maxLines;
//validator components
  final validator;
  const CustomTextField({
    Key key,
    this.hint,
    this.iconOne,
    this.iconTwo,
    this.containerColor,
    this.hintColor,
    this.controller,
    this.validator,
    this.obscure,
    this.keyBoardType,
    this.textAlign,
    this.readOnly,
    this.initialValue,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
        BoxShadow(blurRadius: 0, color: containerColor ?? grey[200], offset: Offset(0, 0), spreadRadius: 0),
      ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 11),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          maxLines: maxLines ?? 1,
          initialValue: initialValue,
          readOnly: readOnly ?? false,
          textAlign: textAlign ?? TextAlign.center,
          keyboardType: keyBoardType,
          obscureText: obscure ?? false,
          validator: validator,
          controller: controller,
          style: TextStyle(color: black),
          cursorColor: black,
          decoration: InputDecoration(
              icon: Icon(iconOne),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: hintColor ?? grey,
              )),
        ),
      ),
    );
  }
}
