import 'package:flutter/material.dart';

import '../../../themes/theme_constants.dart';
import '../../shared_widgets/gradient_text.dart';

class ImageTextButton extends StatelessWidget {
  final String image;
  final Text text;
  final VoidCallback press;
  const ImageTextButton({
    Key? key,
    required this.image,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: 24,
          ),
          const SizedBox(width: 8),
          GradientText(
            text,
            style: const TextStyle(
              color: Colors.black,
            ),
            gradient: linearPinkBlueGradient,
          ),
        ],
      ),
    );
  }
}
