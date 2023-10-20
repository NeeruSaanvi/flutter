import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants.dart';
import '../../../utils/enums.dart';
import '../../../utils/routes.dart';
import 'hexagon_button.dart';

class HomeOptions extends StatelessWidget {
  const HomeOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.ent,
                OptionType.ent,
              ),
              child: Column(
                children: const [
                  HexagonButton(src: 'assets/images/smelling.png'),
                  SizedBox(height: 8),
                  Text(
                    Constants.ent,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.eyeSkin,
                OptionType.eye,
              ),
              child: Column(
                children: const [
                  HexagonButton(src: 'assets/images/ophthalmology.png'),
                  SizedBox(height: 8),
                  Text(
                    Constants.eyeSkin,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.temperature,
                OptionType.temperature,
              ),
              child: Column(
                children: const [
                  HexagonButton(src: 'assets/images/temprature.png'),
                  SizedBox(height: 8),
                  Text(
                    Constants.temperature,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.pulse,
                OptionType.pulseO2,
              ),
              child: Column(
                children: const [
                  HexagonButton(
                    src: 'assets/images/heart-with-pulse.png',
                  ),
                  SizedBox(height: 8),
                  Text(
                    Constants.pulse,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.heart,
                OptionType.heart,
              ),
              child: Column(
                children: const [
                  HexagonButton(
                    src: 'assets/images/stethoscope.png',
                  ),
                  SizedBox(height: 8),
                  Text(
                    Constants.heart,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => _goToSelectedOptionDetails(
                context,
                Constants.ekg,
                OptionType.ekg,
              ),
              child: Column(
                children: const [
                  HexagonButton(
                    src: 'assets/images/heart-monitor.png',
                  ),
                  SizedBox(height: 8),
                  Text(
                    Constants.ekg,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: InkWell(
            onTap: () => _goToSelectedOptionDetails(
              context,
              Constants.muscle,
              OptionType.muscle,
            ),
            child: Column(
              children: const [
                HexagonButton(
                  src: 'assets/images/arms-up.png',
                ),
                SizedBox(height: 8),
                Text(
                  Constants.muscle,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _goToSelectedOptionDetails(
    BuildContext context,
    String title,
    OptionType optionType,
  ) {
    context.goNamed(Routes.homeOption, queryParams: {
      "title": title,
      "type": optionType.name,
    });
  }
}
