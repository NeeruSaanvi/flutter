import 'package:flutter/material.dart';
import 'package:tricorder_zero/pages/shared_widgets/app_background.dart';
import 'package:tricorder_zero/themes/theme_constants.dart';

import 'components/app_title.dart';
import 'components/bottom_row_options.dart';
import 'components/home_options.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      isHome: true,
      child: Column(
        children: const [
          Spacer(flex: 2),
          AppTitle(),
          Spacer(),
          HomeOptions(),
          Spacer(),
          BottomRowOptions(),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
