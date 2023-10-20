import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:go_router/go_router.dart';

import '../../themes/theme_constants.dart';
import '../../utils/constants.dart';
import '../shared_widgets/app_background.dart';
import '../telemedicine/components/header.dart';
import '../telemedicine/telemedicine_screen.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      child: Column(
        children: [
          Header(
            title: Constants.medications,
            backPress: () => context.pop(),
            menuPress: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Text('Active Medications'),
                          Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ).asGlass(clipBorderRadius: BorderRadius.circular(8)),
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        OptionTile(
                          iconSrc: 'assets/images/pill.png',
                          text1: 'Citalopram 10mg Tab (tor)',
                          text2: 'Generic for Celexa 10mg tablet',
                          text3: 'Film-coated tan round tablet',
                          showIcon: false,
                        ),
                        SizedBox(height: 16),
                        OptionTile(
                          iconSrc: 'assets/images/pill.png',
                          text1: 'Pravastain Sodium 40mg Tab',
                          text2: 'Generic for Pravastain 40mg tablet',
                          text3: 'Light green round tablet',
                          showIcon: false,
                        ),
                        SizedBox(height: 16),
                        OptionTile(
                          iconSrc: 'assets/images/pill.png',
                          text1: 'Zetia Oral Tablet 10mg',
                          text2: 'Generic for Zetia 10mg tablet',
                          text3: 'White oblong tablet',
                          showIcon: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
