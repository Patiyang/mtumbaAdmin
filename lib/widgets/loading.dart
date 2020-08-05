import 'package:flutter/material.dart';
import './customText.dart';
import '../styling.dart';

class Loading extends StatelessWidget {
  final String text;
  final Color color;

  const Loading({Key key, this.text, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      color:color?? white.withOpacity(.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          CustomText(text: text ?? 'Loading...')
        ],
      ),
    );
  }
}
