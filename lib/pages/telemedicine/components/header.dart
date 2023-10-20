import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

import '../../../themes/theme_constants.dart';
import '../../shared_widgets/gradient_text.dart';
import '../../shared_widgets/hexagon_bg.dart';
import '../../shared_widgets/snippets.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.backPress,
    required this.menuPress,
    required this.title,
  }) : super(key: key);

  final VoidCallback backPress;
  final VoidCallback menuPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: backPress,
                child: const SizedBox(
                  child: HexagonBackground(
                    src: 'assets/images/chevron-left.png',
                    iconWidth: 22,
                  ),
                  height: kIconButtonHeight,
                  width: kIconButtonHeight,
                ),
              ),
              const Spacer(flex: 2),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientText(
                    appTitle(fontSize: 20),
                    gradient: linearBluePinkGradient,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontFamily: 'Thicccboi',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  )
                ],
              ),
              const Spacer(flex: 2),
              InkWell(
                onTap: menuPress,
                child: const SizedBox(
                  child: HexagonBackground(
                    src: 'assets/images/menu-squared.png',
                    iconWidth: 22,
                  ),
                  height: kIconButtonHeight,
                  width: kIconButtonHeight,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    ).asGlass();
  }
}
