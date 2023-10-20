import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/bottom_menu.dart';
import '../../themes/theme_constants.dart';
import '../../utils/routes.dart';
import 'gradient_text.dart';

class AppBackground extends ConsumerWidget {
  final Widget child;
  final bool isSubScreen;
  final bool isHome;
  const AppBackground({
    Key? key,
    required this.child,
    this.isSubScreen = false,
    this.isHome = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(context, size, isHome),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/bg.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }

  Container _bottomNavigationBar(BuildContext context, Size size, bool isHome) {
    updateBottomMenus(showFullScan: isHome);
    final router = GoRouter.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: bottomMenus
              .asMap()
              .entries
              .map(
                (entry) => InkWell(
                  onTap: () {
                    switch (entry.key) {
                      case 0:
                        context.goNamed(Routes.home);
                        break;
                      case 1:
                        if (isSubScreen || stacks.contains(Routes.telehealth)) {
                          context.goNamed(Routes.telehealth);
                        } else if (router.location !=
                            '/home/${Routes.telehealth}') {
                          stacks.add(Routes.telehealth);
                          context.pushNamed(Routes.telehealth);
                        }
                        break;
                      case 2:
                        if (isSubScreen ||
                            stacks.contains(Routes.medications)) {
                          context.goNamed(Routes.medications);
                        } else if (router.location !=
                            '/home/${Routes.medications}') {
                          stacks.add(Routes.medications);
                          context.pushNamed(Routes.medications);
                        }
                        break;
                      case 3:
                        if (isSubScreen || stacks.contains(Routes.myRecords)) {
                          context.goNamed(Routes.myRecords);
                        } else if (router.location !=
                            '/home/${Routes.myRecords}') {
                          stacks.add(Routes.myRecords);
                          context.pushNamed(Routes.myRecords);
                        }
                        break;
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(minWidth: size.width / 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          entry.value.iconAsset,
                          width: 36,
                        ),
                        GradientText(
                          Text(entry.value.title),
                          gradient: linearPinkBlueGradient,
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
