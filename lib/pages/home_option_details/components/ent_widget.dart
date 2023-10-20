import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';

import '../../../controllers/app_state_controller.dart';
import '../../../providers/providers.dart';
import '../../../utils/otoscope.dart';

class EntWidget extends ConsumerStatefulWidget {
  const EntWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EntWidgetState createState() => _EntWidgetState();
}

class _EntWidgetState extends ConsumerState<EntWidget> {
  List<int> imageBytes = <int>[];
  int? imageSize;
  // StreamSubscription<dynamic>? imageSubscription;
  Stream<dynamic>? imageSubscription;

  bool streamComplete = false;

  late OtoScope _otoScope;
  late AppStateController _stateController;

  @override
  void dispose() {
    // imageSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _otoScope = ref.read(provideOtoScopeInstance);
    _stateController = ref.read(provideStateController);
    startPreview();
    super.initState();
  }

  void startPreview() async {
    imageSubscription = _otoScope.eventChannel.receiveBroadcastStream();

    // .listen(onReceiveImageByte);
    final result = await _otoScope.startPreview();

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) => setState(() {}),
    );

    debugPrint('result: $result');
  }

  Map<String, dynamic> onReceiveImageByte(dynamic event) {
    // Check if this is the first event. The first event is the file size
    // if (imageSize == null && event is int && event != Constants.eof) {
    // if (event is int && event != Constants.eof) {
    // setState(() => imageSize = event);
    // return;
    // }

    // Check if this is the end-of-file event.
    // End-of-file event denotes the end of the stream
    // if (event == Constants.eof) {
    // _otoScopeStream?.cancel();
    // streamComplete = true;
    // return;
    // }

    // Receive and concatenate the image bytes
    debugPrint('event type: ${event.runtimeType}');
    final mapData = (event as Map<dynamic, dynamic>).cast<String, dynamic>();
    // final imageData = mapData['image'] as List<int>;
    // debugPrint('imageData: ${imageData.length}');
    return mapData;
    /* data.entries.forEach((element) {
      debugPrint('data key: ${element.key}');
      debugPrint('value: ${element.value}');
      debugPrint('angle value: ${data['angle'] as int}');
    }); */
    // debugPrint('angle value: ${data['angle']}');

    // Uint8List image = data['image'] as Uint8List;
    // int angle = data['angle'] as int;
    // debugPrint('angle type: $angle');
    // final byteArray = (event as List<dynamic>).cast<int>();
    // return (event as List<dynamic>).cast<int>();
    // setState(() => imageBytes = byteArray);
    // return List.empty();
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
          child: Center(
            child: StreamBuilder<dynamic>(
              stream: imageSubscription,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // final imageData = onReceiveImageByte(snapshot.data!);
                if (snapshot.data != null) {
                  final data = onReceiveImageByte(snapshot.data!);
                  final image = data['image'];
                  // final angle = data['angle'] as int;
                  if (_stateController.shouldRecord) {
                    _stateController.addImageData(image);
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(width / 2),
                    child: Image.memory(
                      Uint8List.fromList(image),
                      width: width,
                      gaplessPlayback: true,
                      height: width,
                      fit: BoxFit.fill,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
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
