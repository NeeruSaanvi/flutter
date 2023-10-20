import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bottom_menu.dart';
import '../providers/providers.dart';
import 'shared_widgets/app_background.dart';

class HomeGroup extends ConsumerStatefulWidget {
  const HomeGroup({Key? key}) : super(key: key);

  @override
  _HomeGroupState createState() => _HomeGroupState();
}

class _HomeGroupState extends ConsumerState<HomeGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    ref.read(provideStateController).setAnimationController(_controller);
    ref.read(provideStateController).pushWidget();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    ref.read(provideStateController).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateController = ref.watch(provideStateController);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AppBackground(
        isHome: true,
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.ease,
          duration: const Duration(milliseconds: 700),
          child: bottomMenus[stateController.selectedMenuIndex].widget,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    bool canPop = ref.read(provideStateController).pop();
    return !canPop;
  }
}
