import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtoScope with ChangeNotifier {
  static const entChannel = MethodChannel('tricorder/method.otoscope');
  static const pulseO2Channel = MethodChannel('tricorder/method.pulse');
  final _eventChannel = const EventChannel('tricorder/otoscope');
  final _pulseEventChannel = const EventChannel('tricorder/pulse');
  EventChannel get eventChannel => _eventChannel;
  EventChannel get pulseO2EventChannel => _pulseEventChannel;

  Future<bool> startPreview() async {
    try {
      return await entChannel.invokeMethod('startPreview');
    } on PlatformException catch (e) {
      debugPrint(e.stacktrace);
      return false;
    }
  }

  void stopPreview() async {
    try {
      await entChannel.invokeMethod('stopPreview');
    } on PlatformException catch (e) {
      debugPrint(e.stacktrace);
    }
  }

  Future<bool> startOximeter() async {
    try {
      await pulseO2Channel.invokeMethod('initOximeter');
      return true;
    } on PlatformException catch (e) {
      debugPrint('startOximeter error: ${e.stacktrace}');
      return false;
    }
  }
}

class OtoScopeData {
  Uint8List? image;
  int battery;
  bool isConnected;
  OtoScopeData({this.image, this.battery = 0, this.isConnected = false});
}
