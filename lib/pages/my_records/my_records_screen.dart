import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:go_router/go_router.dart';

import '../../models/accounts_option.dart';
import '../../utils/constants.dart';
import '../shared_widgets/app_background.dart';
import '../shared_widgets/hexagon_bg.dart';
import '../telemedicine/components/header.dart';

class MyRecrodsScreen extends ConsumerWidget {
  const MyRecrodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      child: Column(
        children: [
          Header(
            title: Constants.myRecords,
            backPress: () => context.pop(),
            menuPress: () {},
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            HexagonBackground(
                              src: options[index].src,
                              iconWidth: 32,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              options[index].title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ).asGlass(clipBorderRadius: BorderRadius.circular(16)),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
