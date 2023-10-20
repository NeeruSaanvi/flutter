import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:go_router/go_router.dart';

import '../../utils/assets_constants.dart';
import '../../utils/constants.dart';
import '../shared_widgets/app_background.dart';
import '../shared_widgets/hexagon_bg.dart';
import 'components/header.dart';

class TelemedicineScreen extends ConsumerWidget {
  const TelemedicineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      child: Column(
        children: [
          Header(
            title: Constants.teleHealth,
            backPress: () => context.pop(),
            menuPress: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Choose a video visit\n",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                      children: [
                        TextSpan(
                          text: 'that is right for you',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: const [
                        OptionTile(
                          iconSrc: AssetsConstants.nurse,
                          text1: 'See first available',
                          text2: 'Board-certified providers',
                          text3: 'Estimated wait: < 5 min.',
                        ),
                        SizedBox(height: 16),
                        OptionTile(
                          iconSrc: AssetsConstants.medicalDoctor,
                          text1: 'Book a medical visit',
                          text2: 'Board-certified providers',
                          text3: 'Choose your provider and time',
                        ),
                        SizedBox(height: 16),
                        OptionTile(
                          iconSrc: AssetsConstants.amiable,
                          text1: 'See mental health providers',
                          text2: 'Therapy • Psychiatry',
                          text3: 'Choose your provider and time',
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

class OptionTile extends StatelessWidget {
  final String iconSrc;
  final String text1;
  final String text2;
  final String text3;
  final bool showIcon;
  const OptionTile({
    Key? key,
    required this.iconSrc,
    required this.text1,
    required this.text2,
    required this.text3,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      // height: 90,
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Row(
          children: [
            const SizedBox(width: 8),
            SizedBox(
              height: 60,
              width: 60,
              child: HexagonBackground(src: iconSrc),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      text1,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      text2,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      text3,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (showIcon)
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.white,
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    ).asGlass(
      blurX: 13,
      blurY: 13,
      clipBorderRadius: BorderRadius.circular(16),
    );
  }
}
