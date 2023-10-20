import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/bottom_menu.dart';

class AppStateController extends ChangeNotifier {
  int _selectedMenuIndex = 0;

  int get selectedMenuIndex => _selectedMenuIndex;

  late AnimationController _animationController;

  final Tween<Offset> _offset = Tween(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  );

  late Animation<Offset> offset;

  void setAnimationController(AnimationController _controller) {
    _animationController = _controller;
    offset = _offset.animate(CurvedAnimation(
      curve: Curves.easeIn,
      parent: _controller,
    ));
  }

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  void toggleRecording() {
    _isRecording = !_isRecording;
    if (_isRecording) {
      startRecording();
    } else {
      stopRecording();
    }
    notifyListeners();
  }

  void disposeController() {
    _animationController.dispose();
  }

  void setMenuIndex(int index) {
    debugPrint('bottom index: $index');
    if (_selectedMenuIndex == index) return;
    _selectedMenuIndex = index;
    // updateBottomMenus(showFullScan: index == 0);
    pushWidget();
    notifyListeners();
    _animationController.forward();
  }

  AppStack<BottomMenu> stack = AppStack();
  void pushWidget() {
    stack.push(bottomMenus[selectedMenuIndex]);
  }

  bool pop() {
    bool canPop = !stack.hasOnlyOne;
    if (canPop) {
      stack.pop();
      debugPrint('peek id. : ${stack.peek.id}');
      _selectedMenuIndex = stack.peek.id - 1;
      notifyListeners();
      _animationController.forward();
    }
    return canPop;
  }

  bool _shouldRecord = false;

  bool get shouldRecord => _shouldRecord;

  void startRecording() {
    _imageData.clear();
    _count = 10;
    _shouldRecord = true;
  }

  void stopRecording() async {
    _shouldRecord = false;
    // writeToFile();
    createVideo();
  }

  Stream<List<int>> readToFile(/* ByteData data, String path */) async* {
    // final buffer = data.buffer;
    Directory appDocDir = await getTemporaryDirectory();
    String appDocPath = appDocDir.path;
    debugPrint('appDocPath: $appDocPath');
    final bytes = await File('$appDocPath/record.mp4').readAsBytes();
    Directory documentDir = await getApplicationDocumentsDirectory();
    String finalPath = documentDir.path;
    yield* File('$appDocPath/record.mp4').openRead();
  }

  int _count = 10;
  String? tempDir;

  /* Future<void> writeToFile(/* ByteData data, String path */) async {
    // final buffer = data.buffer;

    Directory appDocDir = await getTemporaryDirectory();

    debugPrint('appDocPath: $appDocPath');

    File('$appDocPath/record.mp4').writeAsBytes(_imageData).then((value) {
      createVideo();
    });
  } */

  final List<int> _imageData = [];
  List<int> get imageData => _imageData;
  void addImageData(List<int> data) async {
    if (tempDir == null) {
      Directory? appDocDir = await getExternalStorageDirectory();
      tempDir = appDocDir?.path;
    }
    // createImage(data);

    debugPrint('data size: ${data.length}');
    // _imageData.addAll(data);

    String imageName = 'image$_count.jpg';
    debugPrint('imageName: $imageName');

    ByteData byteData1 = await rootBundle.load('assets/images/settings.png');
    final file1 = await File('$tempDir/image1.jpg').create(recursive: true);

    final result1 = await file1.writeAsBytes(byteData1.buffer
        .asUint8List(byteData1.offsetInBytes, byteData1.lengthInBytes));

    debugPrint('result1 path: ${result1.path}');

    ByteData byteData2 = await rootBundle.load('assets/images/smelling.png');
    final file2 = await File('$tempDir/image2.jpg').create(recursive: true);

    final result2 = await file2.writeAsBytes(byteData2.buffer
        .asUint8List(byteData2.offsetInBytes, byteData2.lengthInBytes));

    debugPrint('result2 path: ${result2.path}');
    /* File('$tempDir/$imageName').writeAsBytes(data).then((file) {
      debugPrint('path: ${file.path}');
      
    }); */
    _count += 1;
  }

  /*  final List<painting.Image> _images = [];
  void createImage(List<int> data) async {
    final bytes = Uint8List.fromList(data);
    final codec = await painting.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    _images.add(frameInfo.image);
    frameInfo.image;
  } */

  void createVideo() async {
    debugPrint('createVideo called');
    // Directory? extDir = await getExternalStorageDirectory();

    /* FFmpegKit.execute(
      '-framerate 0 -i $tempDir/image%d.jpg $tempDir/record.mp4',
    ).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // SUCCESS

        debugPrint('create video success: $returnCode');
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
        debugPrint('create video isCancel: $returnCode');
      } else {
        // ERROR
        debugPrint('create video error:');
      }
    }); */
  }
}

class AppStack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get hasOnlyOne => _list.length == 1;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
