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
  final TextInputType textInputType;
  final TextAlign textAlign;
  final bool readOnly;
  final String initialValue;
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
    this.textInputType,
    this.textAlign,
    this.readOnly,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), boxShadow: [
        BoxShadow(blurRadius: 0, color: containerColor ?? grey[200], offset: Offset(0, 0), spreadRadius: 0),
      ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 11),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          initialValue: initialValue,
          readOnly: readOnly ?? false,
          textAlign: textAlign ?? TextAlign.center,
          keyboardType: textInputType,
          obscureText: obscure ?? false,
          validator: validator,
          controller: controller,
          style: TextStyle(color: black),
          cursorColor: black,
          decoration: InputDecoration(
              // icon: Icon(iconOne),
              // prefixIcon: Icon(iconOne),
              // suffixIcon: Icon(iconTwo),
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
