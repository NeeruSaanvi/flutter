import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

class HexagonButton extends StatelessWidget {
  final String src;
  const HexagonButton({
    Key? key,
    required this.src,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: ClipPolygon(
            sides: 6,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(color: Colors.white24),
              ),
            ),
          ),
        ),
        Positioned(
          top: 24,
          bottom: 24,
          left: 24,
          right: 24,
          child: ClipPolygon(
            sides: 6,
            child: Container(
              height: 40,
              width: 40,
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  src,
                  width: 40,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
