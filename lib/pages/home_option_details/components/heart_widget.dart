import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';

import '../../../controllers/app_state_controller.dart';
import '../../../providers/providers.dart';

class HeartWidget extends ConsumerStatefulWidget {
  const HeartWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HeartWidgetState createState() => _HeartWidgetState();
}

class _HeartWidgetState extends ConsumerState<HeartWidget> {
  List<int> imageBytes = <int>[];
  int? imageSize;
  // StreamSubscription<dynamic>? imageSubscription;
  Stream<dynamic>? imageSubscription;
  bool streamComplete = false;
  late AppStateController _stateController;
  Stream<List<int>> imageData = const Stream.empty();

  @override
  void initState() {
    _stateController = ref.read(provideStateController);
    super.initState();
  }

  @override
  void dispose() {
    // imageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final imageStreamUnbegun = imageSize == null && !streamComplete;
    // final imageStreamInProgress = imageSize != null && !streamComplete;
    // final imageStreamEnded = imageSize != null && streamComplete;
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.7;
    debugPrint('build method');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        SizedBox(
          height: size.height * 0.60,
        ).asGlass(
          blurX: 15,
          blurY: 15,
          clipBorderRadius: BorderRadius.circular(64),
        ),
        const Spacer(),
      ],
    );
  }
}
