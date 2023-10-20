import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

class HexagonBackground extends StatelessWidget {
  final String src;
  final double iconWidth;
  const HexagonBackground({Key? key, required this.src, this.iconWidth = 32})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPolygon(
      sides: 6,
      child: Container(
        height: 40,
        width: 40,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            src,
            width: iconWidth,
          ),
        ),
      ),
    );
  }
}
