import 'package:flutter/material.dart';
import 'package:tricorder_zero/utils/assets_constants.dart';

import 'image_text_button.dart';

class BottomRowOptions extends StatelessWidget {
  const BottomRowOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: ImageTextButton(
            image: AssetsConstants.artificialIntelligence,
            text: const Text('AI Results'),
            press: () {},
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsConstants.settings,
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ImageTextButton(
            image: AssetsConstants.speedTest,
            press: () {},
            text: const Text('Scan Scores'),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
