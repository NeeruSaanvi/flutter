import 'package:flutter/material.dart';

Widget appTitle({double fontSize = 27}) {
  return Text.rich(
    TextSpan(children: [
      TextSpan(
        text: 'TRICORDER.ZERO',
        style: TextStyle(
          fontFamily: 'Dameron',
          height: 2.0,
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 0,
        ),
      ),
      WidgetSpan(
        child: Transform.translate(
          offset: const Offset(0, -6),
          child: Text(
            'TM',
            style: TextStyle(
              fontFamily: 'Dameron',
              fontSize: fontSize - 2,
              color: Colors.white,
            ),
            //superscript is usually smaller in size
            textScaleFactor: 0.7,
          ),
        ),
      ),
    ]),
  );
}
